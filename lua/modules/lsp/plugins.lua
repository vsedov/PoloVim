local conf = require("modules.lsp.config")
local lsp = require("core.pack").package

lsp({
    "neovim/nvim-lspconfig",
    opt = true,
    module_pattern = "lspconfig.*",
    event = "BufEnter",
    setup = conf.nvim_lsp_setup,
    config = conf.nvim_lsp,
})

lsp({
    "williamboman/mason.nvim",
    after = "nvim-lspconfig",
    requires = { "nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
    config = conf.mason_setup,
})

-- until i figure out how to install custom languages servers with mason, il keep this here as a handy backup .
-- lsp({
--     "williamboman/nvim-lsp-installer",
--     opt = true,
--     requires = "nvim-lspconfig",
--     config = conf.lsp_install,
-- })

lsp({ "ii14/lsp-command", opt = true, after = "nvim-lspconfig" })
lsp({
    "p00f/clangd_extensions.nvim",
    opt = true,
    ft = { "c", "cpp" },
    requires = "nvim-lspconfig",
    config = conf.clangd,
})

lsp({ "folke/neodev.nvim", ft = "lua", opt = true, requires = "nvim-lspconfig", config = conf.luadev })

lsp({ "lewis6991/hover.nvim", modules = "hover", config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cmd = { "Lspsaga", "LSoutlineToggle" },
    opt = true,
    config = conf.saga,
    requires = "nvim-lspconfig",
})

lsp({
    "ray-x/lsp_signature.nvim",
    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "BufWinEnter",
            augroup_name = "lsp_sig",
            condition = lambda.config.lsp.use_lsp_signature,
            plugin = "lsp_signature.nvim",
        })
    end,
    config = conf.lsp_sig,
})

lsp({
    "aznhe21/actions-preview.nvim",
    keys = {
        "\\;",
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

        vim.keymap.set({ "v", "n" }, "\\;", require("actions-preview").code_actions)
    end,
})

lsp({
    "joechrisellis/lsp-format-modifications.nvim",
    modules = "lsp-format-modifications",
})

lsp({ "smjonas/inc-rename.nvim", event = "BufEnter", after = "nvim-lspconfig", config = conf.rename })

lsp({ "SmiteshP/nvim-navic", event = "BufEnter", after = "nvim-lspconfig", config = conf.navic })

lsp({ "cseickel/diagnostic-window.nvim", cmd = "DiagWindowShow", requires = { "MunifTanjim/nui.nvim" } })
lsp({
    "liuchengxu/vista.vim",
    cmd = { "Vista", "Vista!", "Vista!!" },
    config = conf.vista,
})

lsp({
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufEnter",
    requires = { "nvim-lua/plenary.nvim", "poljar/typos.nvim" },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
        -- require("typos").setup()
    end,
})

lsp({
    "jayp0521/mason-null-ls.nvim",
    requires = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },
    after = "mason.nvim",
    config = function()
        require("mason-null-ls").setup({
            automatic_installation = false,
        })
    end,
})

lsp({
    "barreiroleo/ltex-extra.nvim",
    opt = true,
    ft = { "latex", "tex" },
    module = "ltex_extra",
})

lsp({
    "theHamsta/nvim-semantic-tokens",
    opt = true,
    config = function()
        preset = "default"
        highlighters = { require("nvim-semantic-tokens.table-highlighter") }
    end,
})

lsp({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    cmd = { "TL" },
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "rcd",
            condition = lambda.config.lsp.use_lsp_lines,
            plugin = "lsp_lines.nvim",
        })
    end,
    config = conf.lsp_lines,
})

lsp({
    "santigo-zero/right-corner-diagnostics.nvim",
    cmd = { "RCL" },
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "rcd",
            condition = lambda.config.lsp.use_rcd,
            plugin = "right-corner-diagnostics.nvim",
        })
    end,
    config = conf.rcd,
})
