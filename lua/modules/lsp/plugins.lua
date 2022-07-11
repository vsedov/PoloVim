local conf = require("modules.lsp.config")
local lsp = require("core.pack").package
lsp({
    "williamboman/mason.nvim",
    event = "BufRead",
    branch = "alpha",
    config = function()
        require("mason").setup({ ui = { border = "single" } })
        require("mason-lspconfig").setup({
            automatic_installation = true,
        })
    end,
})
lsp({
    "neovim/nvim-lspconfig",
    after = "mason.nvim",
    requires = { "mason.nvim" },
    setup = conf.nvim_lsp_setup,
    config = conf.nvim_lsp,
    opt = true,
})
lsp({ "ii14/lsp-command", opt = true, after = "nvim-lspconfig" })
lsp({
    "p00f/clangd_extensions.nvim",
    opt = true,
    ft = { "c", "cpp" },
    requires = "nvim-lspconfig",
    config = conf.clangd,
})

lsp({
    "simrat39/rust-tools.nvim",
    opt = true,
    ft = { "rust" },
    requires = "nvim-lspconfig",
    config = conf.rust_tools,
})

lsp({
    "williamboman/nvim-lsp-installer",
    opt = true,
    cmd = { "LspInstall", "LspInstallInfo", "LspInstallLog" },
    requires = "nvim-lspconfig",
    config = conf.lsp_install,
})
lsp({ "max397574/lua-dev.nvim", ft = "lua", opt = true, requires = "nvim-lspconfig", config = conf.luadev })

lsp({ "lewis6991/hover.nvim", key = { "K", "gK" }, config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cmd = "Lspsaga",
    opt = true,
    config = conf.saga,
    requires = "nvim-lspconfig",
})
-- 4852d99f9511d090745d3cc1f09a75772b9e07e9 -- working

lsp({
    "ray-x/lsp_signature.nvim",
    opt = true,
    config = conf.lsp_sig,
})

lsp({
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    ft = { "python", "lua", "c", "java", "prolog", "lisp", "cpp" },
})

lsp({
    "Maan2003/lsp_lines.nvim",
    opt = true,
    setup = conf.lps_lines_setup,
    config = conf.lsp_lines,
})

lsp({ "mhartington/formatter.nvim", ft = { "python", "lua", "c" }, opt = true, config = conf.format })

lsp({ "mfussenegger/nvim-lint", ft = { "python", "lua", "c" }, opt = true, config = conf.lint })

lsp({ "smjonas/inc-rename.nvim", cmd = "IncRename", config = conf.rename })

lsp({ "SmiteshP/nvim-navic", event = "BufEnter", after = "nvim-lspconfig", config = conf.navic })

lsp({ "cseickel/diagnostic-window.nvim", cmd = "DiagWindowShow", requires = { "MunifTanjim/nui.nvim" } })
