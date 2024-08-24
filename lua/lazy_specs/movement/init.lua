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
        "hydra.nvim",
        -- event = "DeferredUIEnter",
        priority = 400,
        after = function()
            require("lazy_specs.hydra.setup")
        end,
    },

    {
        "harpoon",
        opt = true,
        priority = 10,
        load = function(name)
            rocks.safe_packadd({
                name,
                "plenary.nvim",
                "yeet.nvim",
                "mini.visits",
                "overseer-quick-tasks",
            })
        end,
        before = function()
            local harpoon = require("harpoon")
            local harpoonEx = require("harpoonEx")
            -- check if nvim was started with no arguments or just a dir as argument
            -- if so, try to select the first item in the harpoon list
            if
                (vim.fn.argc() == 0 or (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1))
                and vim.api.nvim_get_option_value("buftype", { buf = 0 }) == ""
            then
                vim.schedule(function()
                    harpoonEx.next_harpoon(harpoon:list(), false)
                end)
            end
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
    {
        "portal.nvim",
        after = function()
            opts = {
                window_options = {
                    border = "rounded",
                    relative = "cursor",
                    height = 5,
                },
                select_first = true,
            }
            require("portal").setup(opts)
        end,
        cmd = "Portal",
        keys = {
            {
                "<C-i>",
                function()
                    require("portal.builtin").jumplist.tunnel_forward()
                end,
                desc = "portal fwd",
            },
            {
                "<C-o>",
                function()
                    require("portal.builtin").jumplist.tunnel_backward()
                end,
                desc = "portal bwd",
            },
            -- TODO: use other queries?
        },
    },
}
