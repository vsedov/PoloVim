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
        -- { "hrsh7th/cmp-nvim-lsp-signature-help", , lazy = true },
        { "hrsh7th/cmp-nvim-lsp-document-symbol", lazy = true },
        { "hrsh7th/cmp-nvim-lsp", lazy = true },
        { "hrsh7th/cmp-nvim-lua", lazy = true },
        { "kdheepak/cmp-latex-symbols", lazy = true },
        { "hrsh7th/cmp-buffer", lazy = true },
        { "hrsh7th/cmp-path", lazy = true },
        { "hrsh7th/cmp-cmdline", lazy = true },
        {
            "petertriho/cmp-git",
            lazy = true,
            config = function()
                require("cmp_git").setup({ filetypes = { "gitcommit", "NeogitCommitMessage" } })
            end,
        },
        -- { "lukas-reineke/cmp-rg", lazy = true},
        { "saadparwaiz1/cmp_luasnip", lazy = true },
    },
    config = conf.cmp,
})

completion({
    "L3MON4D3/LuaSnip", -- need to be the first to load
    event = "InsertEnter",
    -- module = "luasnip",
    -- branch = "parse_from_ast",
    dependencies = {
        { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    }, -- , event = "InsertEnter"
    config = function()
        require("modules.completion.snippets")
    end,
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
    config = function()
        vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
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
