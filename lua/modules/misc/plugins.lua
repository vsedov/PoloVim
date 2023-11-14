local conf = require("modules.misc.config")
local misc = require("core.pack").package

misc({ "fladson/vim-kitty", ft = { "conf" } })

misc({ "onsails/diaglist.nvim", keys = { "<leader>qw", "<leader>qf" }, cmd = { "Qfa", "Qfb" }, config = conf.diaglist })

misc({
    "kylechui/nvim-surround",
    lazy = true,
    event = "VeryLazy",
    opts = { move_cursor = true, keymaps = { visual = "s" } },
})
misc({
    "XXiaoA/ns-textobject.nvim",
    lazy = true,
    dependencies = { "kylechui/nvim-surround" },
    opts = {
        auto_mapping = {
            -- automatically mapping for nvim-surround's aliases
            aliases = true,
            -- for nvim-surround's surrounds
            surrounds = true,
        },
        disable_builtin_mapping = {
            enabled = true,
            -- list of char which shouldn't mapping by auto_mapping
            chars = { "b", "B", "t", "`", "'", '"', "{", "}", "(", ")", "[", "]", "<", ">" },
        },
    },
})
-- programming spell
misc({
    "psliwka/vim-dirtytalk",
    build = "DirtytalkUpdate",
    config = function()
        vim.opt.spelllang:append("programming")
    end,
})

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
    event = "BufRead",
    config = function()
        require("project_nvim").setup({
            ignore_lsp = { "null-ls" },
            silent_chdir = true,
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
    keys = { "<leader>Z" },
    config = conf.noneck,
})

misc({ "tweekmonster/helpful.vim", cmd = "HelpfulVersion", ft = "help" })
-- If there is regex, this seems very nice to work with .
misc({
    "tomiis4/Hypersonic.nvim",
    cmd = "Hypersonic",
    keys = {
        {
            "<leader>R",
            function()
                vim.cmd([[Hypersonic]])
            end,
            mode = "v",
        },
    },
    opts = {
        border = lambda.style.border.type_0,
    },
})
misc({
    "kiran94/maim.nvim",
    config = true,
    cmd = { "Maim", "MaimMarkdown" },
})
misc({
    "chaoren/vim-wordmotion",
    lazy = true,
    event = "VeryLazy",
    config = function()
        vim.g.wordmotion_prefix = ","
    end,
})
misc({
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
})
