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
    module = "lsp_signature",
    opt = true,
    -- config = conf.lsp_sig,
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
