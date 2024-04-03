if not lambda then
    return
end

local lsp, fs, fn, api, fmt = vim.lsp, vim.fs, vim.fn, vim.api, string.format
local augroup, command = lambda.augroup, lambda.command

local icons = lambda.style.icons.lsp
local border = lambda.style.border.type_0
local diagnostic = vim.diagnostic
local L, S = vim.lsp.log_levels, vim.diagnostic.severity
local M = vim.lsp.protocol.Methods
if vim.env.DEVELOPING then
    vim.lsp.set_log_level(L.DEBUG)
end

local utils = require("modules.lsp.lsp.utils")

---@enum
local provider = {
    HOVER = "hoverProvider",
    RENAME = "renameProvider",
    CODELENS = "codeLensProvider",
    CODEACTIONS = "codeActionProvider",
    FORMATTING = "documentFormattingProvider",
    REFERENCES = "documentHighlightProvider",
    DEFINITION = "definitionProvider",
}
local get_extra_binds = function()
    local binds = {}

    binds = {
        {
            "gD",
            function()
                require("definition-or-references").definition_or_references()
            end,
            desc = "Goto Def",
        },
        {
            "gd",
            "<cmd>Lspsaga peek_definition<CR>",
            desc = "Toggle Lspsaga peek_definition",
        },

        { "gf", "<cmd>Lspsaga finder<CR>", desc = "Toggle Lspsaga finder" },
        { "cc", "<cmd>Lspsaga code_action<CR>", desc = "Toggle Lspsaga code_action" },
        {
            "gt",
            "<cmd>Lspsaga peek_type_definition<CR>",
            desc = "Toggle Lspsaga peek_type_definition",
        },
        {
            "gT",
            "<cmd>Lspsaga goto_type_definition<CR>",
            desc = "Toggle Lspsaga goto_type_definition",
        },
        {
            "gR",
            "<cmd>Lspsaga rename ++project<CR>",
            desc = "Toggle Lspsaga rename ++project",
        },

        {
            "]e",
            "<cmd>Lspsaga diagnostic_jump_prev<CR>",
            desc = "Toggle Lspsaga diagnostic_jump_prev",
        },
        {
            "[e",
            "<cmd>Lspsaga diagnostic_jump_next<CR>",
            desc = "Toggle Lspsaga diagnostic_jump_next",
        },
        {
            "[E",
            function()
                require("lspsaga.diagnostic").goto_prev({
                    severity = vim.diagnostic.severity.ERROR,
                })
            end,
            desc = "Toggle Lspsaga diagnostic_prev ERROR",
        },
        {
            "]E",
            function()
                require("lspsaga.diagnostic").goto_next({
                    severity = vim.diagnostic.severity.ERROR,
                })
            end,
            desc = "Toggle Lspsaga diagnostic_next ERROR",
        },
        {
            "gL",
            "<cmd>Lspsaga show_line_diagnostics<CR>",
            desc = "Toggle Lspsaga show_line_diagnostics",
        },

        {
            "gG",
            "<cmd>Lspsaga show_buf_diagnostics<CR>",
            desc = "Toggle Lspsaga show_buf_diagnostics",
        },
        { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Toggle Lspsaga code_action" },
        { "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", desc = "Toggle Lspsaga outgoing_calls" },
        { "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "Toggle Lspsaga incoming_calls" },
        -- {
        --     "gW",
        --     "<cmd>Lspsaga show_workspace_diagnostics<CR>",
        --     desc = "Toggle Lspsaga show_workspace_diagnostics",
        -- },
    }
    return binds
end
local buffer_mappings = {
    normal_mode = {
        {
            "K",
            utils.repeatable_hover,
            desc = "hover",
        },
    },
    visual_mode = {},
    insert_mode = {},
    extra_binds = get_extra_binds(),
}

local function setup_lsp_binds(client, bufnr)
    local mappings = {
        normal_mode = "n",
        insert_mode = "i",
        visual_mode = "v",
        extra_binds = "n",
    }
    for mode_name, mode_char in pairs(mappings) do
        -- for key, remap in pairs(buffer_mappings[mode_name]) do
        --     local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
        --     vim.keymap.set(mode_char, key, remap[1], opts)
        -- end

        for _, key in ipairs(buffer_mappings[mode_name]) do
            local opts = { buffer = bufnr, desc = key["desc"], noremap = true, silent = true }
            vim.keymap.set(mode_char, key[1], key[2], opts)
        end
    end
end

----------------------------------------------------------------------------------------------------
--  Related Locations
----------------------------------------------------------------------------------------------------
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

local handler = lsp.handlers[M.textDocument_publishDiagnostics]
---@diagnostic disable-next-line: duplicate-set-field
lsp.handlers[M.textDocument_publishDiagnostics] = function(err, result, ctx, config)
    result.diagnostics = vim.tbl_map(show_related_locations, result.diagnostics)
    handler(err, result, ctx, config)
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//
local function prev_diagnostic(lvl)
    return function()
        diagnostic.goto_prev({ float = true, severity = { min = lvl } })
    end
end
local function next_diagnostic(lvl)
    return function()
        diagnostic.goto_next({ float = true, severity = { min = lvl } })
    end
end

-----------------------------------------------------------------------------//
-- LSP SETUP/TEARDOWN
-----------------------------------------------------------------------------//

---@alias ClientOverrides {on_attach: fun(client: lsp.Client, bufnr: number), semantic_tokens: fun(bufnr: number, client: lsp.Client, token: table)}
--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic in the general on_attach function
---@type {[string]: ClientOverrides}
local client_overrides = {
    tsserver = {
        semantic_tokens = function(bufnr, client, token)
            if token.type == "variable" and token.modifiers["local"] and not token.modifiers.readonly then
                lsp.semantic_tokens.highlight_token(token, bufnr, client.id, "@danger")
            end
        end,
    },
}

-----------------------------------------------------------------------------//
-- Semantic Tokens
-----------------------------------------------------------------------------//

---@param client lsp.Client
---@param bufnr number
local function setup_semantic_tokens(client, bufnr)
    local overrides = client_overrides[client.name]
    if not overrides or not overrides.semantic_tokens then
        return
    end
    augroup(fmt("LspSemanticTokens%s", client.name), {
        {
            event = "LspTokenUpdate",
            buffer = bufnr,
            desc = fmt("Configure the semantic tokens for the %s", client.name),
            command = function(args)
                overrides.semantic_tokens(args.buf, client, args.data.token)
            end,
        },
    })
end

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
---@param client lsp.Client the lsp client
---@param bufnr number
local function on_attach(client, bufnr)
    setup_lsp_binds(client, bufnr)
    setup_semantic_tokens(client, bufnr)
end

augroup("LspSetupCommands", {
    {
        event = "LspAttach",
        desc = "setup the language server autocommands",
        command = function(args)
            --        - gd -> goto definition
            --        - gr -> goto references

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
    -- {
    --     event = "LspAttach",
    --     command = function(args)
    --         local id = vim.tbl_get(args, "data", "client_id") --[[@as lsp.Client]]
    --         if not id then
    --             return
    --         end
    --         local client = vim.lsp.get_client_by_id(id)
    --         require("lsp-inlayhints").on_attach(client, args.buf)
    --     end,
    -- },
})

-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local function reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_clients())
    vim.cmd([[edit]])
end

local function open_lsp_log()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
end

command("LspFormat", function()
    lsp.buf.format({ bufnr = 0, async = false })
end)

command("LspLog", function()
    open_lsp_log()
end, { force = true })

command("LspRestart", function()
    reload_lsp()
end, { force = true })

command("LspClients", function(opts)
    if opts.fargs ~= nil then
        for _, client in pairs(vim.lsp.get_clients()) do
            if client.name == opts.fargs[1] then
                lprint(client)
            end
        end
    else
        lprint(vim.lsp.get_clients())
    end
end, { nargs = "*" })

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
    virtual_text = false and {
        -- severity = { min = S.WARN },
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
vim.lsp.buf.cancel_formatting = function(bufnr)
    vim.schedule(function()
        bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            for id, request in pairs(client.requests or {}) do
                if
                    request.type == "pending"
                    and request.bufnr == bufnr
                    and request.method == "textDocument/formatting"
                then
                    client.cancel_request(id)
                end
            end
        end
    end)
end
