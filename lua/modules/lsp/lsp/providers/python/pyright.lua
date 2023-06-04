local M = {}

M.attach_config = function(client, bufnr) end
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
