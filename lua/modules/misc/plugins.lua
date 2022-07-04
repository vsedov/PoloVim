local conf = require("modules.misc.config")
local misc = require("core.pack").package

misc({
    "ziontee113/syntax-tree-surfer",
    branch = "2.1",
    keys = {
        { "n", "vU" },
        { "n", "vD" },
        { "n", "vd" },
        { "n", "vu" },
        { "n", "vx" },
        { "n", "vn" },

        { "x", "J" },
        { "x", "K" },
        { "x", "H" },
        { "x", "L" },

        { "n", "gv" },
        { "n", "gfu" },
        { "n", "gif" },
        { "n", "gfo" },
        { "n", "J" },
        { "n", "gv" },
        { "x", "<A-j>" },
        { "x", "<A-k>" },

        { "n", "<C-o>" },
        { "n", "<C-p>" },

        { "n", "<c-;>" },
        { "n", "<c-'>" },

        { "n", "-" },
        { "n", "=" },
        { "n", "_" },
        { "n", "+" },
    },
    config = conf.syntax_surfer,
})

-- misc({
--     "ggandor/lightspeed.nvim",
--     setup = conf.lightspeed_setup,
--     event = "BufReadPost",
--     opt = true,
--     config = conf.lightspeed,
-- })

misc({
    "ggandor/leap.nvim",
    setup = conf.leap_setup,
    event = "BufReadPost",
    opt = true,
    config = conf.leap,
})

-- nvim-colorizer replacement
misc({
    "rrethy/vim-hexokinase",
    -- ft = { 'html','css','sass','vim','typescript','typescriptreact'},
    config = conf.hexokinase,
    run = "make hexokinase",
    opt = true,
    cmd = { "HexokinaseTurnOn", "HexokinaseToggle" },
})

-- Its hard for this because binds are weird
misc({
    "booperlv/nvim-gomove",
    event = { "CursorMoved", "CursorMovedI" },
    opt = true,
    config = conf.gomove,
})

misc({
    "mg979/vim-visual-multi",
    keys = {
        "<Ctrl>",
        "<M>",
        "<C-n>",
        "<C-n>",
        "<M-n>",
        "<S-Down>",
        "<S-Up>",
        "<M-Left>",
        "<M-i>",
        "<M-Right>",
        "<M-D>",
        "<M-Down>",
        "<C-d>",
        "<C-Down>",
        "<S-Right>",
        "<C-LeftMouse>",
        "<M-LeftMouse>",
        "<M-C-RightMouse>",
    },
    opt = true,
    setup = conf.vmulti,
})
misc({ "mbbill/undotree", opt = true, cmd = { "UndotreeToggle" } })

misc({ "mizlan/iswap.nvim", cmd = { "ISwap", "ISwapWith" }, config = conf.iswap })

misc({ "Krafi2/jeskape.nvim", event = "InsertEnter", config = conf.jetscape })

misc({ "fladson/vim-kitty", ft = { "*.conf" } })

-- Need to lazyload
misc({ "johmsalas/text-case.nvim", event = "CursorMoved", config = conf.text_case })

misc({ "chentoast/marks.nvim", opt = true, keys = { "mx", "m", "m,", "m;" }, config = conf.marks })

misc({
    "sidebar-nvim/sidebar.nvim",
    cmd = {
        "SidebarNvimToggle",
        "SidebarNvimClose",
        "SidebarNvimOpen",
        "SidebarNvimUpdate",
        "SidebarNvimFocus",
    },
    config = conf.sidebar,
})

misc({ "onsails/diaglist.nvim", keys = { ";qq", ";qw" }, cmd = { "Qfa", "Qfb" }, config = conf.diaglist })

misc({ "jlanzarotta/bufexplorer", cmd = "BufExplorer" })

misc({
    "kylechui/nvim-surround",
    keys = { "<C-v>", "<localleader>s", "<localleader>S", "yc" },
    config = conf.surround,
})

misc({
    "abecodes/tabout.nvim",
    after = { "nvim-cmp" },
    wants = { "nvim-treesitter" }, -- or require if not used so far
    keys = { "<Tab>", "<S-Tab>" },
    config = function()
        require("tabout").setup({ completion = false })
    end,
})

misc({
    "NMAC427/guess-indent.nvim",
    event = "BufEnter",
    config = conf.guess_indent,
})


misc({
    "ahmedkhalf/project.nvim",
    ft = {"python"},
    config = conf.project
})