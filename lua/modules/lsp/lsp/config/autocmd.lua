local add_cmd = vim.api.nvim_create_user_command
local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local fmt = string.format
local diagnostic = vim.diagnostic
local L = vim.lsp.log_levels

local features = {
    FORMATTING = "formatting",
    CODELENS = "codelens",
    DIAGNOSTICS = "diagnostics",
    REFERENCES = "references",
}

local get_augroup = function(bufnr, method)
    assert(bufnr, "A bufnr is required to create an lsp augroup")
    return fmt("LspCommands_%d_%s", bufnr, method)
end

---@param opts table<string, any>

---@param bufnr integer
---@param capability string
---@return table[]
local function clients_by_capability(bufnr, capability)
    return vim.tbl_filter(function(c)
        return c.server_capabilities[capability]
    end, lsp.get_active_clients({ buffer = bufnr }))
end

---@param buf integer
---@return boolean
local function is_buffer_valid(buf)
    return buf and api.nvim_buf_is_loaded(buf) and api.nvim_buf_is_valid(buf)
end

--- Check that a buffer is valid and loaded before calling a callback
--- it also ensures that a client which supports the capability is attached
---@param buf integer
---@return boolean, table[]
local function check_valid_client(buf, capability)
    if not is_buffer_valid(buf) then
        return false, {}
    end
    local clients = clients_by_capability(buf, capability)
    return next(clients) ~= nil, clients
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
                    check_valid_request(lsp.codelens.refresh, args.buf, "codeLensProvider")
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
                    if check_valid_client(args.buf, "documentHighlightProvider") then
                        lsp.buf.document_highlight()
                    end
                end,
            },
            {
                event = "CursorMoved",
                desc = "LSP: References Clear",
                buffer = bufnr,
                command = function(args)
                    if check_valid_client(args.buf, "documentHighlightProvider") then
                        lsp.buf.clear_references()
                    end
                end,
            },
        })
    end
end

return M
