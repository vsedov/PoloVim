OvTermNum = 0
return {
    generator = function(_, cb)
        ret = {
            {
                name = "Zsh",
                builder = function()
                    OvTermNum = OvTermNum + 1
                    return {
                        name = "zsh" .. OvTermNum,
                        cmd = "zsh",
                        components = { "default" },
                    }
                end,
                priority = 1,
                params = {},
            },
            {
                name = "Lazygit",
                builder = function()
                    return {
                        name = "lazygit",
                        cmd = "lazygit",
                        components = { "default", "unique" },
                    }
                end,
                priority = 2,
                params = {},
            },
            {
                name = "Git Commit",
                builder = function()
                    return {
                        name = "Git Commit",
                        cmd = "git commit",
                        components = { "default", "unique" },
                    }
                end,
                priority = 2,
                params = {},
            },
            {
                name = "Pomodoro",
                builder = function()
                    return {
                        name = "Pomodoro",
                        cmd = "porsmo",
                        components = { "default", "unique" },
                    }
                end,
                priority = 3,
                params = {},
            },
            {
                name = "Lazydocker",
                builder = function()
                    return {
                        name = "lazydocker",
                        cmd = "lazydocker",
                        components = { "default", "unique" },
                    }
                end,
                priority = 3,
                params = {},
            },
            {
                name = "System Info (btop)",
                builder = function()
                    return {
                        name = "btop",
                        cmd = "btop",
                        components = { "default", "unique" },
                    }
                end,
                priority = 3,
                params = {},
            },
            {
                name = "Edit Directory",
                builder = function()
                    return {
                        name = "edir",
                        cmd = "fish -c 'fd -HL | edir -Z'",
                    }
                end,
                priority = 5,
                params = {},
            },
            {
                name = "Build Document",
                builder = function()
                    return {
                        name = "Build Document",
                        cmd = "latexmk -synctex=1 -f -silent",
                        components = { "default", "unique" },
                    }
                end,
                priority = 5,
                condition = {
                    dir = "/home/viv/GitHub/PhD/paper/",
                },
            },
            {
                name = "Verbose Build Document",
                builder = function()
                    return {
                        name = "Build Document",
                        cmd = "latexmk -synctex=1 -f",
                        components = {
                            "default",
                            "unique",
                            {
                                "user.start_open",
                                goto_prev = true,
                            },
                        },
                    }
                end,
                priority = 5,
                condition = {
                    dir = "/home/viv/GitHub/PhD/paper/",
                },
            },
            {
                name = "Clean Build Files",
                builder = function()
                    return {
                        name = "Clean Build Files",
                        cmd = "latexmk -c",
                        components = { "default", "unique" },
                    }
                end,
                priority = 5,
                condition = {
                    dir = "/home/viv/GitHub/PhD/paper/",
                },
            },
            {
                name = "Make",
                builder = function()
                    return {
                        name = "Make",
                        cmd = vim.split(vim.o.makeprg, "%s+"),
                    }
                end,
                priority = 1000,
                condition = {
                    -- Only show if there is a more interesting make program, for make itself use the overseer built
                    -- in command.
                    callback = function()
                        return vim.go.makeprg ~= "make"
                    end,
                },
            },
            {
                name = "Open Test Outputs",
                builder = function()
                    require("neotest").output_panel.open()
                    vim.cmd("edit")
                    return { cmd = "", name = "", components = { "user.dispose_now" } }
                end,
                priority = 6,
                params = {},
            },
            {
                name = "View Animation",
                builder = function()
                    return {
                        name = "Animation",
                        cmd = "mpv --loop-file=inf /tmp/fig.gif",
                        components = { "unique", { "on_complete_dispose", timeout = 1 } },
                    }
                end,
                priority = 151,
                condition = {
                    dir = "/home/viv/Projects/PowderModel",
                },
            },
        }
        cb(ret)
    end,
}
