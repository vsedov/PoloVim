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
    "ggandor/leap-ast.nvim",
    lazy = true,
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
        "RRethy/vim-illuminate",
    },
    keys = leap.leap_search,
})
--  TODO: (vsedov) (15:48:04 - 12/06/23): need to create something for this too .
movement({
    "haya14busa/vim-asterisk",
    cond = lambda.config.movement.use_asterisk,
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
    config = function()
        require("trailblazer").setup({
            auto_save_trailblazer_state_on_exit = true,
            auto_load_trailblazer_state_on_enter = true,
            mappings = {
                nv = {
                    -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
                    motions = {
                        new_trail_mark = "ma",
                        track_back = "mb",
                        peek_move_next_down = "mj",
                        peek_move_previous_up = "mk",
                        toggle_trail_mark_list = "md",
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
movement({
    "atusy/leap-wide.nvim",
    lazy = true,
})
movement({
    "phaazon/hop.nvim",
    lazy = true,
    cmd = {
        "HopAnywhere",
        "HopChar1",
        "HopChar2",
        "HopLine",
        "HopLineStart",
        "HopVertical",
        "HopPattern",
        "HopWord",
    },
    config = conf.hop,
})
movement({
    "rlane/pounce.nvim",
    keys = {
        {
            ";gS",
            function()
                require("pounce").pounce({ do_repeat = true })
            end,
            desc = "Pounce",
        },
        {
            ";gs",
            function()
                require("pounce").pounce({ query = vim.fn.expand("<cword>"), do_repeat = true })
            end,
            desc = "Pounce word under cursor",
        },
        {
            "g?",
            function()
                require("pounce").pounce({ input = { reg = "/" } })
            end,
            desc = "Pounce last search",
        },
    },
    lazy = true,
    opts = {
        do_repeat = true,
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
        { "!", mode = { "n" } },
        { "<A-!>", mode = { "n" } },
        { "<A-,>", mode = { "n" } },
        { "<A-;>", mode = { "n" } },
        -- { "c/", mode = { "n" } },
        { ";/", mode = { "n" } },
        { "<localleader>s", mode = { "n" } },
        { "<localleader>S", mode = { "n" } },
    },
    config = conf.sj,
})

movement({
    "mfussenegger/nvim-treehopper",
    lazy = true,
    keys = {
        { "H", mode = { "o", "x", "n" } },
        { "z<cr>", mode = "n" },
        { "z;", mode = "n" },
    },
    dependencies = { "ggandor/leap.nvim" },
    config = conf.treehopper,
})
