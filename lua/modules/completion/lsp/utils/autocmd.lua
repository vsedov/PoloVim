local add_cmd = vim.api.nvim_create_user_command

local function reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd([[edit]])
end

local function open_lsp_log()
    Log:info("active custom")
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
end

-- A helper function to auto-update the quickfix list when new diagnostics come
-- in and close it once everything is resolved. This functionality only runs whilst
-- the list is open.
-- similar functionality is provided by: https://github.com/onsails/diaglist.nvim
local function make_diagnostic_qf_updater()
    local cmd_id = nil
    return function()
        vim.diagnostic.setqflist({ open = false })
        as.toggle_list("quickfix")
        if not as.is_vim_list_open() and cmd_id then
            api.nvim_del_autocmd(cmd_id)
            cmd_id = nil
        end
        if cmd_id then
            return
        end
        cmd_id = api.nvim_create_autocmd("DiagnosticChanged", {
            callback = function()
                if as.is_vim_list_open() then
                    vim.diagnostic.setqflist({ open = false })
                    if #vim.fn.getqflist() == 0 then
                        as.toggle_list("quickfix")
                    end
                end
            end,
        })
    end
end

vim.api.nvim_set_hl(0, "DiagnosticHeader", { fg = "#56b6c2", bold = true })
vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
        vim.g.cursorhold_updatetime = 100
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

-- vim.cmd("command! -nargs=0 LspLog call v:lua.open_lsp_log()")
-- vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")

add_cmd("LspLog", function()
    open_lsp_log()
end, {})
add_cmd("LspRestart", function()
    reload_lsp()
end, {})

add_cmd("LspDiagnostics", function()
    make_diagnostic_qf_updater()
end, {})
