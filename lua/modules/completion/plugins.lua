local conf = require("modules.completion.config")
local completion = require("core.pack").package

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ VeryLazy                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯
local socket_name = "unix:/tmp/kitty"

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
    "altermo/npairs-integrate-upair",
    event = "VeryLazy",
    dependencies = { { "windwp/nvim-autopairs" }, { "altermo/ultimate-autopair.nvim" } },
    config = function()
        require("npairs-int-upair").setup({
            map = "n", --which of them should be the insert mode autopair
            cmap = "u", --which of them should be the cmd mode autopair (only 'u' supported)
            bs = "n", --which of them should be the backspace
            cr = "n", --which of them should be the newline
            space = "u", --which of them should be the space (only 'u' supported)
            c_h = "", --which of them should be the <C-h> (only 'n' supported)
            c_w = "", --which of them should be the <C-w> (only 'n' supported)
            fastwarp = "<c-c>", --ultimate-autopair's fastwarp mapping ('' for disable)
            rfastwarp = "<c-x>", --ultimate-autopair's reverse fastwarp mapping ('' for disable)
            fastwrap = "<c-s>", --nvim-autopairs's fastwrap mapping ('' for disable)
            npairs_conf = {}, --nvim-autopairs's configuration
            upair_conf = {
                bs = {
                    enable = true,
                    overjump = true,
                    space = true,
                    multichar = true,
                    fallback = nil,
                },
                cr = {
                    enable = true,
                    autoclose = true,
                    multichar = {
                        enable = true,
                        markdown = { { "```", "```", pair = true, noalpha = true, next = true } },
                        lua = { { "then", "end" }, { "do", "end" } },
                    },
                    addsemi = { "c", "cpp", "rust" },
                    fallback = nil,
                },
                fastwarp = {
                    enable = true,
                    hopout = true,
                    map = "<c-c>",
                    rmap = "<C-x>",
                    Wmap = "<C-c>",
                    cmap = "<c-s>",
                    rcmap = "<c-x>",
                    Wcmap = "<c-e>",
                    multiline = true,
                    fallback = nil,
                },
                fastend = {
                    enable = true,
                    map = "<c-c>",
                    cmap = "<c-c>",
                    smart = true,
                    fallback = nil,
                },
            },
        })
    end,
})
completion({
    "ziontee113/SnippetGenie",
    lazy = true,
    event = "VeryLazy",
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
