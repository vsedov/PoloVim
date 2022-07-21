if vim.g.lsp_config_complete then
    return
end
vim.g.lsp_config_complete = true
local lspconfig = require("lspconfig")
local enhance_attach = require("modules.lsp.lsp.utils").enhance_attach
local dlsconfig = require("diagnosticls-configs")
dlsconfig.setup({
    ["python"] = {
        linter = require("diagnosticls-configs.linters.flake8"),
        formatter = {
            require("diagnosticls-configs.formatters.yapf"),
            require("diagnosticls-configs.formatters.isort"),
        },
    },
    ["lua"] = {
        linter = require("diagnosticls-configs.linters.luacheck"),
        formatter = require("diagnosticls-configs.formatters.stylua"),
    },
    ["vim"] = {
        linter = require("diagnosticls-configs.linters.vint"),
    },
})

local python_setup = {
    pylsp = function()
        vim.g.navic_silence = true
        lspconfig.pylsp.setup(enhance_attach(require("5.pylsp-ls")))
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

python_setup[lambda.config.python.lsp]()

lspconfig.julials.setup(enhance_attach(require("modules.lsp.lsp.providers.julials")))

lspconfig.gopls.setup(enhance_attach({
    filetypes = { "go" },
    cmd = { "gopls", "--remote=auto" },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    },
}))

lspconfig.texlab.setup(enhance_attach({ require("modules.lsp.lsp.providers.latex") }))

lspconfig.jsonls.setup(enhance_attach({
    cmd = { "vscode-json-languageserver", "--stdio" },
    filetypes = { "json", "jsonc" },
}))

lspconfig.sqls.setup(enhance_attach({
    filetypes = { "sql", "mysql" },
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    settings = {
        sqls = {
            connections = {
                {
                    name = "sqlite3-project",
                    adapter = "sqlite3",
                    filename = "/home/viv/GitHub/TeamProject2022_28/ARMS/src/main/resources/db/DummyARMS.sqlite",
                    projectPaths = "/home/viv/GitHub/TeamProject2022_28/ARMS/",
                },
            },
        },
    },
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
