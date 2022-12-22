local conf = require("modules.movement.config")
local movement = require("core.pack").package

movement({
    "ziontee113/syntax-tree-surfer",
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
-- --------------------------------

movement({
    "ggandor/lightspeed.nvim",
    requires = { "tpope/vim-repeat" },
    config = conf.lightspeed,
})

movement({
    "ggandor/leap.nvim",
    requires = { "tpope/vim-repeat" },
    after = "lightspeed.nvim",
    setup = function()
        vim.keymap.set("n", "f", "f")
        vim.keymap.set("n", "F", "F")
        vim.keymap.set("n", "t", "t")
        vim.keymap.set("n", "T", "T")
    end,
})

movement({
    "ggandor/leap-spooky.nvim",
    after = "leap.nvim",
})

movement({
    "ggandor/flit.nvim",
    after = "leap.nvim",
})

--------------------------------

movement({
    "unblevable/quick-scope",
    opt = true,
    setup = function()
        if lambda.config.use_quick_scope then
            vim.keymap.set("n", "f", "f")
            vim.keymap.set("n", "F", "F")
            vim.keymap.set("n", "t", "t")
            vim.keymap.set("n", "T", "T")
        end

        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "quick_scope",
            condition = lambda.config.use_quick_scope, -- reverse
            plugin = "quick-scope",
        })
    end,
    config = conf.quick_scope,
})
--------------------------------

movement({
    "cbochs/portal.nvim",
    opt = true,
    requires = {
        "ThePrimeagen/harpoon",
        "cbochs/grapple.nvim",
    },
})
movement({
    "cbochs/grapple.nvim",
    opt = true,
    -- after = "lightspeed.nvim",
    config = conf.grapple,
})
movement({ "ThePrimeagen/harpoon", module = "harpoon", opt = true, config = conf.harpoon })
movement({ "gaborvecsei/memento.nvim", opt = true, module = "memento", after = "harpoon" })

--------------------------------

-- requirment:
-- /home/viv/.config/nvim/init.lua|2,0
-- need to create .cache/nvim/lazymark.nvim
-- then need to add some random stuff on the file
-- like NONE
-- then make a mark , it wil then work .
movement({
    "LintaoAmons/lazymark.nvim",
    modules = "lazymark",
    -- config = function()
    -- vim.g.lazymark_settings.persist_mark_dir = vim.fn.stdpath("cache") .. "/lazymark.nvim"
    -- end
})

-- movement({
--     "crusj/bookmarks.nvim",
--     branch = "main",
--     requires = {
--         "nvim-tree/nvim-web-devicons",
--         "nvim-treesitter/nvim-treesitter",
--     },
--     keys = {
--         "<tab><tab>",
--         "\\a",
--         "\\o",
--     },
--     config = conf.bookmark,
-- })
--
--------------------------------
movement({
    "0x00-ketsu/easymark.nvim",
    modules = "easymark",
    config = conf.easymark,
})

movement({
    "phaazon/hop.nvim",
    tag = "v2.*",
    config = conf.hop,
    opt = true,
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
    keys = { "<M>" },
    opt = true,
    config = conf.gomove,
})

movement({ "mizlan/iswap.nvim", cmd = { "ISwap", "ISwapWith" }, config = conf.iswap })

--  JK  AA II
movement({
    "TheBlob42/houdini.nvim",
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
