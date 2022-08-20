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
    if client.name ~= "julials" then
        require("modules.lsp.lsp.config.setup_autocmd")
    end

    local popup_toggle = false

    add_cmd("TD", function()
        popup_toggle = not popup_toggle
    end, { desc = "toggle popup diagnostic", force = true })

    if client and client.server_capabilities.codeLensProvider then
        lambda.augroup("LspCodeLens", {
            {
                event = { "BufEnter", "CursorHold", "InsertLeave" },
                buffer = bufnr,
                command = function()
                    vim.lsp.codelens.refresh()
                end,
            },
        })
    end
    if client and client.server_capabilities.documentHighlightProvider then
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
                            not (
                                current_cursor[1] == last_popup_cursor[1]
                                and current_cursor[2] == last_popup_cursor[2]
                            )
                        then
                            vim.w.lsp_diagnostics_last_cursor = current_cursor
                            vim.diagnostic.open_float(args.buf, { scope = "cursor", focus = false })
                        end
                        -- require'lspsaga.diagnostic'.show_line_diagnostics()
                    end
                end,
            },
        })
        if client.supports_method("textDocument/documentHighlight") then
            lambda.augroup("lsp_document_highlight", {

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
    end
end

return M