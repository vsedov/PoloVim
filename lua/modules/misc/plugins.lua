local conf = require("modules.misc.config")
local misc = require("core.pack").package

misc({
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
        { "x", "<A-j>" },
        { "x", "<A-k>" },

        { "n", "<C-o>" },
        { "n", "<C-p>" },

        { "n", "<c-;>" },
        { "n", "<c-'>" },

        { "n", "-" },
        { "n", "=" },
        { "n", "<S-+>" },
        { "n", "+" },
    },
    config = conf.syntax_surfer,
})

misc({
    "ggandor/lightspeed.nvim",
    event = "BufReadPost",
    opt = true,
    config = conf.lightspeed,
})
misc({
    "phaazon/hop.nvim",
    tag = "v2.*",
    config = conf.hop,
    event = "BufReadPost",
    opt = true,
})

-- misc({
--     "ggandor/leap.nvim",
--     setup = conf.leap_setup,
--     event = "BufReadPost",
--     opt = true,
--     config = conf.leap,
-- })

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
    keys = { "<M>" },
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

misc({
    "TheBlob42/houdini.nvim",
    event = "InsertEnter",
    config = conf.houdini,
    setup = conf.houdini_setup,
})
misc({ "fladson/vim-kitty", ft = { "*.conf" } })

misc({
    "johmsalas/text-case.nvim",
    keys = {
        "ga",
        "gau",
        "gal",
        "gas",
        "gad",
        "gan",
        "gad",
        "gaa",
        "gac",
        "gap",
        "gat",
        "gaf",
        "gaU",
        "gaL",
        "gaS",
        "gaD",
        "gaN",
        "gaD",
        "gaA",
        "gaC",
        "gaP",
        "gaT",
        "gaF",
        "geu",
        "gel",
        "ges",
        "ged",
        "gen",
        "ged",
        "gea",
        "gec",
        "gep",
        "get",
        "gef",
        "ga.",
    },
    config = conf.text_case,
})

misc({
    "chentoast/marks.nvim",
    event = "BufReadPost",
    config = conf.marks,
})

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
    "toppair/reach.nvim",
    config = conf.reach,
    opt = true,
    cmd = { "ReachOpen" },
})

misc({
    "tiagovla/scope.nvim",
    opt = true,
    setup = conf.scope_setup,
    config = conf.scope,
})

misc({
    "kylechui/nvim-surround",
    keys = { "<c-c><leader>", "<C-g>g", "ys", "yss", "yS", "ySS", "yS", "gS", "ds", "cS" },
    config = conf.surround,
})

misc({
    "NMAC427/guess-indent.nvim",
    cmd = "GuessIndent",
    opt = true,
    setup = conf.guess_indent_setup,
    config = conf.guess_indent,
})

misc({
    "lukas-reineke/headlines.nvim",
    ft = { "norg", "md" },
    config = conf.headers,
})
misc({
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { "+let g:auto_session_enabled = 0" }
    end,
})
-- programming spell
misc({ "psliwka/vim-dirtytalk", run = ":DirtytalkUpdate" })

----
misc({
    "nyngwang/NeoWell.lua",
    cmd = {
        "NeoWellToggle",
        "NeoWellAppend",
        "NeoWellJump",
        "NeoWellEdit",
        "NeoWellOut",
        "NeoWellWipeOut",
    },
    config = conf.NeoWell,
})

misc({
    "nyngwang/NeoZoom.lua",
    branch = "neo-zoom-original", -- UNCOMMENT THIS, if you prefer the old one
    cmd = { "NeoZoomToggle" },
})
misc({
    "nyngwang/NeoNoName.lua",
    cmd = { "NeoNoName" },
})

misc({
    "nyngwang/NeoRoot.lua",
    cmd = { "NeoRootSwitchMode", "NeoRootChange", "NeoRoot" },
    config = function()
        require("neo-root").setup({
            CUR_MODE = 2, -- 1 for file/buffer mode, 2 for proj-mode
        })
    end,
})
misc({
    "notjedi/nvim-rooter.lua",
    opt = true,
    config = function()
        require("nvim-rooter").setup({
            rooter_patterns = { ".git", ".hg", ".svn", "pyproject.toml" },
            trigger_patterns = { "*" },
            manual = false,
        })
    end,
})

misc({
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    opt = true,
    ft = { "norg", "markdown" },
    conf = conf.table,
})

misc({
    "gbprod/stay-in-place.nvim",
    keys = {
        { "n", ">" },
        { "n", "<" },
        { "n", "=" },
        { "n", ">>" },
        { "n", "<<" },
        { "x", ">" },
        { "x", "<" },
        { "x", "=" },
    },
    config = function()
        require("stay-in-place").setup({})
    end,
})
misc({
    "olimorris/persisted.nvim",
    setup = conf.session_setup,
    opt = true,
    config = conf.session_config,
})

misc({
    "Pocco81/auto-save.nvim",
    config = conf.autosave,
    cmd = "ASToggle",
    opt = true,
})

misc({
    "ellisonleao/carbon-now.nvim",
    config = conf.carbon,
    cmd = "CarbonNow",
    opt = true,
})
