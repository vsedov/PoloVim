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
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "rcarriga/cmp-dap" },
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
    event = "VeryLazy",
    opts = {
        bs = {
            multi = true,
        },
        cr = {
            autoclose = true,
            multi = true,
        },
        space = {
            multi = true,
        },
        fastwarp = { -- *ultimate-autopair-map-fastwarp-config*
            enable = true,
            enable_normal = true,
            enable_reverse = true,
            hopout = true,
            --{(|)} > fastwarp > {(}|)
            map = "<c-e>", --string or table
            rmap = "<c-E>", --string or table
            cmap = "<c-e>", --string or table
            rcmap = "<c-E>", --string or table
            multi = false,
        },
        tabout = { -- *ultimate-autopair-map-tabout-config*
            enable = true,
            map = "<c-tab>", --string or table
            cmap = "<c-tab>", --string or table
            conf = {},
            --contains extension config
            multi = true,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
            hopout = true,
            -- (|) > tabout > ()|
            do_nothing_if_fail = true,
        },
    },
})

completion({
    "ziontee113/SnippetGenie",
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
