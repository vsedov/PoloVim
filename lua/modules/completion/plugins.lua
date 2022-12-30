local conf = require("modules.completion.config")
local completion = require("core.pack").package

completion({
    "hrsh7th/nvim-cmp",
    -- lazy = true,
    event = { "InsertEnter", "CmdLineEnter", "InsertCharPre" }, -- InsertCharPre Due to luasnip
    after = { "LuaSnip" }, -- "nvim-snippy",
    dependencies = {
        {
            "tzachar/cmp-tabnine",
            build = "./install.sh",
            ft = { "python", "lua" },
            config = conf.tabnine,
            lazy = true,
        },
        -- { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp", lazy = true },
        { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp", lazy = true },
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", lazy = true },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", lazy = true },
        { "kdheepak/cmp-latex-symbols", after = "nvim-cmp", lazy = true },
        { "hrsh7th/cmp-buffer", after = "nvim-cmp", lazy = true },
        { "hrsh7th/cmp-path", after = "nvim-cmp", lazy = true },
        { "hrsh7th/cmp-cmdline", after = "nvim-cmp", lazy = true },
        {
            "petertriho/cmp-git",
            after = "nvim-cmp",
            lazy = true,
            config = function()
                require("cmp_git").setup({ filetypes = { "gitcommit", "NeogitCommitMessage" } })
            end,
        },
        { "lukas-reineke/cmp-rg", after = "nvim-cmp" },
        { "saadparwaiz1/cmp_luasnip", after = { "nvim-cmp", "LuaSnip" } },
    },
    config = conf.cmp,
})

completion({
    "L3MON4D3/LuaSnip", -- need to be the first to load
    event = "InsertEnter",
    module = "luasnip",
    branch = "parse_from_ast",
    dependencies = {
        { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    }, -- , event = "InsertEnter"
    config = function()
        require("modules.completion.snippets")
    end,
    rocks = { "jsregexp" },
})

completion({
    "iurimateus/luasnip-latex-snippets.nvim",
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
    init = function()
        vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
        -- vim.cmd([[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]])
        -- body
    end,
})

completion({
    "windwp/nvim-autopairs",
    init = function()
        lambda.lazy_load({
            events = { "InsertEnter", "CmdLineEnter" },
            augroup_name = "autopairs",
            condition = not lambda.config.use_luasnip_brackets,
            plugin = "nvim-autopairs",
        })
    end,
    keys = { "<C-c>" },
    config = conf.autopair,
})

completion({
    "vsedov/vim-sonictemplate",
    cmd = "Template",
    config = conf.vim_sonictemplate,
})

-- -- Lua
completion({
    "abecodes/tabout.nvim",
    lazy = true,
    event = "VeryLazy",
    config = conf.tabout,
})
