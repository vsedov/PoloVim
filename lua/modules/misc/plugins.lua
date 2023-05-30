local conf = require("modules.misc.config")
local misc = require("core.pack").package

misc({ "fladson/vim-kitty", ft = { "conf" } })

misc({ "onsails/diaglist.nvim", keys = { ";qq", ";qw" }, cmd = { "Qfa", "Qfb" }, config = conf.diaglist })

misc({
    "kylechui/nvim-surround",
    lazy = true,
    -- event = "VeryLazy",
    keys = {
        { "<C-#>", mode = "i" }, --
        { "ys", mode = "n" }, --
        { "yss", mode = "n" }, --
        { "yS", mode = "n" }, --
        { "ySS", mode = "n" }, --
        { "gs", mode = "v" }, --
        { "gS", mode = "v" }, --
        { "ds", mode = "n" }, --
        { "cs", mode = "n" }, --
    },
    config = conf.surround,
})
misc({
    "XXiaoA/ns-textobject.nvim",
    lazy = true,
    dependencies = { "kylechui/nvim-surround" },
    keys = {
        { "aq", mode = { "x", "o" } },
        { "iq", mode = { "x", "o" } },
    },
    config = conf.ns,
})
-- programming spell
misc({ "psliwka/vim-dirtytalk", build = "DirtytalkUpdate" })

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
    config = true,
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
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup({
            ignore_lsp = { "null-ls" },
            silent_chdir = false,
            patterns = { ".git", ".hg", ".svn", "pyproject.toml" },
        })
    end,
})

misc({
    "gbprod/stay-in-place.nvim",
    keys = {
        { ">", mode = "n" },
        { "<", mode = "n" },
        { "=", mode = "n" },
        { ">>", mode = "n" },
        { "<<", mode = "n" },
        { "==", mode = "n" },
        { ">", mode = "x" },
        { "<", mode = "x" },
        { "=", mode = "x" },
    },
    config = true,
})

misc({
    "boorboor/save.nvim",
    lazy = true,
    config = conf.autosave,
    keys = "<F4>",
})

misc({
    "ellisonleao/carbon-now.nvim",
    lazy = true,
    config = conf.carbon,
    cmd = "CarbonNow",
})

misc({
    "nacro90/numb.nvim",
    config = true,
    event = "CmdlineEnter",
})

misc({
    "shortcuts/no-neck-pain.nvim",
    lazy = true,
    keys = { "zz" },
    config = conf.noneck,
})

misc({ "tweekmonster/helpful.vim", cmd = "HelpfulVersion", ft = "help" })
