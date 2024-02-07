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

        {
            "doxnit/cmp-luasnip-choice",
            config = function()
                require("cmp_luasnip_choice").setup({
                    auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
                })
            end,
        },
        {
            "petertriho/cmp-git",
            lazy = true,
            config = function()
                require("cmp_git").setup({ filetypes = { "gitcommit", "NeogitCommitMessage" } })
            end,
        },
        { "saadparwaiz1/cmp_luasnip", lazy = true },
        { "f3fora/cmp-spell", ft = { "gitcommit", "NeogitCommitMessage", "markdown", "norg", "org" } },
        { "micangl/cmp-vimtex" },
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local autopairs = require("nvim-autopairs")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        autopairs.setup({
            close_triple_quotes = true,
            disable_filetype = { "neo-tree-popup" },
            check_ts = true,
            fast_wrap = { map = "<c-e>" },
            ts_config = {
                lua = { "string" },
                dart = { "string" },
                javascript = { "template_string" },
            },
        })
    end,
})

completion({
    "altermo/ultimate-autopair.nvim",
    cond = false,

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
    "chrisgrieser/nvim-scissors",
    event = "VeryLazy",
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    config = function()
        require("scissors").setup({
            snippetDir = vim.fn.stdpath("config") .. "/snippets",
            jsonFormatter = "jq",
        })

        vim.keymap.set("n", "<leader>se", function()
            require("scissors").editSnippet()
        end, { desc = "Edit snippet" })

        -- When used in visual mode prefills the selection as body.
        vim.keymap.set({ "n", "x" }, "<leader>sa", function()
            require("scissors").addNewSnippet()
        end, { desc = "Add new snippet" })
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
