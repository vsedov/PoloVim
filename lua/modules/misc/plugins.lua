local conf = require("modules.misc.config")
local misc = require("core.pack").package

misc({ "fladson/vim-kitty", ft = { "*.conf" } })

misc({ "onsails/diaglist.nvim", keys = { ";qq", ";qw" }, cmd = { "Qfa", "Qfb" }, config = conf.diaglist })

misc({
    "kylechui/nvim-surround",
    event = "BufWinEnter",
    config = conf.surround,
})

misc({
    "NMAC427/guess-indent.nvim",
    cmd = "GuessIndent",
    lazy = true,
    init = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "indent",
            condition = lambda.config.treesitter.use_guess_indent,
            plugin = "guess-indent.nvim",
        })
    end,
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
    config = conf.autosave,
    keys = "<F4>",
    lazy = true,
})

misc({
    "ellisonleao/carbon-now.nvim",
    config = conf.carbon,
    cmd = "CarbonNow",
    lazy = true,
})

misc({
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = true,
})

misc({
    "m-demare/attempt.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    lazy = true,
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
    lazy = not lambda.config.use_session,
    cmd = {
        "Memorize",
        "Recall",
    },
})
