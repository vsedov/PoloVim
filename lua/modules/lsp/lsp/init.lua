local lspconfig = require("lspconfig")
local enhance_attach = require("modules.lsp.lsp.config").enhance_attach

-- local configs = lspconfig.configs
-- if not configs.ruff_lsp then
--     configs.ruff_lsp = {
--         default_config = {
--             cmd = { "ruff-lsp" },
--             filetypes = { "python" },
--             root_dir = lspconfig.util.find_git_ancestor,
--             settings = {
--                 ruff_lsp = {
--                     -- Any extra CLI arguments for `ruff` go here.
--                     args = {},
--                 },
--             },
--         },
--     }
-- end

require("modules.lsp.lsp.providers.python.utils.semantic_tokens")

lspconfig.metals.setup(enhance_attach({
    cmd = { "metals" },
}))

lspconfig.hls.setup({ enhance_attach({}) })

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
