local conf = require("modules.completion.config")
local completion = require("core.pack").package

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ VeryLazy                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯

completion({
    "abecodes/tabout.nvim",
    cond = lambda.config.cmp.use_tabout,
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "InsertEnter",
    opts = {
        -- tabkey = "",
        -- backwards_tabkey = "",
        ignore_beginning = true,
    },
})
completion({
    "boltlessengineer/smart-tab.nvim",
    cond = not lambda.config.cmp.use_tabout,
    lazy = true,
    event = "InsertEnter",
    config = function()
        require("smart-tab").setup({
            -- default options:
            -- list of tree-sitter node types to filter
            skips = { "string_content" },
            -- default mapping, set `false` if you don't want automatic mapping
            mapping = "<tab>",
        })
    end,
})

--  ──────────────────────────────────────────────────────────────────────
completion({
    "hrsh7th/nvim-cmp",
    cond = lambda.config.cmp.use_cmp,
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        -- { "hrsh7th/cmp-cmdline" },
        { "rcarriga/cmp-dap" },
        { "hrsh7th/cmp-omni" },

        -- {
        --     "doxnit/cmp-luasnip-choice",
        --     config = function()
        --         require("cmp_luasnip_choice").setup({
        --             auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
        --         })
        --     end,
        -- },
        {
            "petertriho/cmp-git",
            lazy = true,
            config = function()
                require("cmp_git").setup({ filetypes = { "gitcommit", "NeogitCommitMessage" } })
            end,
        },
        { "saadparwaiz1/cmp_luasnip", lazy = true },
        { "f3fora/cmp-spell", ft = { "gitcommit", "NeogitCommitMessage", "markdown", "norg", "org" } },
    },
    config = conf.cmp,
})

completion({
    "L3MON4D3/LuaSnip", -- need to be the first to load
    build = "make install_jsregexp",
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
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
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        tabout = {
            enable = true,
            hopout = true,
        },
        bs = {
            indent_ignore = true,
        },
        fastwarp = { -- *ultimate-autopair-map-fastwarp-config*
            enable = true,
            enable_normal = true,
            enable_reverse = true,
            hopout = true,
        },
    },
})
completion({
    "ziontee113/SnippetGenie",
    cond = false,
    lazy = true,
    keys = {
        {
            "<cr>",

            function()
                require("SnippetGenie").create_new_snippet_or_add_placeholder()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
            end,
            mode = "x",
            desc = "Genie Snippet X mode",
        },
        {
            ";<cr>",
            function()
                require("SnippetGenie").finalize_snippet()
            end,
            mode = "n",
            desc = "Genie Snippet N Mode ",
        },
    },
    cmd = {
        "SnipCreate",
    },
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
completion({
    "huggingface/hfcc.nvim",
    lazy = true,
    cmd = "StarCoder",
    opts = {
        model = "bigcode/starcoder",
        query_params = {
            max_new_tokens = 200,
        },
    },
    init = function()
        vim.api.nvim_create_user_command("StarCoder", function()
            require("hfcc.completion").complete()
        end, {})
    end,
})
