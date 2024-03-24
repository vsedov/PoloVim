local conf = require("modules.lsp.config")
local lsp = require("core.pack").package
lsp({ "onsails/lspkind.nvim", lazy = true })

lsp({
    "neovim/nvim-lspconfig",
    lazy = true,
})
lsp({
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
        require("modules.lsp.lsp.mason.python")
        require("mason").setup({
            ui = {
                border = lambda.style.border.type_0,
                height = 0.8,
            },
        })
    end,
})

lsp({
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason.nvim",
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                {
                    "folke/neodev.nvim",
                    ft = "lua",
                    opts = { library = { plugins = { "nvim-dap-ui" } } },
                },
                {
                    "folke/neoconf.nvim",
                    cmd = { "Neoconf" },
                    opts = { local_settings = ".nvim.json", global_settings = "nvim.json" },
                },
            },
            config = function()
                -- lambda.ui.highlight.plugin("lspconfig", { { LspInfoBorder = { link = "FloatBorder" } } })
                require("lspconfig.ui.windows").default_options.border = lambda.style.border.type_0
                require("lspconfig")
            end,
        },
    },
    opts = {
        automatic_installation = true,
        handlers = {
            function(name)
                local config = require("modules.lsp.lsp.mason.lsp_servers")(name)

                if config then
                    require("lspconfig")[name].setup(config)
                end
            end,
        },
    },
})

lsp({
    "nvimtools/none-ls.nvim",
    cond = lambda.config.lsp.lint_formatting.use_null_ls, -- need to find a replacement for this asap
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "poljar/typos.nvim", cond = lambda.config.lsp.use_typos, config = true },
        { "jayp0521/mason-null-ls.nvim" },
    },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
        require("mason-null-ls").setup({
            automatic_installation = false,
        })
        -- require("modules.lsp.lsp.config").setup()
    end,
})

lsp({ "ii14/lsp-command", lazy = true, cmd = { "Lsp" } })

lsp({
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp" },
    dependencies = "nvim-lspconfig",
    config = conf.clangd,
})

-- NOTE: (vsedov) (20:56:48 - 27/07/23): Does not work if you have multiple language clients
lsp({ "lewis6991/hover.nvim", lazy = true, config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cond = lambda.config.lsp.use_lsp_saga,
    event = "VeryLazy",
    cmd = { "Lspsaga" },
    lazy = true,
    config = conf.saga,
    dependencies = "neovim/nvim-lspconfig",
})

lsp({
    "ray-x/lsp_signature.nvim",
    lazy = true,
    cond = lambda.config.lsp.lsp_sig.use_lsp_signature
        and not lambda.config.folke.noice.lsp.use_noice_signature
        and false,
    event = "VeryLazy",
    config = conf.lsp_sig,
})

lsp({
    "aznhe21/actions-preview.nvim",
    lazy = true,
    keys = {
        {
            "\\;",
            function()
                require("actions-preview").code_actions()
            end,
            desc = "lsp: code actions",
            mode = { "n", "v" },
        },
    },
    config = function()
        require("actions-preview").setup({
            telescope = {
                sorting_strategy = "ascending",
                layout_strategy = "vertical",
                layout_config = {
                    width = 0.8,
                    height = 0.9,
                    prompt_position = "top",
                    preview_cutoff = 20,
                    preview_height = function(_, _, max_lines)
                        return max_lines - 15
                    end,
                },
            },
        })
    end,
})

lsp({
    "joechrisellis/lsp-format-modifications.nvim",
    lazy = true,
})

lsp({
    "smjonas/inc-rename.nvim",
    lazy = true,
    opts = { hl_group = "Visual", preview_empty_name = true },
    keys = {
        {
            "<leader>gr",
            function()
                return string.format(":IncRename %s", vim.fn.expand("<cword>"))
            end,
            expr = true,
            silent = false,
            desc = "lsp: incremental rename",
        },
    },
})

lsp({
    "cseickel/diagnostic-window.nvim",
    cmd = "DiagWindowShow",
    dependencies = { "MunifTanjim/nui.nvim" },
})

lsp({
    "dnlhc/glance.nvim",
    lazy = true,
    cmd = "Glance",
    config = conf.glance,
})

lsp({
    "KostkaBrukowa/definition-or-references.nvim",
    lazy = true,
    config = conf.definition_or_reference,
})

lsp({
    "yorickpeterse/nvim-dd",
    cond = true,
    event = { "LspAttach" },
    config = true,
})

lsp({
    "askfiy/lsp_extra_dim",
    cond = lambda.config.lsp.use_lsp_dim,
    event = { "LspAttach" },
    opts = {
        disable_diagnostic_style = "all",
    },
})
lsp({
    "ivanjermakov/troublesum.nvim",
    cond = lambda.config.lsp.diagnostics.use_trouble_some,
    event = { "LspAttach" },
    config = true,
})
lsp({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    cond = lambda.config.lsp.diagnostics.use_lsp_lines,
    lazy = true,
    event = "LspAttach",
    config = function()
        lambda.highlight.plugin("Lines", {
            { DiagnosticVirtualTextWarn = { bg = "NONE" } },
            { DiagnosticVirtualTextError = { bg = "NONE" } },
            { DiagnosticVirtualTextInfo = { bg = "NONE" } },
            { DiagnosticVirtualTextHint = { bg = "NONE" } },
        })

        require("lsp_lines").setup()

        vim.keymap.set("", "<Leader>L", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end,
})
-- rhs  upside diagnostics
lsp({
    "dgagn/diagflow.nvim",
    cond = lambda.config.lsp.diagnostics.use_rcd,
    event = "VeryLazy",
    opts = {
        format = function(diagnostic)
            return "[LSP] " .. diagnostic.message
        end,
        toggle_event = { "InsertEnter" },
    },
})
