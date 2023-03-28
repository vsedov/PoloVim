-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}
local api = vim.api
local lsp = vim.lsp
local fn = vim.fn
local diagnostic = vim.diagnostic
local config = require("modules.lsp.lsp.config.config")
function M.setup()
    diagnostic.config(config.diagnostics)
    diagnostic.open_float = config.open_float
    -----------------------------------------------------------------------------//
    -- Handler Overrides
    -----------------------------------------------------------------------------//
    --[[
This section overrides the default diagnostic handlers for signs and virtual text so that only
the most severe diagnostic is shown per line
--]]

    local ns = api.nvim_create_namespace("severe-diagnostics")

    --- Restricts nvim's diagnostic signs to only the single most severe one per line
    --- see `:help vim.diagnostic`
    local function max_diagnostic(callback)
        return function(_, bufnr, _, opts)
            -- Get all diagnostics from the whole buffer rather than just the
            -- diagnostics passed to the handler
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
            callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
        end
    end

    local signs_handler = diagnostic.handlers.signs
    diagnostic.handlers.signs = vim.tbl_extend("force", signs_handler, {
        show = max_diagnostic(signs_handler.show),
        hide = function(_, bufnr)
            signs_handler.hide(ns, bufnr)
        end,
    })

    local virt_text_handler = diagnostic.handlers.virtual_text
    diagnostic.handlers.virtual_text = vim.tbl_extend("force", virt_text_handler, {
        show = max_diagnostic(virt_text_handler.show),
        hide = function(_, bufnr)
            virt_text_handler.hide(ns, bufnr)
        end,
    })
end

function M.show_line_diagnostics()
    return diagnostic.open_float(config.diagnostics.float)
end

return M
