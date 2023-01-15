local conf = require("modules.lsp.config")
local lsp = require("core.pack").package

--  TODO: (vsedov) (20:18:05 - 03/01/23): Figure out how to properly lazy load this scondif, as there
--  are a few issues with this right now and im not sure why this does not work.
lsp({
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufEnter",
    init = conf.nvim_lsp_setup,
    config = conf.nvim_lsp,
})

lsp({
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "poljar/typos.nvim", config = true },

        "jayp0521/mason-null-ls.nvim",
    },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
        require("mason-null-ls").setup({
            automatic_installation = false,
        })
    end,
})

lsp({
    "williamboman/mason.nvim",
    -- event = "BufEnter",
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

lsp({ "folke/neodev.nvim", lazy = true, ft = "lua", dependencies = "neovim/nvim-lspconfig", config = conf.luadev })

lsp({ "lewis6991/hover.nvim", lazy = true, config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cmd = { "Lspsaga" },
    lazy = true,
    config = conf.saga,
    dependencies = "neovim/nvim-lspconfig",
})

lsp({
    "ray-x/lsp_signature.nvim",
    lazy = true,
    ft = { "python" },
    config = conf.lsp_sig,
})

lsp({
    "aznhe21/actions-preview.nvim",
    lazy = true,
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
    lazy = true,
})

lsp({ "smjonas/inc-rename.nvim", lazy = true, config = conf.rename })

-- lsp({ "SmiteshP/nvim-navic", event = "BufEnter", after = "nvim-lspconfig", config = conf.navic })

lsp({ "cseickel/diagnostic-window.nvim", cmd = "DiagWindowShow", dependencies = { "MunifTanjim/nui.nvim" } })
lsp({
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    config = conf.vista,
})

lsp({
    "barreiroleo/ltex-extra.nvim",
    lazy = true,
    ft = { "latex", "tex" },
    module = "ltex_extra",
})

lsp({
    "santigo-zero/right-corner-diagnostics.nvim",
    cmd = { "RCL" },
    lazy = not lambda.config.lsp.use_rcd,
    config = conf.rcd,
})

lsp({
    "rmagatti/goto-preview",
    lazy = true,
    config = conf.goto_preview,
})

lsp({
    "dnlhc/glance.nvim",
    lazy = true,
    cmd = "Glance",
    config = conf.glance,
})

