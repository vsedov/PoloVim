local conf = require("modules.movement.config")
local movement = require("core.pack").package

movement({ "tpope/vim-repeat", lazy = true })

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
    local binds = require("modules.movement.flash.binds")
    local flash = require("modules.movement.flash.setup")
    movement({
        "folke/flash.nvim",
        dependencies = {
            { "rapan931/lasterisk.nvim", cond = lambda.config.movement.use_lasterisk },
            { "RRethy/vim-illuminate", cond = lambda.config.ui.use_illuminate },
            { "tpope/vim-repeat" },
        },
        opts = flash.opts(),
        config = flash.config,
        keys = binds,
    })
end

movement({
    "haya14busa/vim-asterisk",
    cond = lambda.config.movement.use_asterisk,
})

movement({
    "ziontee113/syntax-tree-surfer",
    lazy = true,
    keys = { "cU", "cD", "cd", "cu", "J", "cn", "cx" },
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
    config = conf.trailblazer,
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

movement({ "tommcdo/vim-exchange", keys = { "cx", desc = "Exchange" } })
