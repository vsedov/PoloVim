local M = {}

M.attach_config = function(client, bufnr)
    local caps = client.server_capabilities

    if lambda.config.lsp.python.use_inlay_hints then
        require("modules.lsp.lsp.providers.python.utils.autocmds").InlayHintsAU()
    end
end
M.config = {
    settings = {
        python = {
            analysis = {
                indexing = true,
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                },
                stubPath = vim.fn.expand("$HOME/typings"),
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "information",
                    reportUnusedFunction = "information",
                    reportUnusedVariable = "information",
                },
            },
        },
    },
}
return M
