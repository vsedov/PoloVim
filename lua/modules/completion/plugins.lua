local conf = require("modules.completion.config")
local completion = require("core.pack").package
local ai_conf = lambda.config.ai

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ VeryLazy                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯

completion({
    "kawre/neotab.nvim",
    lazy = true,
    cond = lambda.config.cmp.use_tabout,
    config = true,
})

--  ──────────────────────────────────────────────────────────────────────
completion({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    cond = lambda.config.cmp.use_cmp,
    dependencies = {
        {
            "tzachar/cmp-tabnine",
            lazy = true,
            cond = (ai_conf.tabnine.use_tabnine and ai_conf.tabnine.use_tabnine_cmp),
            build = "bash ./install.sh",
            config = conf.tabnine_cmp,
        },

        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        -- { "hrsh7th/cmp-nvim-lsp-signature-help", lazy = true },
        { "https://codeberg.org/FelipeLema/cmp-async-path", lazy = true },
        { "hrsh7th/cmp-buffer", lazy = true },
        { "hrsh7th/cmp-path", lazy = true },
        { "hrsh7th/cmp-omni", lazy = true },
        { "hrsh7th/cmp-cmdline" },

        -- {
        --     "doxnit/cmp-luasnip-choice",
        --     lazy = true,
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
        { "micangl/cmp-vimtex", ft = { "tex", "bib" }, config = true },
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
        {
            "mireq/luasnip-snippets",
            cond = true, -- Right now this is broken but i like the idea of having these snippets.
            dependencies = { "L3MON4D3/LuaSnip" },
        },
        {
            "iurimateus/luasnip-latex-snippets.nvim",
            event = "VeryLazy",
            cond = false,
            dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
            config = true,
        },
    }, -- , event = "InsertEnter"
    config = function()
        if lambda.config.use_adv_snip then
            require("modules.completion.snippets")
            require("luasnip_snippets.common.snip_utils").setup()
            require("luasnip").setup({
                -- Required to automatically include base snippets, like "c" snippets for "cpp"
                load_ft_func = require("luasnip_snippets.common.snip_utils").load_ft_func,
                ft_func = require("luasnip_snippets.common.snip_utils").ft_func,
                -- To enable auto expansin
                enable_autosnippets = true,
                -- Uncomment to enable visual snippets triggered using <c-x>
                -- store_selection_keys = '<c-x>',
            })
        end
        require("luasnip.loaders.from_vscode").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
        })
    end,
})
completion({
    "altermo/ultimate-autopair.nvim",
    cond = true,
    branch = "v0.6", --recommended as each new version will have breaking changes
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        profile = "default",
        --what profile to use
        map = true,
        --whether to allow any insert map
        cmap = true, --cmap stands for cmd-line map
        --whether to allow any cmd-line map
        pair_map = true,
        --whether to allow pair insert map
        pair_cmap = true,
        --whether to allow pair cmd-line map
        multiline = true,
        --enable/disable multiline
        bs = { -- *ultimate-autopair-map-backspace-config*
            enable = true,
            map = "<bs>", --string or table
            cmap = "<bs>", --string or table
            overjumps = true,
            --(|foo) > bs > |foo
            space = true, --false, true or 'balance'
            --( |foo ) > bs > (|foo)
            --balance:
            --  Will prioritize balanced spaces
            --  ( |foo  ) > bs > ( |foo )
            indent_ignore = false,
            --(\n\t|\n) > bs > (|)
            single_delete = false,
            -- <!--|--> > bs > <!-|
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
        },
        cr = { -- *ultimate-autopair-map-newline-config*
            enable = true,
            map = "<cr>", --string or table
            autoclose = true,
            --(| > cr > (\n|\n)
            conf = {
                cond = function(fn)
                    return not fn.in_lisp()
                end,
            },
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
        },
        space = { -- *ultimate-autopair-map-space-config*
            enable = true,
            map = " ", --string or table
            cmap = " ", --string or table
            check_box_ft = { "markdown", "vimwiki", "org" },
            _check_box_ft2 = { "norg" }, --may be removed
            --+ [|] > space > + [ ]
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
        },
        space2 = { -- *ultimate-autopair-map-space2-config*
            enable = false,
            match = [[\k]],
            --what character activate
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
        },
        fastwarp = {
            multi = true,
            {},
            { faster = true, map = "<C-e>", cmap = "<C-e>" },
        },
        close = { -- *ultimate-autopair-map-close-config*
            enable = true,
            map = "<c-]>", --string or table
            cmap = "<c-]>", --string or table
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
            do_nothing_if_fail = true,
            --add a module so that if close fails
            --then a `)` will not be inserted
        },
        tabout = { -- *ultimate-autopair-map-tabout-config*
            enable = false,
            map = "<A-tab>", --string or table
            cmap = "<A-tab>", --string or table
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
            hopout = false,
            -- (|) > tabout > ()|
            do_nothing_if_fail = true,
            --add a module so that if close fails
            --then a `\t` will not be inserted
        },
        extensions = { -- *ultimate-autopair-extensions-default-config*
            cmdtype = { skip = { "/", "?", "@", "-" }, p = 100 },
            filetype = { p = 90, nft = { "TelescopePrompt" }, tree = true },
            escape = { filter = true, p = 80 },
            utf8 = { p = 70 },
            tsnode = {
                p = 60,
                separate = {
                    "comment",
                    "string",
                    "char",
                    "character",
                    "raw_string", --fish/bash/sh
                    "char_literal",
                    "string_literal", --c/cpp
                    "string_value", --css
                    "str_lit",
                    "char_lit", --clojure/commonlisp
                    "interpreted_string_literal",
                    "raw_string_literal",
                    "rune_literal", --go
                    "quoted_attribute_value", --html
                    "template_string", --javascript
                    "LINESTRING",
                    "STRINGLITERALSINGLE",
                    "CHAR_LITERAL", --zig
                    "string_literals",
                    "character_literal",
                    "line_comment",
                    "block_comment",
                    "nesting_block_comment", --d #62
                },
            },
            cond = { p = 40, filter = true },
            alpha = { p = 30, filter = false, all = false },
            suround = { p = 20 },
            fly = {
                other_char = { " " },
                nofilter = false,
                p = 10,
                undomapconf = {},
                undomap = nil,
                undocmap = nil,
                only_jump_end_pair = false,
            },
        },
        internal_pairs = { -- *ultimate-autopair-pairs-default-pairs*
            { "[", "]", fly = true, dosuround = true, newline = true, space = true },
            { "(", ")", fly = true, dosuround = true, newline = true, space = true },
            { "{", "}", fly = true, dosuround = true, newline = true, space = true },
            { '"', '"', suround = true, multiline = false },
            {
                "'",
                "'",
                suround = true,
                cond = function(fn)
                    return not fn.in_lisp() or fn.in_string()
                end,
                alpha = true,
                nft = { "tex" },
                multiline = false,
            },
            {
                "`",
                "`",
                cond = function(fn)
                    return not fn.in_lisp() or fn.in_string()
                end,
                nft = { "tex" },
                multiline = false,
            },
            { "``", "''", ft = { "tex" } },
            { "```", "```", newline = true, ft = { "markdown" } },
            { "<!--", "-->", ft = { "markdown", "html" }, space = true },
            { '"""', '"""', newline = true, ft = { "python" } },
            { "'''", "'''", newline = true, ft = { "python" } },
        },
        config_internal_pairs = { -- *ultimate-autopair-pairs-configure-default-pairs*
            --configure internal pairs
            --example:
            --{'{','}',suround=true},
        },
    },
})

completion({
    "chrisgrieser/nvim-scissors",
    lazy = true,
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    config = function()
        require("scissors").setup({
            snippetDir = vim.fn.stdpath("config") .. "/snippets",
            jsonFormatter = "jq",
        })
    end,
    keys = {
        {
            "<leader>se",
            function()
                require("scissors").editSnippet()
            end,
            desc = "Edit snippet",
            mode = { "n", "x" },
        },
        {
            "<leader>sa",
            function()
                require("scissors").addNewSnippet()
            end,

            desc = "Add new snippet",
            mode = { "n", "x" },
        },
    },
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
