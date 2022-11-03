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
    module = "lsp_signature",
    opt = true,
    -- config = conf.lsp_sig,
})

lsp({
    "aznhe21/actions-preview.nvim",
    keys = {
        "<leader>ca",
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

        vim.keymap.set({ "v", "n" }, "<Leader>ca", require("actions-preview").code_actions)
    end,
})

lsp({
    "joechrisellis/lsp-format-modifications.nvim",
    modules = "lsp-format-modifications",
})

lsp({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    cmd = { "TL" },
    config = conf.lsp_lines,
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
    "vsedov/null-ls.nvim",
    branch = "feat/ruff",
    event = "BufEnter",
    requires = { "nvim-lua/plenary.nvim" },
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
    "santigo-zero/right-corner-diagnostics.nvim",
    event = { "LspAttach" },
    config = conf.rcd,
})

lsp({
    "direnv/direnv.vim",
    opt = true,
    ft = { "python", "julia" },
})

lsp({
    "AckslD/swenv.nvim",
    cmd = { "VenvFind", "GetVenv" },
    ft = "python",
    config = conf.swenv,
})
