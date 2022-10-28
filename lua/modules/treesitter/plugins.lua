local conf = require("modules.treesitter.config")
local ts = require("core.pack").package
ts({ "nvim-treesitter/nvim-treesitter", opt = true, run = ":TSUpdate", config = conf.nvim_treesitter })

ts({
    "p00f/nvim-ts-rainbow",
    after = "nvim-treesitter",
    config = conf.rainbow,
    opt = true,
})
ts({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    config = conf.treesitter_obj,
    opt = true,
})
ts({
    "JoosepAlviste/nvim-ts-context-commentstring",
    opt = true,
})

ts({
    "RRethy/nvim-treesitter-textsubjects",
    ft = { "lua", "rust", "go", "python", "javascript" },
    opt = true,
    config = conf.tsubject,
})

ts({
    "RRethy/nvim-treesitter-endwise",
    ft = { "lua", "ruby", "vim" },
    event = "InsertEnter",
    opt = true,
    config = conf.endwise,
})

ts({
    "nvim-treesitter/nvim-treesitter-refactor",
    after = "nvim-treesitter-textobjects", -- manual loading
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    opt = true,
})

ts({
    "David-Kunz/markid",
    after = "nvim-treesitter",
})

ts({ "nvim-treesitter/nvim-treesitter-context", event = "WinScrolled", config = conf.context })

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
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hlargs,
})

-- ig finds the diagnostic under or after the cursor (including any diagnostic the cursor is sitting on)
-- ]g finds the diagnostic after the cursor (excluding any diagnostic the cursor is sitting on)
-- [g finds the diagnostic before the cursor (excluding any diagnostic the cursor is sitting on)
ts({
    "andrewferrier/textobj-diagnostic.nvim",
    ft = { "python", "lua" },
    config = function()
        require("textobj-diagnostic").setup()
    end,
})

ts({
    "andymass/vim-matchup",
    opt = true,
    config = conf.matchup,
    setup = conf.matchup_setup,
})

ts({
    "Yggdroot/hiPairs",
    setup = function()
        lambda.lazy_load({
            events = "FileType",
            pattern = { "python", "lua", "julia" },
            augroup_name = "hiPairs",
            condition = lambda.config.use_hi_pairs,
            plugin = "hiPairs",
        })
    end,
    config = conf.hi_pairs,
})
