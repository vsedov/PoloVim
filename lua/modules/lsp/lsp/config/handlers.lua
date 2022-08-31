-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}
local api = vim.api
local fn = vim.fn

local config = require("modules.lsp.lsp.config.config")
-- TODO: Change this to fit config - call config from config.lua
function M.setup()
    vim.diagnostic.config(config.diagnostics)
    vim.diagnostic.open_float = config.open_float
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        config.virtual_text,
    })
    local orig_signs_handler = vim.diagnostic.handlers.signs
    -- Override the built-in signs handler to aggregate signs
    vim.diagnostic.handlers.signs = {
        show = function(ns, bufnr, _, opts)
            local diagnostics = vim.diagnostic.get(bufnr)

            -- Find the "worst" diagnostic per line
            local max_severity_per_line = {}
            for _, d in pairs(diagnostics) do
                local m = max_severity_per_line[d.lnum]
                if not m or d.severity < m.severity then
                    max_severity_per_line[d.lnum] = d
                end
            end

            -- Pass the filtered diagnostics (with our custom namespace) to
            -- the original handler
            local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
            orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
        end,

        hide = orig_signs_handler.hide,
    }
end

function M.show_line_diagnostics()
    return vim.diagnostic.open_float(config.diagnostics.float)
end

return M
