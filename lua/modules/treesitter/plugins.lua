--  TODO: (vsedov) (08:58:48 - 08/11/22): Make all of this optional, because im not sure which is
--  causing the error here, and its quite important that i figure this one out .
local conf = require("modules.treesitter.config")
local ts = require("core.pack").package
local fn = vim.fn

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
    lazy = true,
    ft = {
        "c",
        "cpp",
        "go",
        "java",
        "javascript",
        "jsx",
        "lua",
        "php",
        "python",
        "r",
        "ruby",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "zig",
    },
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
    "andymass/vim-matchup",
    cond = lambda.config.treesitter.use_matchup,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.matchup,
    init = conf.matchup_setup,
})
ts({
    "Yggdroot/hiPairs",
    lazy = true,
    cond = true,
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hi_pairs,
})

ts({
    "NMAC427/guess-indent.nvim",
    lazy = true,
    event = lambda.config.guess_indent,
    cmd = "GuessIndent",
    config = conf.guess_indent,
})

ts({
    "yioneko/nvim-yati",
    cond = lambda.config.treesitter.use_yati,
    event = "VeryLazy",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "yioneko/vim-tmindent" },
    config = conf.indent,
})

ts({
    "Dkendal/nvim-treeclimber",
    lazy = true,
    dependencies = { "rktjmp/lush.nvim", "nvim-treesitter/nvim-treesitter" },
})

-- ts({
--     "wellle/targets.vim",
--     lazy = true,
--     event = "VeryLazy",
--     init = function()
--         vim.g.targets_gracious = 1
--     end,
--     config = function()
--         vim.cmd([[
-- autocmd User targets#mappings#user call targets#mappings#extend({
--     \ 's': { 'separator': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
--     \                      {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
--     \                      {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}] },
--     \ '@': {
--     \     'separator': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
--     \                   {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
--     \                   {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}],
--     \     'pair':      [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}],
--     \     'quote':     [{'d':"'"}, {'d':'"'}, {'d':'`'}],
--     \     'tag':       [{}],
--     \     },
--     \ })
--       ]])
--     end,
-- })

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
