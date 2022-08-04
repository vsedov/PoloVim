local conf = require("modules.lsp.config")
local lsp = require("core.pack").package

lsp({
    "neovim/nvim-lspconfig",
    opt = true,
    event = "BufEnter",
    setup = conf.nvim_lsp_setup,
    config = conf.nvim_lsp,
})

lsp({
    "williamboman/nvim-lsp-installer",
    cmd = { "LspInstall", "LspInstallInfo", "LspInstallLog" },
    opt = true,
    requires = "nvim-lspconfig",
    config = conf.lsp_install,
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

lsp({ "max397574/lua-dev.nvim", ft = "lua", opt = true, requires = "nvim-lspconfig", config = conf.luadev })

lsp({ "lewis6991/hover.nvim", key = { "K", "gK" }, config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cmd = { "Lspsaga", "LSoutlineToggle" },
    opt = true,
    config = conf.saga,
    requires = "nvim-lspconfig",
})

lsp({
    "ray-x/lsp_signature.nvim",
    config = conf.lsp_sig,
    after = "nvim-lspconfig",
    opt = true,
})

lsp({
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    ft = { "python", "lua", "c", "java", "prolog", "lisp", "cpp" },
})

lsp({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    cmd = { "TL" },
    config = conf.lsp_lines,
})

-- lsp({ "mhartington/formatter.nvim", ft = { "python", "lua", "c" }, opt = true, config = conf.format })

-- lsp({ "mfussenegger/nvim-lint", ft = { "python", "lua", "c" }, opt = true, config = conf.lint })

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
    ft = {
        "norg",
        "c",
        "cpp",
        "css",
        "django",
        "fish",
        "gitcommit",
        "gitrebase",
        "go",
        "gomod",
        "haskell",
        "html",
        "htmldjango",
        "javascript",
        "javascriptreact",
        "json",
        "kotlin",
        "lua",
        "markdown",
        "php",
        "python",
        "scss",
        "sh",
        "svelte",
        "txt",
        "typescript",
        "typescriptreact",
        "vue",
    },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
    end,
})

lsp({
    "barreiroleo/ltex-extra.nvim",
    opt = true,
    ft = { "latex", "tex" },
    module = "ltex_extra",
})
