-- -- https://github.com/Oliver-Leete/Configs/tree/master/nvim/lua
local overseer = require("overseer")

return {
    condition = {
        dir = "/home/viv/.config",
    },
    generator = function(_)
        return {
            {
                name = "Reload Kitty",
                builder = function()
                    return {
                        name = "Reload Kitty",
                        cmd = "pkill -10 kitty",
                    }
                end,
                priority = 60,
                params = {},
            },
            {
                name = "View xsession Logs",
                builder = function()
                    return {
                        name = "View xsession Logs",
                        cmd = "tail --follow --retry ~/.xsession-errors | less -S",
                    }
                end,
                priority = 60,
                params = {},
            },
        }
    end,
}
