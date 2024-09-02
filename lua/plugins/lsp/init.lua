local conf = require("plugins.lsp.config")
local config = lambda.config.lsp.null_ls
require("lspconfig.ui.windows").default_options.border = lambda.style.border.type_0
require("lspconfig")
require("mason").setup({
    ui = {
        border = lambda.style.border.type_0,
        height = 0.8,
    },
})

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
conf.definition_or_reference()
