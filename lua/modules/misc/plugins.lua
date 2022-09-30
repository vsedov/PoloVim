local conf = require("modules.misc.config")
local misc = require("core.pack").package

misc({ "mbbill/undotree", opt = true, cmd = { "UndotreeToggle" } })

misc({ "fladson/vim-kitty", ft = { "*.conf" } })

misc({
    "chentoast/marks.nvim",
    event = "BufReadPost",
    config = conf.marks,
})

misc({
    "crusj/bookmarks.nvim",
    branch = "main",
    requires = { "kyazdani42/nvim-web-devicons" },
    -- opt = true,
    keys = {
        "<tab><tab>",
        "\\a",
        "\\d",
        "\\o",
    },
    config = conf.bookmark,
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
    keys = { "<c-c><leader>", "<C-g>g", "ys", "yss", "yS", "ySS", "yS", "gS", "ds", "<c-/>" },
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
-- TODO(vsedov) (21:01:02 - 12/08/22): I am not sure if i want to keep this or not
-- I have mixed feeling about this as i like using tabs, but this kinda ruins the structure
-- every time, so i wonder if there  is a way to avoid this error in the first place
misc({
    lambda.use_local("nvim-rooter.lua", "personal"),
    opt = true,
    config = function()
        require("nvim-rooter").setup({
            rooter_patterns = { ".git", ".hg", ".svn", "pyproject.toml" },
            trigger_patterns = { "*" },
            manual = true,
        })
    end,
})

misc({
    "ahmedkhalf/project.nvim",
    opt = true,
    config = function()
        require("project_nvim").setup({
            ignore_lsp = { "null-ls" },
            silent_chdir = true,
            patterns = { ".git", ".hg", ".svn", "pyproject.toml" },
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

-- REVISIT viv (07:23:50 - 20/08/22): I am not sure if this is viable or not
misc({
    "boorboor/save.nvim",
    config = conf.autosave,
    keys = "<F4>",
    event = "FocusLost",
    opt = true,
})

misc({
    "ellisonleao/carbon-now.nvim",
    config = conf.carbon,
    cmd = "CarbonNow",
    opt = true,
})

misc({
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = function()
        require("numb").setup()
    end,
})

misc({
    "m-demare/attempt.nvim",
    requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    opt = true,
    config = conf.attempt,
    keys = {
        "<leader>an",
        "<leader>ai",
        "<leader>ar",
        "<leader>ad",
        "<leader>ac",
        "<leader>al",
        "<leader>aL",
    },
})
