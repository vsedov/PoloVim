local lsp, fs, fn, api, fmt = vim.lsp, vim.fs, vim.fn, vim.api, string.format
local diagnostic = vim.diagnostic
local L, S = vim.lsp.log_levels, vim.diagnostic.severity

local augroup = lambda.augroup

if vim.env.DEVELOPING then
    vim.lsp.set_log_level(L.DEBUG)
end

---@enum
local provider = {
    HOVER = "hoverProvider",
    RENAME = "renameProvider",
    CODELENS = "codeLensProvider",
    CODEACTIONS = "codeActionProvider",
    REFERENCES = "documentHighlightProvider",
    DEFINITION = "definitionProvider",
}

-----------------------------------------------------------------------------//
-- LSP SETUP/TEARDOWN
-----------------------------------------------------------------------------//

---@alias ClientOverrides {on_attach: fun(client: lsp.Client, bufnr: number), semantic_tokens: fun(bufnr: number, client: lsp.Client, token: table)}

--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic in the general on_Attach function
---@type {[string]: ClientOverrides}
local client_overrides = {
    tsserver = {},
}

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

---@param client lsp.Client
---@param buf integer
local function setup_autocommands(client, buf)
    if client.server_capabilities[provider.CODELENS] then
        augroup(("LspCodeLens%d"):format(buf), {
            {
                event = { "BufEnter", "InsertLeave", "BufWritePost" },
                desc = "LSP: Code Lens",
                buffer = buf,
                -- call via vimscript so that errors are silenced
                command = "silent! lua vim.lsp.codelens.refresh()",
            },
        })
    end

    if client.server_capabilities[provider.REFERENCES] then
        augroup(("LspReferences%d"):format(buf), {
            {
                event = { "CursorHold", "CursorHoldI" },

                buffer = buf,
                desc = "LSP: References",
                command = function()
                    lsp.buf.document_highlight()
                end,
            },
            {
                event = "CursorMoved",
                desc = "LSP: References Clear",
                buffer = buf,
                command = function()
                    lsp.buf.clear_references()
                end,
            },
        })
    end
end

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
---@param client lsp.Client the lsp client
---@param bufnr number
local function on_attach(client, bufnr)
    -- setup_autocommands(client, bufnr)
end

augroup("LspSetupCommands", {
    {
        event = "LspAttach",
        desc = "setup the language server autocommands",
        command = function(args)
            local current_buftype = vim.bo.buftype
            if vim.tbl_contains({ "terminal", "nofile" }, current_buftype) then
                return
            end
            local client = lsp.get_client_by_id(args.data.client_id)
            if not client then
                return
            end
            on_attach(client, args.buf)
            local overrides = client_overrides[client.name]
            if not overrides or not overrides.on_attach then
                return
            end
            overrides.on_attach(client, args.buf)
        end,
    },
    {
        event = "DiagnosticChanged",
        desc = "Update the diagnostic locations",
        command = function(args)
            diagnostic.setloclist({ open = false })
            if #args.data.diagnostics == 0 then
                vim.cmd("silent! lclose")
            end
        end,
    },
})
