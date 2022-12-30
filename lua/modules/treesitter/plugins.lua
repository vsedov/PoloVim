--  TODO: (vsedov) (08:58:48 - 08/11/22): Make all of this optional, because im not sure which is
--  causing the error here, and its quite important that i figure this one out .
local conf = require("modules.treesitter.config")
local ts = require("core.pack").package
ts({ "nvim-treesitter/nvim-treesitter", build = "TSUpdate", config = conf.nvim_treesitter })

ts({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    config = conf.treesitter_obj,
    lazy = true,
})

ts({
    "RRethy/nvim-treesitter-textsubjects",
    ft = { "lua", "rust", "go", "python", "javascript" },
    lazy = true,
    config = conf.tsubject,
})

ts({
    "RRethy/nvim-treesitter-endwise",
    ft = { "lua", "ruby", "vim" },
    lazy = true,
    config = conf.endwise,
})

ts({
    "nvim-treesitter/nvim-treesitter-refactor",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    lazy = true,
})
-- cant lazy load will fix.
ts({
    "David-Kunz/markid",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
        "python",
        "lua",
        "tex",
    },
})

ts({
    "m-demare/hlargs.nvim",
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
    ft = { "python", "lua" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
})

ts({
    "andymass/vim-matchup",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = true,
    config = conf.matchup,
    init = conf.matchup_setup,
})

ts({
    "Yggdroot/hiPairs",
    lazy = not lambda.config.use_hiPairs,
    config = conf.hi_pairs,
})

ts({
    "yioneko/nvim-yati",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "yioneko/vim-tmindent" },
    event = "VeryLazy",
    config = conf.indent,
})

-- -- Packer
ts({
    "folke/paint.nvim",
    ft = "lua",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.paint,
})

ts({
    -- It uses hydra
    "Dkendal/nvim-treeclimber",
    lazy = true,
    dependencies = { "rktjmp/lush.nvim", "nvim-treesitter/nvim-treesitter" },
    -- config = conf.climber,
})

ts({
    "wellle/targets.vim",
    lazy = true,
    event = "VeryLazy",
    init = function()
        vim.g.targets_gracious = 1
    end,
    config = function()
        vim.cmd([[
autocmd User targets#mappings#user call targets#mappings#extend({
    \ 's': { 'separator': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
    \                      {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
    \                      {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}] },
    \ '@': {
    \     'separator': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
    \                   {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
    \                   {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}],
    \     'pair':      [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}],
    \     'quote':     [{'d':"'"}, {'d':'"'}, {'d':'`'}],
    \     'tag':       [{}],
    \     },
    \ })
      ]])
    end,
})

ts({
    "chrisgrieser/nvim-various-textobjs",
    lazy = true,
    ft = { "python", "lua" },
    config = function()
        require("various-textobjs").setup({ useDefaultKeymaps = true })
    end,
})
