-- https://github.com/Oliver-Leete/Configs/tree/master/nvim/lua
local overseer = require("overseer")
local constants = require("overseer.constants")
local files = require("overseer.files")
local STATUS = require("overseer.constants").STATUS
local TAG = constants.TAG

return {
    condition = {
        callback = function(opts)
            return vim.bo.filetype == "lua"
        end,
    },

    generator = function(_, cb)
        local ret = {
            {
                name = "View LSP Logs",
                builder = function()
                    return {
                        name = "View LSP Logs",
                        cmd = "tail --follow --retry ~/.local/state/nvim/lsp.log | less -S",
                        components = { "default", "unique" },
                    }
                end,
                priority = 150,
                params = {},
            },
            {
                name = "View Neovim Logs",
                builder = function()
                    return {
                        name = "View Neovim Logs",
                        cmd = "tail --follow --retry ~/.local/state/nvim/log | less -S",
                        components = { "default", "unique" },
                    }
                end,
                priority = 150,
                params = {},
            },
        }
        local logs = vim.fn.systemlist([[fd -e log]])
        for _, log in pairs(logs) do
            table.insert(ret, {
                name = "Show " .. log,
                builder = function()
                    return {
                        name = "Show " .. log,
                        cmd = "tail --follow --retry " .. log,
                        components = { "default", "unique" },
                    }
                end,
                priority = 150,
                params = {},
            })
        end
        return ret
    end,
}
