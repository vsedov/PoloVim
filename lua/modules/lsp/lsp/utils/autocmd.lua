local add_cmd = vim.api.nvim_create_user_command
local fn = vim.fn
local api = vim.api
local fmt = string.format

local M = {}
--- Add lsp autocommands
---@param client table<string, any>
---@param bufnr number
function M.setup_autocommands(client, bufnr)
    -- show line diagnostics
    vim.keymap.set("n", "D", function()
        vim.diagnostic.open_float(0, { scope = "line" })
    end, { noremap = true, silent = true, buffer = bufnr })
    local popup_toggle = true

    add_cmd("TD", function()
        popup_toggle = not popup_toggle
    end, { desc = "toggle popup diagnostic", force = true })
    if client.supports_method("textDocument/formatting") then
        lambda.augroup("FormatLint", {
            {
                event = "BufWritePre",
                pattern = "*",
                command = function()
                    vim.lsp.buf.format({ timeout_ms = 2000 })
                end,
            },
        })
    end

    lambda.augroup("LspCursorCommands", {
        {
            event = { "CursorHold" },
            buffer = bufnr,
            command = function(args)
                if popup_toggle then
                    local current_cursor = vim.api.nvim_win_get_cursor(0)
                    local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or { nil, nil }
                    -- Show the popup diagnostics window,
                    -- but only once for the current cursor location (unless moved afterwards).
                    if
                        not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2])
                    then
                        vim.w.lsp_diagnostics_last_cursor = current_cursor
                        vim.diagnostic.open_float(args.buf, { scope = "cursor", focus = false })
                    end
                end
            end,
        },
        {
            event = { "CursorHold", "CursorHoldI" },
            buffer = bufnr,
            description = "LSP: Document Highlight",
            command = function()
                pcall(vim.lsp.buf.document_highlight)
            end,
        },
        {
            event = "CursorMoved",
            description = "LSP: Document Highlight (Clear)",
            buffer = bufnr,
            command = function()
                vim.lsp.buf.clear_references()
            end,
        },
    })
end

return M
