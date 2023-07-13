local conf = require("modules.lsp.config")
local lsp = require("core.pack").package

lsp({
    "neovim/nvim-lspconfig",
    lazy = true,
})

lsp({
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "poljar/typos.nvim", cond = lambda.config.lsp.use_typos, config = true },

        "jayp0521/mason-null-ls.nvim",
    },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
        require("mason-null-ls").setup({
            automatic_installation = true,
        })
        require("modules.lsp.lsp.config").setup()
    end,
})
lsp({
    "williamboman/mason.nvim",
    -- event = "VeryLazy",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
    },
    config = conf.mason_setup,
})

lsp({ "ii14/lsp-command", lazy = true, cmd = { "Lsp" } })

lsp({
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp" },
    dependencies = "nvim-lspconfig",
    config = conf.clangd,
})

lsp({ "lewis6991/hover.nvim", lazy = true, config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cond = not lambda.config.lsp.use_navigator,
    event = "VeryLazy",
    cmd = { "Lspsaga" },
    keys = {
        { "gr", "<cmd>Lspsaga finder<CR>", desc = "Toggle Lspsaga finder" },
        { "cc", "<cmd>Lspsaga code_action<CR>", desc = "Toggle Lspsaga code_action" },
        {
            "gd",
            "<cmd>Lspsaga peek_definition<CR>",
            desc = "Toggle Lspsaga peek_definition",
        },
        {
            "gt",
            "<cmd>Lspsaga peek_type_definition<CR>",
            desc = "Toggle Lspsaga peek_type_definition",
        },
        {
            "gT",
            "<cmd>Lspsaga goto_type_definition<CR>",
            desc = "Toggle Lspsaga goto_type_definition",
        },
        {
            "gR",
            "<cmd>Lspsaga rename ++project<CR>",
            desc = "Toggle Lspsaga rename ++project",
        },

        {
            "]e",
            "<cmd>Lspsaga diagnostic_jump_prev<CR>",
            desc = "Toggle Lspsaga diagnostic_jump_prev",
        },
        {
            "[e",
            "<cmd>Lspsaga diagnostic_jump_next<CR>",
            desc = "Toggle Lspsaga diagnostic_jump_next",
        },
        {
            "[E",
            function()
                require("lspsaga.diagnostic").goto_prev({
                    severity = vim.diagnostic.severity.ERROR,
                })
            end,
            desc = "Toggle Lspsaga diagnostic_prev ERROR",
        },
        {
            "]E",
            function()
                require("lspsaga.diagnostic").goto_next({
                    severity = vim.diagnostic.severity.ERROR,
                })
            end,
            desc = "Toggle Lspsaga diagnostic_next ERROR",
        },
        { "<leader>O", "<cmd>Lspsaga outline<cr>", desc = "Toggle Lspsaga outline" },
        {
            "gL",
            "<cmd>Lspsaga show_line_diagnostics<CR>",
            desc = "Toggle Lspsaga show_line_diagnostics",
        },

        {
            "gG",
            "<cmd>Lspsaga show_buf_diagnostics<CR>",
            desc = "Toggle Lspsaga show_buf_diagnostics",
        },
        { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Toggle Lspsaga code_action" },
        { "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", desc = "Toggle Lspsaga outgoing_calls" },
        { "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "Toggle Lspsaga incoming_calls" },
        {
            "gW",
            "<cmd>Lspsaga show_workspace_diagnostics<CR>",
            desc = "Toggle Lspsaga show_workspace_diagnostics",
        },
    },
    lazy = true,
    config = conf.saga,
    dependencies = "neovim/nvim-lspconfig",
})

lsp({
    "ray-x/lsp_signature.nvim",
    lazy = true,
    cond = lambda.config.lsp.lsp_sig.use_lsp_signature and not lambda.config.ui.noice.lsp.use_noice_signature,
    event = "VeryLazy",
    config = conf.lsp_sig,
})
lsp({
    "ray-x/navigator.lua",
    cond = lambda.config.lsp.use_navigator,
    requires = {
        { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
        { "neovim/nvim-lspconfig" },
    },
    config = conf.navigor,
})

lsp({
    "aznhe21/actions-preview.nvim",
    lazy = true,
    keys = {
        {
            "<leader>ca",
            function()
                require("actions-preview").code_actions()
            end,
            desc = "lsp: code actions",
            mode = { "n", "v" },
        },
    },
    config = function()
        require("actions-preview").setup({
            -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
            diff = {
                ctxlen = 3,
            },
            backend = { "telescope", "nui" },
            -- options for telescope.nvim: https://github.com/nvim-telescope/telescope.nvim#themes
            telescope = require("telescope.themes").get_dropdown(),
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
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    config = conf.vista,
})

lsp({
    "dnlhc/glance.nvim",
    lazy = true,
    cmd = "Glance",
    config = conf.glance,
})

lsp({
    "chikko80/error-lens.nvim",
    cond = lambda.config.lsp.diagnostics.use_error_lens,
    lazy = true,
    cmd = { "ErrorLensTelescope", "ErrorLensToggle" },
    event = "LspAttach",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = true,
})

lsp({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    cond = lambda.config.lsp.diagnostics.use_lsp_lines,
    init = function()
        lambda.highlight.plugin("Lines", {
            { DiagnosticVirtualTextWarn = { bg = "NONE" } },
            { DiagnosticVirtualTextError = { bg = "NONE" } },
            { DiagnosticVirtualTextInfo = { bg = "NONE" } },
            { DiagnosticVirtualTextHint = { bg = "NONE" } },
        })
    end,
    lazy = true,
    event = "LspAttach",
    config = function()
        require("lsp_lines").setup()
        vim.keymap.set("", "<Leader>ws", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end,
})

lsp({
    "santigo-zero/right-corner-diagnostics.nvim",
    cond = lambda.config.lsp.diagnostics.use_rcd,
    event = "LspAttach",
    config = function()
        -- NOTE: Apply this settings before calling the `setup()`.
        vim.diagnostic.config({
            -- Disable default virtual text since you are using this plugin
            -- already :)
            virtual_text = false,

            -- Do not display diagnostics while you are in insert mode, so if you have
            -- `auto_cmds = true` it will not update the diagnostics while you type.
            update_in_insert = false,
        })

        -- Default config:
        require("rcd").setup({
            -- Where to render the diagnostics: top or bottom, the latter sitting at
            -- the bottom line of the buffer, not of the terminal.
            position = "top", -- bottom

            -- In order to print the diagnostics we need to use autocommands, you can
            -- disable this behaviour and call the functions yourself if you think
            -- your autocmds work better than the default ones with this option:
            auto_cmds = true,
        })
    end,
})

lsp({
    "VidocqH/lsp-lens.nvim",
    lazy = true,
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    opts = {
        enable = false, -- enable through lsp
        include_declaration = true, -- Reference include declaration
        sections = {
            -- Enable / Disable specific request
            definition = true,
            references = true,
            implementation = true,
        },
        ignore_filetype = {
            "prisma",
            "lua", -- It already has its own inlay ints
        },
    },
})

lsp({
    "KostkaBrukowa/definition-or-references.nvim",
    lazy = true,
    config = conf.definition_or_reference,
})

lsp({
    "neovim/nvimdev.nvim",
    ft = "lua",
    init = conf.nvimdev,
})

lsp({
    "yorickpeterse/nvim-dd",
    event = { "LspAttach" },

    config = true,
})
lsp({ "onsails/lspkind.nvim", lazy = true })
lsp({
    "askfiy/lsp_extra_dim",
    event = { "LspAttach" },
    opts = {
        disable_diagnostic_style = "all",
    },
})
