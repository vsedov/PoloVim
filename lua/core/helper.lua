-- local fn = vim.fn
local api = vim.api
local fmt = string.format
_G = _G or {}
_G.lambda = {}
require("core.lambda")
----------------------------------------------------------------------------------------------------
-- Global namespace
----------------------------------------------------------------------------------------------------
P = vim.pretty_print

-- plugin_folder()
return {
    init = function()
        _G.plugin_folder = function()
            if Plugin_folder then
                return Plugin_folder
            end
            local host = os.getenv("HOST_NAME")
            if host and host:find("vsedov") then
                Plugin_folder = [[~/GitHub/neovim]] -- vim.fn.expand("$HOME") .. '/github/'
            else
                Plugin_folder = [[vsedov/]]
            end
            return Plugin_folder
        end

        _G.plugin_debug = function()
            if Plugin_debug ~= nil then
                return Plugin_debug
            end
            local host = os.getenv("HOST_NAME")
            if host and host:find("vsedov") then
                Plugin_debug = true -- enable debug here, will be slow
            else
                Plugin_debug = false
            end
            return Plugin_debug
        end

        _G.dump = function(...)
            local objects = vim.tbl_map(vim.inspect, { ... })
            if #objects == 0 then
                print("nil")
            end
            print(unpack(objects))
            return ...
        end
    end,
}
