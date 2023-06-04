local conf = require("modules.movement.config")
local movement = require("core.pack").package

local leap = require("modules.movement.leap")

movement({
    "ggandor/leap.nvim",
    lazy = true,
    dependencies = { "tpope/vim-repeat" },
    config = leap.leap_config,
})

movement({
    "ggandor/leap-spooky.nvim",
    lazy = true,
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
    config = leap.leap_flit,
})

movement({
    "atusy/leap-search.nvim",
    lazy = true,
    dependencies = { "ggandor/leap.nvim" },
})

movement({
    "ziontee113/syntax-tree-surfer",
    lazy = true,
    keys = { "cU", "cD", "cd", "cu", "gfu", "gfo", "J", "cn", "cx" },
    cmd = {
        "STSSwapNextVisual",
        "STSSwapPrevVisual",
        "STSSelectChildNode",
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
    dependencies = { "pranavrao145/harpoon-tmux" },
    lazy = true,
    init = conf.harpoon_init,
    config = conf.harpoon,
})

--------------------------------
movement({
    "LeonHeidelbach/trailblazer.nvim",
    lazy = true,
    keys = {
        "ma",
        "mb",
        "mj",
        "mk",
        "ml",
        "mL",
        "mn",
        "mN",
        "mt",
        "m[",
        "m]",
        "ms",
    },
    config = function()
        require("trailblazer").setup({
            auto_save_trailblazer_state_on_exit = true,
            auto_load_trailblazer_state_on_enter = true,
            mappings = {
                nv = { -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
                    motions = {
                        new_trail_mark = "ma",
                        track_back = "mb",
                        peek_move_next_down = "mj",
                        peek_move_previous_up = "mk",
                        toggle_trail_mark_list = "ml",
                    },
                    actions = {
                        delete_all_trail_marks = "mL",
                        paste_at_last_trail_mark = "mn",
                        paste_at_all_trail_marks = "mN",
                        set_trail_mark_select_mode = "mt",
                        switch_to_next_trail_mark_stack = "m[",
                        switch_to_previous_trail_mark_stack = "m]",
                        set_trail_mark_stack_sort_mode = "ms",
                    },
                },
            },
        })
    end,
})

--  TODO: (vsedov) (10:43:27 - 01/06/23): remove this as this is no longer maintained.
movement({
    "phaazon/hop.nvim",
    lazy = true,
    config = conf.hop,
    keys = {
        "<leader><leader>s",
        "<leader><leader>j",
        "<leader><leader>k",
        "<leader><leader>w",
        "<leader><leader>l",
        "g/",
        "g,",
    },
})

movement({
    "booperlv/nvim-gomove",
    config = conf.gomove,
})

movement({ "mizlan/iswap.nvim", lazy = true, cmd = { "ISwap", "ISwapWith" }, config = conf.iswap })

--  JK  AA II
movement({
    "TheBlob42/houdini.nvim",
    lazy = true,
    event = "ModeChanged",
    config = conf.houdini,
})
--[[ jump to the first match by pressing the <Enter> key or <C-j> ; ]]
--[[ jump to any matches by typing :, then the label assigned to the match ; ]]
--[[ delete previous characters by pressing <Backspace> or <Control-h> ; ]]
--[[ delete the pattern by pressing <Control-u> ; ]]
--[[ cancel everything by pressing the <Escape> key. ]]
movement({
    "woosaaahh/sj.nvim",
    lazy = true,
    keys = {
        "<leader>sR",
        "<leader>sr",

        -- "<leader>sn",
        -- "<leader>sp",
        "<leader>sc",
        "c?",
        "c/",
        "<leader>sv",
        "<leader>sV",
        "<leader>sP",
        "<A-!>",
    },
    config = conf.sj,
})

movement({
    "mfussenegger/nvim-treehopper",
    lazy = true,
    keys = {
        { "H", mode = { "o", "x", "n" } },
        { "zl", mode = "n" },
        { "z<cr>", mode = "n" },
    },
    dependencies = { "ggandor/leap.nvim" },
    config = conf.treehopper,
})
