local conf = require("plugins.lsp.config")

-- lambda.ui.highlight.plugin("lspconfig", { { LspInfoBorder = { link = "FloatBorder" } } })
require("lspconfig.ui.windows").default_options.border = lambda.style.border.type_0
require("lspconfig")

require("plugins.lsp.lsp.mason.python")
require("mason").setup({
    ui = {
        border = lambda.style.border.type_0,
        height = 0.8,
    },
})
--
require("mason-lspconfig").setup({
    automatic_installation = true,
    handlers = {
        function(name)
            local config = require("plugins.lsp.lsp.mason.lsp_servers")(name)

            if config then
                require("lspconfig")[name].setup(config)
            end
        end,
    },
})
require("modules.lsp.lsp.null-ls").setup()
require("mason-null-ls").setup({
    automatic_installation = false,
})
conf.saga()
conf.glance()
conf.definition_or_reference()
