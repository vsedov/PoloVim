local conf = require("lazy_specs.movement.config")

-- NOTE: (vsedov) (17:18:44 - 19/07/23): Update
-- cx
--
-- On the first use, define the first {motion} to exchange. On the second use, define the second {motion} and perform the exchange.
--
-- cxx
--
-- Like cx, but use the current line.
--
-- X
--
-- Like cx, but for Visual mode.
--
-- cxc
--
-- Clear any {motion} pending for exchange.
-- Some notes
--
--     If you're using the same motion again (e.g. exchanging two words using cxiw), you can use . the second time.
--     If one region is fully contained within the other, it will replace the containing region.
--
return {
    {
        "tommcdo/vim-exchange",
        keys = {
            {
                "cx",
                "<Plug>(Exchange)",
                mode = "n",
            },
            {
                "cxx",
                "<Plug>(ExchangeLine)",
                mode = "n",
            },
            {
                ";x",
                "<Plug>(VisualExchange)",
                mode = "x",
            },
            {
                "cxc",
                "<Plug>(ClearExchange)",
                mode = "n",
            },
        },
    },
    {
        "folke/flash.nvim",
        event = "CursorMoved",
        load = function(name)
            rocks.safe_packadd({ name, "lasterisk.nvim", "vim-illuminate", "vim-repeat" })
        end,
        after = function()
            require("lazy_specs.movement.flash.setup").config()
        end,
        keys = require("lazy_specs.movement.flash.setup").binds,
    },
    -- {
    --     "nvim-gomove",
    --     event = "Insert"
    --     after = function()
    --         conf.gomove()
    --     end,
    -- },

    {
        "iswap.nvim",
        cmd = { "ISwapWith", "ISwap" },
        keys = { "<leader>cx" },
        after = function()
            conf.iswap()
        end,
    },
    {
        "vim-edgemotion",
        keys = {
            { "<c-'>", "<Plug>(edgemotion-j)", mode = "" },
            { "<c-#>", "<Plug>(edgemotion-k)", mode = "" },
        },
    },
    {
        "accelerated-jk.nvim",
        keys = {

            {
                "j",
                "<Plug>(accelerated_jk_gj)",
                mode = "n",
            },

            {
                "k",
                "<Plug>(accelerated_jk_gk)",
                mode = "n",
            },
        },
    },
    {
        "harpoon",
        opt = true,
        load = function(name)
            rocks.safe_packadd({
                name,
                "plenary.nvim",
                "yeet.nvim",
                "mini.visits",
            })
        end,
        after = function()
            require("lazy_specs.movement.harpoon")
        end,
    },
    {
        "better-escape.nvim",
        event = "InsertEnter",
        after = function()
            require("lazy_specs.movement.config").better_escape()
        end,
    },
}
