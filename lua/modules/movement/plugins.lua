local conf = require("modules.movement.config")
local movement = require("core.pack").package

movement({
    "ziontee113/syntax-tree-surfer",
    keys = {
        { "n", "vU" },
        { "n", "vD" },
        { "n", "vd" },
        { "n", "vu" },
        { "n", "vx" },
        { "n", "vn" },
        { "n", "gv" },
        { "n", "gfu" },
        { "n", "gif" },
        { "n", "gfo" },
        { "n", "J" },
    },
    config = conf.syntax_surfer,
})

movement({
    "ggandor/lightspeed.nvim",
    opt = true,
    config = conf.lightspeed,
})

movement({
    "ggandor/leap.nvim",
    opt = true,
    config = conf.leap,
})

movement({
    "ggandor/flit.nvim",
    opt = true,
    after = "leap.nvim",
    config = function()
        require("flit").setup()
    end,
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
    },
    config = conf.sj,
})

movement({ "ThePrimeagen/harpoon", module = "harpoon", opt = true, config = conf.harpoon })
movement({ "gaborvecsei/memento.nvim", opt = true, module = "memento", after = "harpoon" })

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

movement({
    "chentoast/marks.nvim",
    -- branch = "cursorhold",
    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "marks",
            condition = lambda.config.use_marks, -- reverse
            plugin = "marks.nvim",
        })
    end,
    config = conf.marks,
})

movement({
    "crusj/bookmarks.nvim",
    branch = "main",
    requires = { "nvim-tree/nvim-web-devicons" },
    -- opt = true,
    keys = {
        "<tab><tab>",
        "\\a",
        "\\d",
        "\\o",
    },
    config = conf.bookmark,
})

movement({
    "cbochs/portal.nvim",
    opt = true,
    after = "lightspeed.nvim",
    requires = {
        "cbochs/grapple.nvim",
    },
    config = conf.portal,
})
