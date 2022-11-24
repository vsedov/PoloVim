--  TODO: (vsedov) (08:58:48 - 08/11/22): Make all of this optional, because im not sure which is
--  causing the error here, and its quite important that i figure this one out .
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
    "RRethy/nvim-treesitter-textsubjects",
    ft = { "lua", "rust", "go", "python", "javascript" },
    opt = true,
    config = conf.tsubject,
})

ts({
    "RRethy/nvim-treesitter-endwise",
    ft = { "lua", "ruby", "vim" },
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
    requires = { "nvim-treesitter/nvim-treesitter" },
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
    opt = true,
    config = conf.matchup,
    setup = conf.matchup_setup,
})

ts({
    "Yggdroot/hiPairs",
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "hiPairs",
            condition = lambda.config.use_hiPairs, -- reverse
            plugin = "hiPairs",
        })
    end,

    config = conf.hi_pairs,
})

ts({
    "yioneko/nvim-yati",
    after = "nvim-treesitter",
    requires = { "nvim-treesitter/nvim-treesitter", "yioneko/vim-tmindent" },
    config = conf.indent,
})

-- Packer
ts({
    "folke/paint.nvim",
    event = "BufReadPre",
    config = function()
        require("paint").setup({
            -- @type PaintHighlight[]
            highlights = {
                {
                    filter = { filetype = "lua" },
                    pattern = "%s(@%w+)",
                    -- pattern = "%s*%-%-%-%s*(@%w+)",
                    hl = "@parameter",
                },
                {
                    filter = { filetype = "c" },
                    -- pattern = "%s*%/%/%/%s*(@%w+)",
                    pattern = "%s(@%w+)",
                    hl = "@parameter",
                },
                {
                    filter = { filetype = "python" },
                    -- pattern = "%s*%/%/%/%s*(@%w+)",
                    pattern = "%s(@%w+)",
                    hl = "@parameter",
                },

                {
                    filter = { filetype = "markdown" },
                    pattern = "%*.-%*", -- *foo*
                    hl = "Title",
                },
                {
                    filter = { filetype = "markdown" },
                    pattern = "%*%*.-%*%*", -- **foo**
                    hl = "Error",
                },
                {
                    filter = { filetype = "markdown" },
                    pattern = "%s_.-_", --_foo_
                    hl = "MoreMsg",
                },
                {
                    filter = { filetype = "markdown" },
                    pattern = "%s%`.-%`", -- `foo`
                    hl = "Keyword",
                },
                {
                    filter = { filetype = "markdown" },
                    pattern = "%`%`%`.*", -- ```foo<CR>...<CR>```
                    hl = "MoreMsg",
                },
            },
        })
    end,
})

ts({
    -- It uses hydra
    "Dkendal/nvim-treeclimber",
    after = "nvim-treesitter",
    requires = "rktjmp/lush.nvim",
    config = function()
        local tc = require("nvim-treeclimber")

        -- Highlight groups
        -- Change if you don't have Lush installed
        local color = require("nvim-treeclimber.hi")
        local bg = color.bg_hsluv("Normal")
        local fg = color.fg_hsluv("Normal")
        local dim = bg.mix(fg, 20)

        vim.api.nvim_set_hl(0, "TreeClimberHighlight", { background = dim.hex })

        vim.api.nvim_set_hl(0, "TreeClimberSiblingBoundary", { background = color.terminal_color_5.hex })

        vim.api.nvim_set_hl(
            0,
            "TreeClimberSibling",
            { background = color.terminal_color_5.mix(bg, 40).hex, bold = true }
        )

        vim.api.nvim_set_hl(0, "TreeClimberParent", { background = bg.mix(fg, 2).hex })

        vim.api.nvim_set_hl(
            0,
            "TreeClimberParentStart",
            { background = color.terminal_color_4.mix(bg, 10).hex, bold = true }
        )
    end,
})

ts({
    "haringsrob/nvim_context_vt",
    requires = "nvim-treesitter",
    opt = true,
    cmd = {
        "NvimContextVtToggle",
        "NvimContextVtDebug",
    },
    function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "context",
            condition = lambda.config.treesitter.use_context, -- reverse
            plugin = "nvim_context_vt",
        })
    end,

    config = function()
        require("nvim_context_vt").setup({})
    end,
})
