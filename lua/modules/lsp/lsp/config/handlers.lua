-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}

local diagnostic = vim.diagnostic
local config = require("modules.lsp.lsp.config.config")
local lsp, fs, fn, api, fmt = vim.lsp, vim.fs, vim.fn, vim.api, string.format
local diagnostic = vim.diagnostic
local L, S = vim.lsp.log_levels, vim.diagnostic.severity

local icons = lambda.style.icons.lsp
local border = lambda.style.border.type_0
function M.setup()
    ----------------------------------------------------------------------------------------------------
    --  Related Locations
    ----------------------------------------------------------------------------------------------------
    -- This relates to:
    -- 1. https://github.com/neovim/neovim/issues/19649#issuecomment-1327287313
    -- 2. https://github.com/neovim/neovim/issues/22744#issuecomment-1479366923
    -- neovim does not currently correctly report the related locations for diagnostics.
    -- TODO: once a PR for this is merged delete this workaround

    local function show_related_locations(diag)
        local related_info = diag.relatedInformation
        if not related_info or #related_info == 0 then
            return diag
        end
        for _, info in ipairs(related_info) do
            diag.message = ("%s\n%s(%d:%d)%s"):format(
                diag.message,
                fn.fnamemodify(vim.uri_to_fname(info.location.uri), ":p:."),
                info.location.range.start.line + 1,
                info.location.range.start.character + 1,
                not lambda.falsy(info.message) and (": %s"):format(info.message) or ""
            )
        end
        return diag
    end

    local handler = lsp.handlers["textDocument/publishDiagnostics"]
    ---@diagnostic disable-next-line: duplicate-set-field
    lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        result.diagnostics = vim.tbl_map(show_related_locations, result.diagnostics)
        handler(err, result, ctx, config)
    end

    -----------------------------------------------------------------------------//
    -- Signs
    -----------------------------------------------------------------------------//

    ---@param opts {highlight: string, icon: string}
    local function sign(opts)
        fn.sign_define(opts.highlight, {
            text = opts.icon,
            texthl = opts.highlight,
            linehl = opts.highlight .. "Line",
        })
    end

    sign({ highlight = "DiagnosticSignError", icon = icons.error })
    sign({ highlight = "DiagnosticSignWarn", icon = icons.warn })
    sign({ highlight = "DiagnosticSignInfo", icon = icons.info })
    sign({ highlight = "DiagnosticSignHint", icon = icons.hint })
    -----------------------------------------------------------------------------//
    -- Handler Overrides
    -----------------------------------------------------------------------------//
    -- This section overrides the default diagnostic handlers for signs and virtual text so that only
    -- the most severe diagnostic is shown per line

    --- The custom namespace is so that ALL diagnostics across all namespaces can be aggregated
    --- including diagnostics from plugins
    if lambda.config.lsp.only_severe_diagnostics then
        local ns = api.nvim_create_namespace("severe-diagnostics")

        --- Restricts nvim's diagnostic signs to only the single most severe one per line
        --- see `:help vim.diagnostic`
        ---@param callback fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
        ---@return fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
        local function max_diagnostic(callback)
            return function(_, bufnr, diagnostics, opts)
                local max_severity_per_line = vim.iter(diagnostics):fold({}, function(diag_map, d)
                    local m = diag_map[d.lnum]
                    if not m or d.severity < m.severity then
                        diag_map[d.lnum] = d
                    end
                    return diag_map
                end)
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
    end
    -----------------------------------------------------------------------------//
    -- Diagnostic Configuration
    -----------------------------------------------------------------------------//
    local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
    local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

    diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        signs = {
            severity = { min = S.WARN },
        },
        virtual_text = false and {
            severity = { min = S.WARN },
            spacing = 1,
            prefix = function(d)
                local level = diagnostic.severity[d.severity]
                return icons[level:lower()]
            end,
        },
        float = {
            max_width = max_width,
            max_height = max_height,
            border = border,
            title = { { "  ", "DiagnosticFloatTitleIcon" }, { "Problems  ", "DiagnosticFloatTitle" } },
            focusable = true,
            scope = "cursor",
            source = "if_many",
            prefix = function(diag)
                local level = diagnostic.severity[diag.severity]
                local prefix = fmt("%s ", icons[level:lower()])
                return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
            end,
        },
    })
end

return M
