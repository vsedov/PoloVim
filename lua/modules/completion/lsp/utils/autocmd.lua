function _G.reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd([[edit]])
end

function _G.open_lsp_log()
    log:info("active custom")
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
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

vim.cmd("command! -nargs=0 LspLog call v:lua.open_lsp_log()")
vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")
