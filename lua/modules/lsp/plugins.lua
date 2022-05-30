local lsp = {}
local conf = require("modules.lsp.config")

lsp["neovim/nvim-lspconfig"] = {
    config = conf.nvim_lsp,
    opt = true,
}
lsp["ii14/lsp-command"] = {
    opt = true,
    after = "nvim-lspconfig",
}
lsp["p00f/clangd_extensions.nvim"] = {
    opt = true,
    ft = { "c", "cpp" },
    requires = "nvim-lspconfig",
    config = conf.clangd,
}

lsp["williamboman/nvim-lsp-installer"] = {
    opt = true,
    cmd = { "LspInstall", "LspInstallInfo", "LspInstallLog" },
    requires = "nvim-lspconfig",
    config = conf.lsp_install,
}
lsp["max397574/lua-dev.nvim"] = {
    opt = true,
    requires = "nvim-lspconfig",
    config = conf.luadev,
}

lsp["lewis6991/hover.nvim"] = {
    key = { "K", "gK" },
    config = conf.hover,
}

lsp["tami5/lspsaga.nvim"] = {
    cmd = "Lspsaga",
    opt = true,
    config = conf.saga,
    requires = "nvim-lspconfig",
}

lsp["ray-x/lsp_signature.nvim"] = {
    opt = true,
    config = conf.lsp_sig,
}

lsp["weilbith/nvim-code-action-menu"] = {
    cmd = "CodeActionMenu",
    ft = { "python", "lua", "c", "java", "prolog", "lisp", "cpp" },
}
return lsp
