local conf = require("modules.completion.config")
local completion = require("core.pack").package

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ VeryLazy                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯

completion({
    "abecodes/tabout.nvim",
    lazy = true,
    event = "VeryLazy",
    config = conf.tabout,
})
--  ──────────────────────────────────────────────────────────────────────

completion({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    lazy = true,
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp-document-symbol", lazy = true },
        { "hrsh7th/cmp-nvim-lsp", lazy = true },
        { "hrsh7th/cmp-nvim-lua", lazy = true },
        { "kdheepak/cmp-latex-symbols", lazy = true },
        { "hrsh7th/cmp-buffer", lazy = true },
        { "hrsh7th/cmp-path", lazy = true },
        { "hrsh7th/cmp-cmdline", lazy = true },
        { "andersevenrud/cmp-tmux", lazy = true },
        {
            "petertriho/cmp-git",
            lazy = true,
            config = function()
                require("cmp_git").setup({ filetypes = { "gitcommit", "NeogitCommitMessage" } })
            end,
        },
        { "lukas-reineke/cmp-rg", lazy = true },
        { "saadparwaiz1/cmp_luasnip", lazy = true },
        {
            "doxnit/cmp-luasnip-choice",
            lazy = true,
            config = function()
                require("cmp_luasnip_choice").setup({
                    auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
                })
            end,
        },
    },
    config = conf.cmp,
})

completion({
    "L3MON4D3/LuaSnip", -- need to be the first to load
    event = "InsertEnter",
    dependencies = {
        {
            "rafamadriz/friendly-snippets",
            lazy = true,
            "hrsh7th/nvim-cmp",
        },
    }, -- , event = "InsertEnter"
    config = function()
        require("modules.completion.snippets")
    end,
})

-- completion({
--     "altermo/ultimate-autopair.nvim",
--     lazy = true,
--     event = { "InsertEnter", "CmdlineEnter" },
--     opts = conf.autopair(),
-- })

completion({

    "ziontee113/SnippetGenie",
    lazy = true,
    event = "VeryLazy",
    keys = { { "<cr>", mode = "x" }, { ";<cr>", mode = "n" } },
    config = conf.snip_genie,
})

completion({
    "iurimateus/luasnip-latex-snippets.nvim",
    lazy = true,
    ft = { "latex", "tex" },
    config = function()
        vim.defer_fn(function()
            require("luasnip-latex-snippets").setup()
        end, 100)
    end,
})

completion({
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql" },
    config = function()
        vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
    end,
})

completion({
    "vsedov/vim-sonictemplate",
    cmd = "Template",
    config = conf.vim_sonictemplate,
})

-- -- Lua
