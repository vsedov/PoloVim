local conf = require("modules.completion.config")
local completion = require("core.pack").package

completion({ "max397574/dyn_help.nvim" })
completion({
    "amrbashir/nvim-docs-view",
    opt = true,
    cmd = { "DocsViewToggle" },
    config = conf.nvim_doc_help,
})
completion({
    "KabbAmine/zeavim.vim",
    cmd = {
        "Zeavim",
        "ZeavimV",
        "Zeavim!",
        "Docset",
    },
})

completion({
    "romainl/vim-devdocs",
    cmd = { "DD" },
    opt = true,
})
completion({
    "hrsh7th/nvim-cmp",
    -- opt = true,
    event = { "InsertEnter", "CmdLineEnter", "InsertCharPre" }, -- InsertCharPre Due to luasnip
    -- ft = {'lua', 'markdown',  'yaml', 'json', 'sql', 'vim', 'sh', 'sql', 'vim', 'sh'},
    after = { "LuaSnip" }, -- "nvim-snippy",
    requires = {
        {
            "tzachar/cmp-tabnine",
            run = "./install.sh",
            after = "nvim-cmp",
            config = conf.tabnine,
            opt = true,
        },

        { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", opt = true },
        { "kdheepak/cmp-latex-symbols", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-buffer", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-calc", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-path", after = "nvim-cmp", opt = true },
        { "max397574/cmp-cmdline", branch = "patch-1", after = "nvim-cmp", opt = true },
        { "f3fora/cmp-spell", after = "nvim-cmp", opt = true },
        { "octaltree/cmp-look", after = "nvim-cmp", opt = true },
        {
            "petertriho/cmp-git",
            after = "nvim-cmp",
            opt = true,
            config = function()
                require("cmp_git").setup({ filetypes = { "gitcommit", "NeogitCommitMessage" } })
            end,
        },
        { "lukas-reineke/cmp-rg", after = "nvim-cmp", opt = true },
        { "saadparwaiz1/cmp_luasnip", after = { "nvim-cmp", "LuaSnip" } },
    },
    config = conf.cmp,
})

completion({
    "L3MON4D3/LuaSnip", -- need to be the first to load
    event = "InsertEnter",
    module = "luasnip",
    requires = {
        { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    }, -- , event = "InsertEnter"
})

completion({
    lambda.use_local("luasnip-latex-snippets.nvim", "contributing"),
    ft = { "latex", "tex" },
    config = function()
        vim.defer_fn(function()
            require("luasnip-latex-snippets").setup()
        end, 100)
    end,
})

completion({
    "lervag/vimtex",
    opt = true,
    ft = { "latex", "tex" },
})

completion({
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql" },
    setup = function()
        vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
        -- vim.cmd([[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]])
        -- body
    end,
})

completion({
    "https://github.com/github/copilot.vim.git",
    cmd = "Copilot",
    opt = true,
    setup = function()
        --[[ vim.opt.completeopt = "menuone,noselect" ]]
        vim.g.copilot_enabled = lambda.config.sell_your_soul
        -- Have copilot play nice with nvim-cmp.
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ""
        local excluded_filetypes = { "norg", "nofile", "prompt" }
        local copilot_filetypes = {}
        for _, ft in pairs(excluded_filetypes) do
            copilot_filetypes[ft] = false
        end

        vim.g["copilot_filetypes"] = copilot_filetypes

        vim.keymap.set("i", "<M-.>", "<Plug>(copilot-next)")
        vim.keymap.set("i", "<M-,>", "<Plug>(copilot-previous)")
    end,
})

completion({
    "windwp/nvim-autopairs",
    event = {
        "InsertEnter",
        "CmdLineEnter",
    },
    after = "nvim-cmp",
    keys = { "<C-c>" },
    config = conf.autopair,
})

completion({ "danymat/neogen", module = { "neogen" }, requires = { "LuaSnip" }, config = conf.neogen })

completion({
    lambda.use_local("vim-sonictemplate", "personal"),
    as = "vim-sonictemplate",
    cmd = "Template",
    config = conf.vim_sonictemplate,
})
