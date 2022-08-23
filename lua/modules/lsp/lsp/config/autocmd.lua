local add_cmd = vim.api.nvim_create_user_command
local fn = vim.fn
local api = vim.api
local fmt = string.format
local features = {
    FORMATTING = "formatting",
    CODELENS = "codelens",
    DIAGNOSTICS = "diagnostics",
    REFERENCES = "references",
}
local M = {}
--- Check that a buffer is valid and loaded before calling a callback
--- TODO: neovim upstream should validate the buffer itself rather than
-- each user having to implement this logic
---@param callback function
---@param buf integer
local function valid_call(callback, buf)
    if not buf or not api.nvim_buf_is_loaded(buf) or not api.nvim_buf_is_valid(buf) then
        return
    end
    callback()
end

local get_augroup = function(bufnr, method)
    assert(bufnr, "A bufnr is required to create an lsp augroup")
    return fmt("LspCommands_%d_%s", bufnr, method)
end

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
    lambda.augroup(get_augroup(bufnr, features.DIAGNOSTICS), {
        {
            event = { "CursorHold" },
            buffer = bufnr,
            desc = "LSP: Show diagnostics",
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
                    -- require'lspsaga.diagnostic'.show_line_diagnostics()
                end
            end,
        },
    })

    if client.server_capabilities.codeLensProvider then
        lambda.augroup(get_augroup(bufnr, features.CODELENS), {
            {
                event = { "BufEnter", "CursorHold", "InsertLeave" },
                desc = "LSP: Code Lens",
                buffer = bufnr,
                command = function(args)
                    valid_call(vim.lsp.codelens.refresh, args.buf)
                end,
            },
        })
    end

    if client.server_capabilities.documentHighlightProvider then
        lambda.augroup(get_augroup(bufnr, features.REFERENCES), {
            {
                event = { "CursorHold", "CursorHoldI" },
                buffer = bufnr,
                desc = "LSP: References",
                command = function(args)
                    valid_call(vim.lsp.buf.document_highlight, args.buf)
                end,
            },
            {
                event = "CursorMoved",
                desc = "LSP: References Clear",
                buffer = bufnr,
                command = function(args)
                    valid_call(vim.lsp.buf.clear_references, args.buf)
                end,
            },
        })
    end
end

return M
