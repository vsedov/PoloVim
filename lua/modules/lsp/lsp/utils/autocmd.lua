local add_cmd = vim.api.nvim_create_user_command
local fn = vim.fn
local api = vim.api
local fmt = string.format

local function reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd([[edit]])
end

local function open_lsp_log()
    Log:info("active custom")
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
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
        vim.diagnostic.setqflist({ open = false })
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
                    vim.diagnostic.setqflist({ open = false })
                    if #vim.fn.getqflist() == 0 then
                        toggle_list("quickfix")
                    end
                end
            end,
        })
    end
end

local M = {}
--- Add lsp autocommands
---@param client table<string, any>
---@param bufnr number
function M.setup_autocommands(client, bufnr)
    api.nvim_set_hl(0, "DiagnosticHeader", { fg = "#56b6c2", bold = true })

    local LspFormatting = api.nvim_create_augroup("LspFormatting", { clear = true })

    api.nvim_create_autocmd({ "BufWrite" }, {
        group = LspFormatting,
        buffer = bufnr,
        desc = "Lint the current buffer on save",
        callback = function()
            require("lint").try_lint()
        end,
    })

    api.nvim_create_autocmd("BufWritePost", {
        group = LspFormatting,
        buffer = bufnr,
        desc = "Format the current buffer on save",
        callback = function()
            vim.cmd([[FormatWrite]])
        end,
    })

    if client and client.server_capabilities.codeLensProvider then
        local LspCodeLens = api.nvim_create_augroup("LspCodeLens", { clear = true })

        api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            group = LspCodeLens,
            buffer = bufnr,
            buffer = bufnr,
            callback = function()
                vim.lsp.codelens.refresh()
            end,
        })
    end
    if client and client.server_capabilities.documentHighlightProvider then
        vim.g.cursorhold_updatetime = 100
        local LspCursorCommands = api.nvim_create_augroup("LspCursorCommands", { clear = true })
        api.nvim_create_autocmd("CursorHold", {
            pattern = "*",
            callback = function()
                -- vim.diagnostic.open_float()
                local current_cursor = vim.api.nvim_win_get_cursor(0)
                local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or { nil, nil }
                -- Show the popup diagnostics window,
                -- but only once for the current cursor location (unless moved afterwards).
                if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
                    vim.w.lsp_diagnostics_last_cursor = current_cursor
                    vim.diagnostic.open_float()
                end
            end,
        })

        api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = LspCursorCommands,
            buffer = bufnr,
            desc = "LSP: Document Highlight",
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
        api.nvim_create_autocmd("CursorMoved", {
            group = LspCursorCommands,
            buffer = bufnr,
            desc = "LSP: Document Highlight (Clear)",
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
    end

    -- commands
    add_cmd("LspLog", function()
        open_lsp_log()
    end, { force = true })

    add_cmd("LspRestart", function()
        reload_lsp()
    end, { force = true })

    add_cmd("Quickfix", function()
        make_diagnostic_qf_updater()
    end, { force = true })
end

return M
