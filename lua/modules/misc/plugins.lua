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
        -- { "n", "gv" },
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
    setup = conf.lightspeed_setup,
    event = "BufReadPost",
    opt = true,
    config = conf.lightspeed,
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

misc({ "Krafi2/jeskape.nvim", event = "InsertEnter", config = conf.jetscape })

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
    keys = { "<C-c>", "<C-g>g", "ys", "yss", "yS", "ySS", "yS", "gS", "ds", "cS" },
    config = conf.surround,
})

misc({
    "abecodes/tabout.nvim",
    after = { "nvim-cmp" },
    wants = { "nvim-treesitter" }, -- or require if not used so far
    keys = { "<Tab>", "<S-Tab>" },
    config = function()
        require("tabout").setup({
            completion = false,
            ignore_beginning = false,
            tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = "`", close = "`" },
                { open = "(", close = ")" },
                { open = "[", close = "]" },
                { open = "{", close = "}" },
            },
        })
    end,
})

misc({
    "NMAC427/guess-indent.nvim",
    cmd = "GuessIndent",
    config = conf.guess_indent,
})

-- TODO: Might not be needed trail
misc({
    "Abstract-IDE/penvim",
    event = "BufRead",
    config = conf.pen,
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
    keys = { "__", "_a", "_j", "_r", "_d", "_D" },
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
