-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}
local api = vim.api
local lsp = vim.lsp
local fn = vim.fn
local diagnostic = vim.diagnostic
local config = require("modules.lsp.lsp.config.config")
-- TODO: Change this to fit config - call config from config.lua
function M.setup()
    diagnostic.config(config.diagnostics)
    diagnostic.open_float = config.open_float
    -- Does noice overwrite this as well ?
    if not lambda.config.ui.noice.enable then
        lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
            config.virtual_text,
        })

        local ns = api.nvim_create_namespace("severe-diagnostics")

        --- Restricts nvim's diagnostic signs to only the single most severe one per line
        --- @see `:help diagnostic`
        local function max_diagnostic(callback)
            return function(_, bufnr, _, opts)
                -- Get all diagnostics from the whole buffer rather than just the
                -- diagnostics passed to the handler
                local diagnostics = diagnostic.get(bufnr)
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

        -- local virt_text_handler = diagnostic.handlers.virtual_text
        -- diagnostic.handlers.virtual_text = vim.tbl_extend("force", virt_text_handler, {
        --     show = max_diagnostic(virt_text_handler.show),
        --     hide = function(_, bufnr)
        --         virt_text_handler.hide(ns, bufnr)
        --     end,
        -- })
        -- lsp.handlers["window/showMessage"] = function(_, result, ctx)
        --     local client = lsp.get_client_by_id(ctx.client_id)
        --     local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
        --     vim.notify(result.message, lvl, {
        --         title = "LSP | " .. client.name,
        --         timeout = 8000,
        --         keep = function()
        --             return lvl == "ERROR" or lvl == "WARN"
        --         end,
        --     })
        -- end
        lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, config.float)
        lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, config.float)
    end
end

function M.show_line_diagnostics()
    return diagnostic.open_float(config.diagnostics.float)
end

return M
