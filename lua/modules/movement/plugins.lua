local conf = require("modules.movement.config")
local movement = require("core.pack").package

-- -- --------------------------------

movement({
    "ggandor/lightspeed.nvim",
    dependencies = { "tpope/vim-repeat" },
    event = "VeryLazy",
    config = conf.lightspeed,
})

movement({
    "ggandor/leap.nvim",
    dependencies = { "ggandor/leap.nvim" },
    lazy = true,
    init = function()
        vim.keymap.set("n", "f", "f")
        vim.keymap.set("n", "F", "F")
        vim.keymap.set("n", "t", "t")
        vim.keymap.set("n", "T", "T")
    end,
})

movement({
    "ggandor/leap-spooky.nvim",
    lazy = true,
    dependencies = { "ggandor/leap.nvim" },
})

movement({
    "ggandor/flit.nvim",
    lazy = true,
    dependencies = { "ggandor/leap.nvim" },
})

--------------------------------

movement({
    "unblevable/quick-scope",
    lazy = true,
    config = conf.quick_scope,
})
--------------------------------
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
    "cbochs/portal.nvim",
    lazy = true,
    dependencies = {
        "ThePrimeagen/harpoon",
        "cbochs/grapple.nvim",
    },
})
movement({
    "cbochs/grapple.nvim",
    lazy = true,
    config = conf.grapple,
})
movement({ "ThePrimeagen/harpoon", lazy = true, config = conf.harpoon })

--------------------------------

-- requirment:
-- /home/viv/.config/nvim/init.lua|2,0
-- need to create .cache/nvim/lazymark.nvim
-- then need to add some random stuff on the file
-- like NONE
-- then make a mark , it wil then work .
movement({
    "LintaoAmons/lazymark.nvim",
    lazy = true,
})

--
--------------------------------
movement({
    "0x00-ketsu/easymark.nvim",
    lazy = true,
    config = conf.easymark,
})

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
    lazy = true,
    keys = { "<M>" },
    config = conf.gomove,
})

movement({ "mizlan/iswap.nvim", lazy = true, cmd = { "ISwap", "ISwapWith" }, config = conf.iswap })

--  JK  AA II
movement({
    "TheBlob42/houdini.nvim",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },
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
        "<leader>sn",
        "<leader>sp",
        "<leader>sc",
        "c?",
        "c/",
        "<leader>sv",
        "<leader>sV",
        "<leader>sP",
        "<c-b>",
        "<A-!>",
    },
    config = conf.sj,
})
