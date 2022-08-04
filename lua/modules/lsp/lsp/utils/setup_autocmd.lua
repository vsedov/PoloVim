local add_cmd = vim.api.nvim_create_user_command
local fn = vim.fn
local api = vim.api
local fmt = string.format

local function reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd([[edit]])
end

local function open_lsp_log()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
end

local function is_vim_list_open()
    for _, win in ipairs(api.nvim_list_wins()) do
        local buf = api.nvim_win_get_buf(win)
        local location_list = fn.getloclist(0, { filewinid = 0 })
        local is_loc_list = location_list.filewinid > 0
        if vim.bo[buf].filetype == "qf" or is_loc_list then
            return true
        end
    end
    return false
end

local function toggle_list(list_type)
    local is_location_target = list_type == "location"
    local prefix = is_location_target and "l" or "c"
    local L = vim.log.levels
    local is_open = is_vim_list_open()
    if is_open then
        return fn.execute(prefix .. "close")
    end
    local list = is_location_target and fn.getloclist(0) or fn.getqflist()
    if vim.tbl_isempty(list) then
        local msg_prefix = (is_location_target and "Location" or "QuickFix")
        return vim.notify(msg_prefix .. " List is Empty.", L.WARN)
    end

    local winnr = fn.winnr()
    fn.execute(prefix .. "open")
    if fn.winnr() ~= winnr then
        vim.cmd("wincmd p")
    end
end

-- -- A helper function to auto-update the quickfix list when new diagnostics come
-- -- in and close it once everything is resolved. This functionality only runs whilst
-- -- the list is open.
-- -- similar functionality is provided by: https://github.com/onsails/diaglist.nvim
local function make_diagnostic_qf_updater()
    local cmd_id = nil
    return function()
        if not api.nvim_buf_is_valid(0) then
            return
        end
        pcall(vim.diagnostic.setqflist, { open = false })
        toggle_list("quickfix")
        if not is_vim_list_open() and cmd_id then
            api.nvim_del_autocmd(cmd_id)
            cmd_id = nil
        end
        if cmd_id then
            return
        end
        cmd_id = api.nvim_create_autocmd("DiagnosticChanged", {
            callback = function()
                if is_vim_list_open() then
                    pcall(vim.diagnostic.setqflist, { open = false })
                    if #fn.getqflist() == 0 then
                        toggle_list("quickfix")
                    end
                end
            end,
        })
    end
end

function update_diagnostics(global_too)
    if not vim.lsp.buf.server_ready() then
        return
    end
    if vim.fn.getloclist(vim.fn.winnr(), { title = 0 }).title == "Buffer diagnostics" then
        vim.diagnostic.setloclist({ open = false, title = "Buffer diagnostics" })
    end
    if global_too and vim.fn.getqflist({ title = 0 }).title == "Workspace diagnostics" then
        vim.diagnostic.setqflist({ open = false, title = "Workspace diagnostics" })
    end
end
-- vim.api.nvim_command('autocmd BufWinEnter * lua update_diagnostics(false)')
-- vim.api.nvim_command('autocmd User DiagnosticsChanged lua update_diagnostics(true)')

-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-k>k','<CMD>silent! lua vim.diagnostic.setloclist{ title = "Buffer diagnostics" }<CR>', {noremap=true})
-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-k><C-k>','<CMD>silent! lua vim.diagnostic.setqflist{ title = "Workspace diagnostics" }<CR>', {noremap=true})
lambda.augroup("DiagUpdate", {
    {
        event = "BufWinEnter",
        pattern = "*",
        command = "lua update_diagnostics(false)",
    },
    {
        event = "BufWinEnter",
        pattern = "DiagnosticsChanged",
        command = "lua update_diagnostics(true)')",
    },
})

add_cmd("LspLog", function()
    open_lsp_log()
end, { force = true })

add_cmd("LspRestart", function()
    reload_lsp()
end, { force = true })

add_cmd("Quickfix", function()
    make_diagnostic_qf_updater()
end, { force = true })
