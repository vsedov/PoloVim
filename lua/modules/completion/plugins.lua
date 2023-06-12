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
    cond = lambda.config.cmp.use_cmp,
    event = "InsertEnter",
    lazy = true,
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp", lazy = true },
        { "hrsh7th/cmp-nvim-lua", lazy = true },
        { "kdheepak/cmp-latex-symbols", lazy = true },
        { "hrsh7th/cmp-buffer", lazy = true },
        { "hrsh7th/cmp-path", lazy = true },
        { "hrsh7th/cmp-cmdline", lazy = true },
        { "rcarriga/cmp-dap", lazy = true },
        {
            "petertriho/cmp-git",
            lazy = true,
            config = function()
                require("cmp_git").setup({ filetypes = { "gitcommit", "NeogitCommitMessage" } })
            end,
        },
        { "saadparwaiz1/cmp_luasnip", lazy = true },
        {
            "doxnit/cmp-luasnip-choice",
            lazy = true,
            config = function()
                require("cmp_luasnip_choice").setup({
                    auto_open = false, -- Automatically open nvim-cmp on choice node (default: true)
                })
            end,
        },
    },
    config = conf.cmp,
})

completion({
    "L3MON4D3/LuaSnip", -- need to be the first to load
    build = "make install_jsregexp",
    event = "InsertEnter",
    dependencies = {
        {
            "rafamadriz/friendly-snippets",
        },
    }, -- , event = "InsertEnter"
    config = function()
        require("modules.completion.snippets")
    end,
})

completion({
    "altermo/npairs-integrate-upair",
    dependencies = { "windwp/nvim-autopairs", "altermo/ultimate-autopair.nvim" },
    config = conf.autopair,
})

completion({
    "ziontee113/SnippetGenie",
    lazy = true,
    keys = { { "<cr>", mode = "x" }, { ";<cr>", mode = "n" } },
    config = conf.snip_genie,
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
