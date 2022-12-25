local add_cmd = vim.api.nvim_create_user_command
local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local fmt = string.format
local diagnostic = vim.diagnostic
local L = vim.lsp.log_levels
local M = {}

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

local FEATURES = {
    DIAGNOSTICS = { name = "diagnostics" },
    CODELENS = { name = "codelens", provider = "codeLensProvider" },
    FORMATTING = { name = "formatting", provider = "documentFormattingProvider" },
    REFERENCES = { name = "references", provider = "documentHighlightProvider" },
}

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

--- Create augroups for each LSP feature and track which capabilities each client
--- registers in a buffer local table
---@param bufnr integer
---@param client table
---@param events table
---@return fun(feature: string, commands: fun(string): Autocommand[])
local function augroup_factory(bufnr, client, events)
    return function(feature, commands)
        local provider, name = feature.provider, feature.name
        if not provider or client.server_capabilities[provider] then
            events[name].group_id = lambda.augroup(fmt("LspCommands_%d_%s", bufnr, name), commands(provider))
            table.insert(events[name].clients, client.id)
        end
    end
end

local function formatting_filter(client)
    local exceptions = ({
        sql = { "sqls" },
        lua = { "sumneko_lua" },
        proto = { "null-ls" },
    })[vim.bo.filetype]

    if not exceptions then
        return true
    end
    return not vim.tbl_contains(exceptions, client.name)
end

---@param opts table<string, any>
local function format(opts)
    opts = opts or {}
    vim.lsp.buf.format({
        bufnr = opts.bufnr,
        async = opts.async,
        filter = formatting_filter,
    })
end

--- Autocommands are created per buffer per feature, i.e. if buffer 8 attaches an LSP server
--- then an augroup with the pattern `LspCommands_8_{FEATURE}` will be created. These augroups are
--- localised to a buffer because the features are local to only that buffer and when we detach we need to delete
--- the augroups by buffer so as not to turn off the LSP for other buffers. The commands are also localised
--- to features because each autocommand for a feature e.g. formatting needs to be created in an idempotent
--- fashion because this is called n number of times for each client that attaches.
---
--- So if there are 3 clients and 1 supports formatting and another code lenses, and the last only references.
--- All three features should work and be setup. If only one augroup is used per buffer for all features then each time
--- a client detaches all lsp features will be disabled. Or the augroup will be recreated for the new client but
--- as a client might not support functionality that was already in place, the augroup will be deleted and recreated
--- without the commands for the features that that client does not support.
--- TODO: find a way to make this less complex...
---@param client table<string, any>
---@param bufnr number
function M.setup_autocommands(client, bufnr)
    if not client then
        local msg = fmt("Unable to setup LSP autocommands, client for %d is missing", bufnr)
        return vim.notify(msg, "error", { title = "LSP Setup" })
    end

    local events = vim.F.if_nil(vim.b.lsp_events, {
        [FEATURES.CODELENS.name] = { clients = {}, group_id = nil },
        [FEATURES.FORMATTING.name] = { clients = {}, group_id = nil },
        [FEATURES.DIAGNOSTICS.name] = { clients = {}, group_id = nil },
        [FEATURES.REFERENCES.name] = { clients = {}, group_id = nil },
    })

    local augroup = augroup_factory(bufnr, client, events)

    -- show line diagnostics
    if client.name ~= "julials" then
        require("modules.lsp.lsp.config.setup_autocmd")
    end

    -- if lambda.config.lsp.diagnostics_hover then
    --     augroup(FEATURES.DIAGNOSTICS, function()
    --         return {
    --             {
    --                 event = { "CursorHold" },
    --                 buffer = bufnr,
    --                 desc = "LSP: Show diagnostics",
    --                 command = function(args)
    --                     if vim.b.lsp_hover_win and api.nvim_win_is_valid(vim.b.lsp_hover_win) then
    --                         return
    --                     end
    --                     vim.diagnostic.open_float(args.buf, { scope = "cursor", focus = false })
    --                 end,
    --             },
    --         }
    --     end)
    -- end

    augroup(FEATURES.FORMATTING, function(provider)
        return {
            {
                event = "BufWritePre",
                buffer = bufnr,
                desc = "LSP: Format on save",
                command = function(args)
                    if not vim.g.formatting_disabled and not vim.b.formatting_disabled then
                        local clients = clients_by_capability(args.buf, provider)
                        format({ bufnr = args.buf, async = #clients == 1 })
                    end
                end,
            },
        }
    end)

    augroup(FEATURES.CODELENS, function()
        return {
            {
                event = { "BufEnter", "CursorHold", "InsertLeave" },
                desc = "LSP: Code Lens",
                buffer = bufnr,
                command = function()
                    lsp.codelens.refresh()
                end,
            },
        }
    end)
    augroup(FEATURES.REFERENCES, function()
        return {
            {
                event = { "CursorHold", "CursorHoldI" },
                buffer = bufnr,
                desc = "LSP: References",
                command = function()
                    lsp.buf.document_highlight()
                end,
            },
            {
                event = "CursorMoved",
                desc = "LSP: References Clear",
                buffer = bufnr,
                command = function()
                    lsp.buf.clear_references()
                end,
            },
        }
    end)

    vim.b[bufnr].lsp_events = events
end
return M
