local conf = require("modules.misc.config")
local misc = require("core.pack").package

misc({ "fladson/vim-kitty", ft = { "*.conf" } })

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
    "NMAC427/guess-indent.nvim",
    lazy = true,
    cmd = "GuessIndent",
    config = conf.guess_indent,
})

misc({
    "lukas-reineke/headlines.nvim",
    ft = { "norg", "md" },
    config = conf.headers,
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
    config = conf.NeoWell,
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
-- -- TODO(vsedov) (21:01:02 - 12/08/22): I am not sure if i want to keep this or not
-- -- I have mixed feeling about this as i like using tabs, but this kinda ruins the structure
-- -- every time, so i wonder if there  is a way to avoid this error in the first place
misc({
    "notjedi/nvim-rooter.lua",
    lazy = true,
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
    lazy = true,
    config = function()
        require("project_nvim").setup({
            ignore_lsp = { "null-ls" },
            silent_chdir = true,
            patterns = { ".git", ".hg", ".svn", "pyproject.toml" },
        })
    end,
})

-- -- misc({
-- --     "gbprod/stay-in-place.nvim",
-- --     keys = {
-- --         { "n", ">" },
-- --         { "n", "<" },
-- --         { "n", "=" },
-- --         { "n", ">>" },
-- --         { "n", "<<" },
-- --         { "x", ">" },
-- --         { "x", "<" },
-- --         { "x", "=" },
-- --     },
-- --     config = function()
-- --         require("stay-in-place").setup({})
-- --     end,
-- -- })

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
    "m-demare/attempt.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
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

misc({
    "shortcuts/no-neck-pain.nvim",
    lazy = true,
    cmd = "NoNeckPain",
    keys = { "zz" },
    config = conf.noneck,
})

misc({
    "phaazon/mind.nvim",
    lazy = true,
    cmd = {
        "MindOpenMain",
        "MindOpenProject",
        "MindOpenSmartProject",
        "MindReloadState",
        "MindClose",
    },
    config = true,
})

misc({
    "EricDriussi/remember-me.nvim",
    lazy = true,
    cmd = {
        "Memorize",
        "Recall",
    },
    config = function()
        require("remember_me").setup({})
    end,
})

misc({
    "romainchapou/nostalgic-term.nvim",
    lazy = true,
    event = "TermOpen",
    config = function()
        require("nostalgic-term").setup({
            mappings = {
                { "<c-h>", "h" },
                { "<c-j>", "j" },
                { "<c-k>", "k" },
                { "<c-l>", "l" },
            },
            add_normal_mode_mappings = true,
        })
    end,
})
