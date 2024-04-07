local conf = require("modules.movement.config")
local movement = require("core.pack").package

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
movement({
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
            "X",
            "<Plug>(VisualExchange)",
            mode = "x",
        },
        {
            "cxc",
            "<Plug>(ClearExchange)",
            mode = "n",
        },
    },
})

if lambda.config.movement.movement_type == "leap" then
    local leap = require("modules.movement.leap")

    movement({
        "ggandor/leap.nvim",
        lazy = true,
        dependencies = { "tpope/vim-repeat" },
        config = leap.leap_config,
    })

    movement({
        "ggandor/leap-ast.nvim",
        dependencies = {
            "leap.nvim",
        },
        lazy = true,
    })
    movement({
        "ggandor/leap-spooky.nvim",
        lazy = true,
        event = { "BufReadPre", "BufNewFile", "BufEnter" },
        dependencies = {
            "leap.nvim",
        },

        opts = {
            affixes = {
                magnetic = { window = "m", cross_window = "M" },
                remote = { window = "r", cross_window = "R" },
            },
            paste_on_remote_yank = true,
        },
        keys = leap.leap_spooky(),
    })

    movement({
        "ggandor/flit.nvim",
        lazy = true,
        dependencies = { "ggandor/leap.nvim" },
        keys = function()
            local ret = {}
            for _, key in ipairs({ "f", "F", "t", "T" }) do
                ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
            end
            return ret
        end,
    })

    movement({
        "atusy/leap-search.nvim",
        dependencies = {
            { "rapan931/lasterisk.nvim", cond = lambda.config.movement.use_lasterisk },
            { "RRethy/vim-illuminate", cond = lambda.config.ui.use_illuminate },
            "leap.nvim",
        },
        lazy = true,
        keys = leap.leap_search,
    })
    -- use leap for this
    movement({
        "mfussenegger/nvim-treehopper",
        lazy = true,
        dependencies = { "ggandor/leap.nvim" },
        keys = conf.treehopper,
    })
else
    local flash = require("modules.movement.flash.setup")
    movement({
        "folke/flash.nvim",
        event = "CursorMoved",
        dependencies = {
            { "rapan931/lasterisk.nvim", cond = lambda.config.movement.use_lasterisk },
            { "RRethy/vim-illuminate", cond = lambda.config.ui.use_illuminate },
            { "tpope/vim-repeat" },
        },
        opts = flash.opts,
        config = flash.config,
        keys = flash.binds,
    })
    local leap = require("modules.movement.leap")

    movement({
        "ggandor/leap.nvim",
        event = "CursorMoved",
        lazy = true,
        dependencies = { "tpope/vim-repeat" },
        config = leap.leap_config,
        keys = leap.keys,
    })
    movement({
        "atusy/leap-search.nvim",
        dependencies = {
            { "rapan931/lasterisk.nvim", cond = lambda.config.movement.use_lasterisk },
            { "RRethy/vim-illuminate", cond = lambda.config.ui.use_illuminate },
            "leap.nvim",
        },
        lazy = true,
    })
end

movement({
    "haya14busa/vim-asterisk",
    cond = lambda.config.movement.use_asterisk,
})

movement({
    "ziontee113/syntax-tree-surfer",
    lazy = true,
    keys = { ";f" },
    cmd = {
        "STSSwapPrevVisual",
        "STSSelectChildNode",
        "STSSwapNextVisual",
        "STSSelectParentNode",
        "STSSelectPrevSiblingNode",
        "STSSelectNextSiblingNode",
        "STSSelectCurrentNode",
        "STSSelectMasterNode",
        "STSJumpToTop",
    },
    config = conf.syntax_surfer,
})

movement({
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            {
                "samharju/yeet.nvim",
                lazy = true,
            },
        },
    },
    branch = "harpoon2",
    lazy = true,
    config = conf.harpoon,
})

movement({
    "chentoast/marks.nvim",
    lazy = true,
    config = function()
        lambda.highlight.plugin("marks", {
            { MarkSignHL = { link = "Directory" } },
            { MarkSignNumHL = { link = "Directory" } },
        })

        require("marks").setup({
            force_write_shada = false, -- This can cause data loss
            excluded_filetypes = { "NeogitStatus", "NeogitCommitMessage", "toggleterm" },
            bookmark_0 = { sign = "⚑", virt_text = "->" },
            mappings = {
                set = "m",
                set_next = "m,",
                toggle = "m;",
                next = "m]",
                prev = "m[",
                preview = "m:",
                next_bookmark = "m}",
                prev_bookmark = "m{",
                delete = "dm",
                delete_line = "dm-",
                delete_bookmark = "dm=",
                delete_buf = "dm<leader>",
            },
        })
    end,
    keys = {
        {
            "m",
            desc = "Set mark",
        },

        {
            "m,",
            desc = "Set next mark",
        },

        {
            "m;",
            desc = "Toggle mark",
        },

        {
            "m]",
            desc = "Next mark",
        },

        {
            "m[",
            desc = "Prev mark",
        },

        {
            "m:",
            desc = "Preview mark",
        },

        {
            "m}",
            desc = "Next bookmark",
        },

        {
            "m{",
            desc = "Prev bookmark",
        },

        {
            "dm",
            desc = "Delete mark",
        },

        {
            "dm-",
            desc = "Delete line mark",
        },

        {
            "dm=",
            desc = "Delete bookmark",
        },

        {
            "dm<leader>",
            desc = "Delete buffer marks",
        },
    },
})

movement({
    "booperlv/nvim-gomove",
    lazy = true,
    config = conf.gomove,
})

movement({
    "mizlan/iswap.nvim",
    lazy = true,
    cmd = { "ISwapWith", "ISwap" },
    keys = { "<leader>cx" },
    config = conf.iswap,
})

--  JK  AA II
movement({
    "TheBlob42/houdini.nvim",
    lazy = true,
    event = "InsertEnter",
    config = conf.houdini,
})

movement({
    "haya14busa/vim-edgemotion",
    keys = {
        { "<c-'>", "<Plug>(edgemotion-j)", mode = "" },
        { "<c-#>", "<Plug>(edgemotion-k)", mode = "" },
    },
})

movement({
    "rainbowhxch/accelerated-jk.nvim",
    cond = lambda.config.movement.use_accelerated_jk,
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
})
