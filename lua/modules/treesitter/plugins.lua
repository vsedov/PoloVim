local conf = require("modules.treesitter.config")
local ts = require("core.pack").package

-- Core
ts({
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = conf.treesitter_init,
    config = conf.nvim_treesitter,
})

-- Core
ts({
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.treesitter_obj,
})

ts({
    "chrisgrieser/nvim-various-textobjs",
    lazy = true,
    event = "VeryLazy",
    keys = {
        {
            "?",
            function()
                require("various-textobjs").diagnostic()
            end,
            mode = { "o", "x" },
            desc = "diagnostic textobj",
        },
        {
            "aS",
            function()
                require("various-textobjs").subword(false)
            end,
            mode = { "o", "x" },
            desc = "outer subword",
        },
        {
            "iS",
            function()
                require("various-textobjs").subword(true)
            end,
            mode = { "o", "x" },
            desc = "inner subword",
        },
        {
            "ii",
            function()
                require("various-textobjs").indentation(true, true)
            end,
            mode = { "o", "x" },
            desc = "inner indentation",
        },
    },
    opts = {
        useDefaultKeymaps = true,
    },
})

-- Core
ts({
    "RRethy/nvim-treesitter-textsubjects",
    lazy = true,
    ft = { "lua", "rust", "go", "python", "javascript" },
    config = conf.tsubject,
})

-- Core
ts({
    "RRethy/nvim-treesitter-endwise",
    lazy = true,
    ft = { "lua", "ruby", "vim" },
    config = conf.endwise,
})

-- Core
ts({
    "nvim-treesitter/nvim-treesitter-refactor",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
    config = conf.treesitter_ref, -- let the last loaded config treesitter
})

-- Core
ts({
    "David-Kunz/markid",
    cond = lambda.config.treesitter.better_ts_highlights,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
})

ts({
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hlargs,
})

ts({
    "andrewferrier/textobj-diagnostic.nvim",
    lazy = true,
    ft = { "python", "lua" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
})

ts({
    "Yggdroot/hiPairs",
    lazy = true,
    cond = lambda.config.treesitter.hipairs,
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hi_pairs,
})

ts({
    "NMAC427/guess-indent.nvim",
    lazy = true,
    cond = lambda.config.treesitter.indent.use_guess_indent,
    event = { "BufAdd", "BufReadPost", "BufNewFile" },
    cmd = "GuessIndent",
    config = conf.guess_indent,
})
ts({
    "Darazaki/indent-o-matic",
    lazy = true,
    cond = lambda.config.treesitter.indent.use_indent_O_matic,
    event = { "BufAdd", "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
})

ts({
    "yioneko/nvim-yati",
    cond = lambda.config.treesitter.indent.use_yati,
    event = { "BufAdd", "BufReadPost", "BufNewFile" },
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "yioneko/vim-tmindent" },
    config = conf.indent,
})

ts({
    "Dkendal/nvim-treeclimber",
    lazy = true,
    dependencies = { "rktjmp/lush.nvim", "nvim-treesitter/nvim-treesitter" },
})

ts({
    "ckolkey/ts-node-action",
    lazy = true,
    dependencies = { "nvim-treesitter" },
    keys = "<leader>k",
    init = function()
        vim.keymap.set(
            "n",
            "<leader>k",
            require("ts-node-action").node_action,
            { noremap = true, silent = true, desc = "Trigger Node Action" }
        )
    end,
    config = true,
})
ts({
    "romgrk/equal.operator",
    keys = {
        {
            "il",
            mode = { "o", "x" },
            desc = "select inside RHS",
        },
        {
            "ih",
            mode = { "o", "x" },
            desc = "select inside LHS",
        },
        {
            "al",
            mode = { "o", "x" },
            desc = "select all RHS",
        },
        {
            "ah",
            mode = { "o", "x" },
            desc = "select all LHS",
        },
    },
})
ts({
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = true, -- will be loaded via Comment.nvim
    config = function()
        require("nvim-treesitter.configs").setup({
            context_commentstring = { enable = true, enable_autocmd = false },
        })
    end,
})

ts({
    "andymass/vim-matchup",
    cond = lambda.config.treesitter.use_matchup,
    event = "BufReadPost",
    init = function()
        vim.o.matchpairs = "(:),{:},[:],<:>"
    end,
    keys = {
        {
            "<leader><leader>w",
            function()
                vim.cmd([[MatchupWhereAmI!]])
            end,
        },
    },
    config = function()
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
})
ts({ -- "haringsrob/nvim_context_vt",
    "haringsrob/nvim_context_vt",
    cond = lambda.config.treesitter.use_context_vt,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        prefix = "⤸",
        -- "󱞿",
        highlight = "Normal",
    },
})
ts({
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    config = function()
        local rainbow_delimiters = require("rainbow-delimiters")

        vim.g.rainbow_delimiters = {

            strategy = {
                [""] = rainbow_delimiters.strategy["global"],
            },
            query = {
                [""] = "rainbow-delimiters",
            },
        }
    end,
})
