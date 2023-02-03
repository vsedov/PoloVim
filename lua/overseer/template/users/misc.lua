OvTermNum = 0
return {
    generator = function(_, cb)
        ret = {
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
                        strategy = { "toggleterm", open_on_start = false, hidden = true },
                    }
                end,
                priority = 2,
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
        }
        cb(ret)
    end,
}
