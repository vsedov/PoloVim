return {
    -- {
    --     "noice.nvim",
    --     event = "DeferredUIEnter",
    --     after = function()
    --         require("lazy_specs.folke.noice").noice_setup()
    --     end,
    -- },
    {
        "which-key.nvim",
        event = "DeferredUIEnter",
        after = function()
            require("lazy_specs.folke.config").which_key()
        end,
    },
    {
        "edgy.nvim",
        keys = {
            {
                "<Leader>E",
                function()
                    require("edgy").toggle()
                end,
                "General: [F]orce Close Edgy",
            },
        },
        event = "BufWinEnter",
        after = function()
            require("lazy_specs.folke.config").edgy()
        end,
    },
}
