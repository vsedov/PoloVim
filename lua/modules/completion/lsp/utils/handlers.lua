-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}
local config = require("modules.completion.lsp.utils.config")

-- TODO: Change this to fit config - call config from config.lua
function M.setup()
    vim.diagnostic.config(config.diagnostics)
    vim.diagnostic.open_float = config.open_float
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        config.virtual_text,
    })
end

function M.show_line_diagnostics()
    return vim.diagnostic.open_float(config.diagnostics.float)
end

return M
