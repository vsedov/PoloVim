local lsp = {}
local conf = require("modules.lsp.config")
local package = require("core.pack").package

package({ "neovim/nvim-lspconfig", config = conf.nvim_lsp, opt = true })
package({ "ii14/lsp-command", opt = true, after = "nvim-lspconfig" })
package({
    "p00f/clangd_extensions.nvim",
    opt = true,
    ft = { "c", "cpp" },
    requires = "nvim-lspconfig",
    config = conf.clangd,
})

package({
    "simrat39/rust-tools.nvim",
    opt = true,
    ft = { "rust" },
    requires = "nvim-lspconfig",
    config = conf.rust_tools,
})

package({
    "williamboman/nvim-lsp-installer",
    opt = true,
    cmd = { "LspInstall", "LspInstallInfo", "LspInstallLog" },
    requires = "nvim-lspconfig",
    config = conf.lsp_install,
})
package({ "max397574/lua-dev.nvim", opt = true, requires = "nvim-lspconfig", config = conf.luadev })

package({ "lewis6991/hover.nvim", key = { "K", "gK" }, config = conf.hover })

package({
    "tami5/lspsaga.nvim",
    cmd = "Lspsaga",
    opt = true,
    config = conf.saga,
    requires = "nvim-lspconfig",
})
-- 4852d99f9511d090745d3cc1f09a75772b9e07e9 -- working

package({
    "ray-x/lsp_signature.nvim",
    opt = true,
    -- commit = "4852d99f9511d090745d3cc1f09a75772b9e07e9",
    config = conf.lsp_sig,
})

package({
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    ft = { "python", "lua", "c", "java", "prolog", "lisp", "cpp" },
})

package({
    "Maan2003/lsp_lines.nvim",
    event = { "BufEnter" },
    after = "nvim-lspconfig",
    config = conf.lsp_lines,
})

package({ "mhartington/formatter.nvim", opt = true, config = conf.format })

package({ "mfussenegger/nvim-lint", opt = true, config = conf.lint })

package({ "smjonas/inc-rename.nvim", cmd = "IncRename", config = conf.rename })

package({ "SmiteshP/nvim-navic", event = "BufEnter", after = "nvim-lspconfig", config = conf.navic })

-- return lsp
