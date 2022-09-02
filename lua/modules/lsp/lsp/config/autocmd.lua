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

--- TODO: neovim upstream should validate the buffer itself rather than each user having to implement this logic
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

--- Add lsp autocommands
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
    -- show line diagnostics
    if client.name ~= "julials" then
        require("modules.lsp.lsp.config.setup_autocmd")
    end

    local lsp_augroup = augroup_factory(bufnr, client, events)

    if lambda.config.lsp.diagnostics_hover then
        lsp_augroup(FEATURES.DIAGNOSTICS, function()
            return {
                {
                    event = { "CursorHold" },
                    buffer = bufnr,
                    desc = "LSP: Show diagnostics",   
                    command = function(args)
                        vim.diagnostic.open_float(args.buf, { scope = "cursor", focus = false })
                    end,
                },
            }
        end)
    end

    lsp_augroup(FEATURES.CODELENS, function(provider)
        return {
            {
                event = { "BufEnter", "CursorHold", "InsertLeave" },
                desc = "LSP: Code Lens",
                buffer = bufnr,
                command = function(args)
                    if check_valid_client(args.buf, provider) then
                        lsp.codelens.refresh()
                    end
                end,
            },
        }
    end)

    lsp_augroup(FEATURES.REFERENCES, function(provider)
        return {
            {
                event = { "CursorHold", "CursorHoldI" },
                buffer = bufnr,
                desc = "LSP: References",
                command = function(args)
                    if check_valid_client(args.buf, provider) then
                        lsp.buf.document_highlight()
                    end
                end,
            },
            {
                event = "CursorMoved",
                desc = "LSP: References Clear",
                buffer = bufnr,
                command = function(args)
                    if check_valid_client(args.buf, provider) then
                        lsp.buf.clear_references()
                    end
                end,
            },
        }
    end)
    vim.b[bufnr].lsp_events = events
end

return M
