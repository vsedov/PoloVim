local add_cmd = vim.api.nvim_create_user_command
local fn = vim.fn
local api = vim.api
local fmt = string.format

local function reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd([[edit]])
end

local function open_lsp_log()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
end

add_cmd("LspLog", function()
    open_lsp_log()
end, { force = true })

add_cmd("LspRestart", function()
    reload_lsp()
end, { force = true })

add_cmd("LspClients", function(opts)
    if opts.fargs ~= nil then
        for _, client in pairs(vim.lsp.get_active_clients()) do
            if client.name == opts.fargs[1] then
                lprint(client)
            end
        end
    else
        lprint(vim.lsp.get_active_clients())
    end
end, { nargs = "*" })
