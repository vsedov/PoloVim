local overseer = require("overseer")

return {
    condition = {
        dir = "/home/viv/.config",
    },
    generator = function(_, cb)
        cb({
            {
                name = "Source File",
                builder = function()
                    vim.cmd.source(vim.fn.expand("%"))
                    return {
                        cmd = "",
                        name = "",
                        components = { "user.dispose_now" },
                    }
                end,
                priority = 59,
                params = {},
                conditions = { filetype = "lua" },
            },
            {
                name = "Source NVim Init",
                builder = function()
                    vim.cmd.source("/home/viv/.config/nvim/init.lua")
                    return {
                        cmd = "",
                        name = "",
                        components = { "user.dispose_now" },
                    }
                end,
                priority = 59,
                params = {},
            },
            {
                name = "Build and Reload XMonad",
                builder = function()
                    return {
                        name = "Reload XMonad",
                        cwd = "/home/viv/.config/xmonad",
                        cmd = "/home/viv/.config/bin/xmonadRebuild",
                        components = { "default", "unique" },
                    }
                end,
                priority = 60,
                tags = { overseer.TAG.BUILD },
                params = {},
            },
            {
                name = "Reload Kitty",
                builder = function()
                    return {
                        name = "Reload Kitty",
                        cmd = "pkill -10 kitty",
                        components = { "default", "unique" },
                    }
                end,
                priority = 60,
                params = {},
            },
            {
                name = "Log XMonad Stack",
                builder = function()
                    return {
                        name = "Log XMonad Stack",
                        cmd = { "/home/viv/.cabal/bin/xmonadctl-exe", "dump-stack" },
                        components = { "default", "unique" },
                    }
                end,
                priority = 61,
                params = {},
            },
            {
                name = "Log XMonad Stack Full",
                builder = function()
                    return {
                        name = "Log XMonad Full Stack",
                        cmd = { "/home/viv/.cabal/bin/xmonadctl-exe", "dump-full-stack" },
                        components = { "default", "unique" },
                    }
                end,
                priority = 61,
                params = {},
            },
            {
                name = "View xsession Logs",
                builder = function()
                    return {
                        name = "View xsession Logs",
                        cmd = "tail --follow --retry ~/.xsession-errors | less -S",
                        components = {
                            "default",
                            "unique",
                        },
                    }
                end,
                priority = 60,
                params = {},
            },
        })
    end,
}
