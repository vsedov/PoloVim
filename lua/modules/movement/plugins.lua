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
    event = "CursorMoved",
})

movement({
    "tpope/vim-repeat",
    lazy = true,
    event = "VeryLazy",
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
        event = "VeryLazy",
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
        event = "VeryLazy",
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
    movement({
        "ggandor/flit.nvim",
        event = "VeryLazy",
        keys = function()
            local mods = {
                ["f"] = { "n", "x", "o" },
                ["F"] = { "n", "x", "o" },
                ["t"] = { "n", "x" },
                ["T"] = { "n", "x" },
            }
            local ret = {}
            for key, modes in ipairs(mods) do
                ret[#ret + 1] = { key, mode = modes, desc = key }
            end
            return ret
        end,
        opts = {
            labeled_modes = "nx",
            opts = { equivalence_classes = {} },
        },
    })
    movement({
        "camilledejoye/nvim-lsp-selection-range",
        opts = function()
            local lsr_client = require("lsp-selection-range.client")
            return {
                get_client = lsr_client.select_by_filetype(lsr_client.select),
            }
        end,
        init = function()
            local O = {
                select = "&",
                select_outer = "<M-S-7>", -- M-&
            }

            require("modules.lsp.lsp.utils").on_attach(function(client, bufnr)
                local map = function(mode, lhs, rhs, opts)
                    if bufnr then
                        opts.buffer = bufnr
                    end
                    vim.keymap.set(mode, lhs, rhs, opts)
                end
                if O.select and client.server_capabilities.selectionRangeProvider then
                    local lsp_sel_rng = require("lsp-selection-range")
                    map("n", O.select, "v" .. O.select, { remap = true, desc = "LSP Selection Range" })
                    map("n", O.select, "v" .. O.select_outer, { remap = true, desc = "LSP Selection Range" })
                    map("x", O.select, lsp_sel_rng.expand, { desc = "LSP Selection Range" })
                    map("x", O.select_outer, O.select .. O.select, { remap = true, desc = "LSP Selection Range" }) -- TODO: use folding range
                end
            end)
        end,
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
    branch = "harpoon2",
    lazy = true,
    -- init = conf.harpoon_init,
    config = conf.harpoon,
})

--------------------------------
movement({
    "LeonHeidelbach/trailblazer.nvim",
    lazy = true,
    cond = lambda.config.movement.use_trailblazer and false,
    keys = {
        { "ma", desc = "New trail mark " },
        { "mb", desc = "Track Back" },
        { "mj", desc = "Peek Move Next Down" },
        { "mk", desc = "Peek Move Previous Up" },
        { "md", desc = "Toggle Trail Mark List" },
        { "mL", desc = "Delete All Trail Marks" },
        { "mn", desc = "Paste At Last Trail Mark" },
        { "mN", desc = "Paste At All Trail Marks" },
        { "mt", desc = "Set Trail Mark Select Mode" },
        { "m[", desc = "Switch To Next Trail Mark Stack" },
        { "m]", desc = "Switch To Previous Trail Mark Stack" },
        { "ms", desc = "Set Trail Mark Stack Sort Mode" },
    },
    config = conf.trailblazer,
})
movement({
    "chentoast/marks.nvim",
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
    event = "ModeChanged",
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
