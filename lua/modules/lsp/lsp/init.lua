local lspconfig = require("lspconfig")
local enhance_attach = require("modules.lsp.lsp.utils").enhance_attach
if vim.bo.filetype ~= "zig" then
    require("modules.lsp.lsp.semantic_tokens")
end
local python_setup = {
    pylsp = function()
        lspconfig.pylsp.setup(enhance_attach(require("modules.lsp.lsp.providers.python.pylsp-ls")))
    end,
    jedi = function()
        lspconfig.jedi_language_server.setup(enhance_attach(require("modules.lsp.lsp.providers.python.jedi_lang")))
    end,
    pylance = function()
        local pylance = require("modules.lsp.lsp.providers.python.pylance")
        pylance.creation()
        lspconfig.pylance.setup(enhance_attach(pylance.config))
    end,
    pyright = function()
        lspconfig.pyright.setup(enhance_attach(require("modules.lsp.lsp.providers.python.pyright")))
    end,
}

local latex_setup = {
    texlab = function()
        lspconfig.texlab.setup(enhance_attach(require("modules.lsp.lsp.providers.latex.texlab")))
    end,
    ltex = function()
        lspconfig.ltex.setup(enhance_attach(require("modules.lsp.lsp.providers.latex.ltex").config))
    end,
}
python_setup[lambda.config.python.lsp]()
latex_setup[lambda.config.latex]()

lspconfig.julials.setup(enhance_attach(require("modules.lsp.lsp.providers.julials")))

lspconfig.zls.setup(enhance_attach({
    cmd = { "zls" },
}))

lspconfig.gopls.setup(enhance_attach({
    filetypes = { "go" },
    cmd = { "gopls", "--remote=auto" },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    },
}))

lspconfig.jsonls.setup(enhance_attach({
    cmd = { "vscode-json-languageserver", "--stdio" },
    filetypes = { "json", "jsonc" },
}))

lspconfig.sqls.setup(enhance_attach({
    filetypes = { "sql", "mysql" },
    cmd = { "sql-language-server", "up", "--method", "stdio" },
}))

-- -- You will have to Build a package for this .
lspconfig.rust_analyzer.setup(enhance_attach({
    filetypes = { "rust" },
    cmd = { "rust-analyzer" },
}))

lspconfig.vimls.setup(enhance_attach({
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    init_options = {
        diagnostic = {
            enable = true,
        },
        indexes = {
            count = 3,
            gap = 100,
            projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
            runtimepath = true,
        },
        iskeyword = "@,48-57,_,192-255,-#",
        runtimepath = "",
        suggest = {
            fromRuntimepath = true,
            fromVimruntime = true,
        },
        vimruntime = "",
    },
}))
