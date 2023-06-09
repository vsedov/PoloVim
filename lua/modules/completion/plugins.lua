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
    event = "VeryLazy",
    dependencies = {
        { "windwp/nvim-autopairs", dependencies = "nvim-treesitter/nvim-treesitter" },
        { "altermo/ultimate-autopair.nvim", dependencies = "nvim-treesitter/nvim-treesitter" },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "IntPairsComp",
            callback = function()
                if not package.loaded["npairs-int-upair"] then
                    require("lazy").load({ plugins = { "npairs-integrate-upair" } })
                end

                require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
            end,
            once = true,
        })
    end,

    config = function()
        require("npairs-int-upair").setup({
            map = "u", --which of them should be the insert mode autopair
            cmap = "u", --which of them should be the cmd mode autopair (only 'u' supported)
            bs = "u", --which of them should be the backspace
            cr = "u", --which of them should be the newline
            space = "u", --which of them should be the space (only 'u' supported)
            c_h = "n", --which of them should be the <C-h> (only 'n' supported)
            c_w = "n", --which of them should be the <C-w> (only 'n' supported)
            rfastwarp = "<c-x>", --ultimate-autopair's reverse fastwarp mapping ('' for disable)
            fastwrap = "<c-s>", --nvim-autopairs's fastwrap mapping ('' for disable)
            npairs_conf = {
                disable_filetype = {
                    "aerial",
                    "checkhealth",
                    "dapui_breakpoints",
                    "dapui_console",
                    "dapui_scopes",
                    "dapui_stacks",
                    "dap-repl",
                    "DressingSelect",
                    "help",
                    "lazy",
                    "lspinfo",
                    "man",
                    "mason",
                    "netrw",
                    "null-ls-info",
                    "qf",
                },
                check_ts = true,
                fast_wrap = { highlight = "Question", highlight_grey = "Dimmed" },
            }, --nvim-autopairs's configuration

            upair_conf = {
                fastwarp = {
                    -- *ultimate-autopair-map-fastwarp-config*
                    enable = true,
                    enable_normal = true,
                    enable_reverse = true,
                    hopout = true,
                    --{(|)} > fastwarp > {(}|)
                    map = "<c-c>",
                    rmap = "<c-e>",
                    cmap = "<c-e>",
                    rcmap = "<c-C>",
                    multiline = true,
                    --(|) > fastwarp > (\n|)
                    nocursormove = true,
                    --makes the cursor not move (|)foo > fastwarp > (|foo)
                    --disables multiline feature
                    do_nothing_if_fail = true,
                    --add a module so that if fastwarp fails
                    --then an `e` will not be inserted
                },
                extensions = {
                    -- *ultimate-autopair-extensions-default-config*
                    cmdtype = { types = { "/", "?", "@" }, p = 90 },
                    escape = { filter = true, p = 70 },
                    string = { p = 60 },
                    --treenode={inside={'comment'},p=50},
                    rules = { p = 40 },
                    alpha = { p = 30 },
                    suround = { p = 20 },
                    fly = { other_char = { " " }, nofilter = false, p = 10 },
                    filetype = {
                        nft = {
                            "aerial",
                            "checkhealth",
                            "dapui_breakpoints",
                            "dapui_console",
                            "dapui_scopes",
                            "dap-repl",
                            "dapui_stacks",
                            "DressingSelect",
                            "help",
                            "lazy",
                            "lspinfo",
                            "man",
                            "mason",
                            "netrw",
                            "null-ls-info",
                            "qf",
                        },
                    },
                },
                internal_pairs = { -- *ultimate-autopair-pairs-default-config*
                    {
                        "[",
                        "]",
                        fly = true,
                        dosuround = true,
                        newline = true,
                        space = true,
                        fastwarp = true,
                        backspace_suround = true,
                    },
                    {
                        "(",
                        ")",
                        fly = true,
                        dosuround = true,
                        newline = true,
                        space = true,
                        fastwarp = true,
                        backspace_suround = true,
                    },
                    {
                        "{",
                        "}",
                        fly = true,
                        dosuround = true,
                        newline = true,
                        space = true,
                        fastwarp = true,
                        backspace_suround = true,
                    },
                    {
                        '"',
                        '"',
                        suround = true,
                        rules = { { "when", { "filetype", "vim" }, { "not", { "regex", "^%s*$" } } } },
                        string = true,
                    },
                    {
                        "'",
                        "'",
                        suround = true,
                        rules = { { "when", { "option", "lisp" }, { "instring" } } },
                        alpha = true,
                        nft = { "tex" },
                        string = true,
                    },
                    { "`", "`", nft = { "tex" } },
                    { "``", "''", ft = { "tex" } },
                    { "```", "```", newline = true, ft = { "markdown" } },
                    { "<!--", "-->", ft = { "markdown", "html" } },
                    { '"""', '"""', newline = true, ft = { "python" } },
                    { "'''", "'''", newline = true, ft = { "python" } },
                    { "string", type = "tsnode", string = true },
                    { "raw_string", type = "tsnode", string = true },
                },
            },
        })
    end,
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
