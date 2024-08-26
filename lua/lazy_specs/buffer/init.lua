return {
    {
        "reach.nvim",
        event = "DeferredUIEnter",
        after = function()
            require("reach").setup({
                notifications = true,
            })
        end,
    },
    {
        "cybu.nvim",
        load = function(name)
            rocks.safe_force_packadd({ name, "nvim-web-devicons", "plenary.nvim" })
        end,
        cmd = {
            "CybuNext",
            "CybuPrev",
        },
        after = function()
            require("cbyu").setup()
            lambda.command("CybuNext", "<Plug>(CybyNext)", {})
            lambda.command("CybyPrev", "<Plug>(CybuPrev)", {})
        end,
    },
    {
        "bufexplorer",
        beforeAll = function()
            vim.g.bufExplorerDisableDefaultKeyMapping = 1
        end,

        cmd = { "BufExplorer", "ToggleBufExplorer", "BufExplorerHorizontalSplit", "BufExplorerVerticalSplit" },
    },
    {
        "bufonly.nvim",
        cmd = "BufOnly",
    },
    {
        "barbar.nvim",
        event = "DeferredUIEnter",
        beforeAll = function()
            vim.g.barbar_auto_setup = true
        end,
        after = function()
            require("barbar").setup({ aimation = false })
        end,
    },
    {
        "scope.nvim",
        event = "DeferredUIEnter",
        after = function()
            require("scope").setup({
                hooks = {
                    pre_tab_leave = function()
                        vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabLeavePre" })
                        -- [other statements]
                    end,

                    post_tab_enter = function()
                        vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabEnterPost" })
                        -- [other statements]
                    end,

                    -- [other hooks]
                },

                -- [other options]
            })
        end,
    },
    {
        "stickybuf.nvim",
        after = function()
            require("stickybuf").setup({
                get_auto_pin = function(bufnr)
                    return require("stickybuf").should_auto_pin(bufnr)
                end,
            })
        end,
    },
}
