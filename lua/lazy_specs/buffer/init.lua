return {
    {
        "reach.nvim",
        cmd = "ReachOpen",
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
}
