--  TODO: (vsedov) (08:58:48 - 08/11/22): Make all of this optional, because im not sure which is
--  causing the error here, and its quite important that i figure this one out .
local conf = require("modules.treesitter.config")
local ts = require("core.pack").package
ts({ "nvim-treesitter/nvim-treesitter", lazy = true, run = ":TSUpdate", config = conf.nvim_treesitter })

ts({
    "p00f/nvim-ts-rainbow",
    after = "nvim-treesitter",
    config = conf.rainbow,
    lazy = true,
})
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
    after = "nvim-treesitter-textobjects", -- manual loading
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    lazy = true,
})

ts({
    "David-Kunz/markid",
    after = "nvim-treesitter",
})

-- ts({ "nvim-treesitter/nvim-treesitter-context", event = "WinScrolled", config = conf.context })

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
    config = function()
        require("textobj-diagnostic").setup()
    end,
})

ts({
    "andymass/vim-matchup",
    after = "nvim-treesitter",
    config = conf.matchup,
    setup = conf.matchup_setup,
})

-- ts({
--     "Yggdroot/hiPairs",
--     setup = function()
--         lambda.lazy_load({
--             events = "BufEnter",
--             augroup_name = "hiPairs",
--             condition = lambda.config.use_hiPairs, -- reverse
--             plugin = "hiPairs",
--         })
--     end,

--     config = conf.hi_pairs,
-- })

ts({
    "yioneko/nvim-yati",
    after = "nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter", "yioneko/vim-tmindent" },
    config = conf.indent,
})

-- -- Packer
ts({
    "folke/paint.nvim",
    event = "BufReadPre",
    config = conf.paint,
})

ts({
    -- It uses hydra
    "Dkendal/nvim-treeclimber",
    after = "nvim-treesitter",
    requires = "rktjmp/lush.nvim",
    -- config = conf.climber,
})

ts({
    "wellle/targets.vim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
    setup = function()
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
