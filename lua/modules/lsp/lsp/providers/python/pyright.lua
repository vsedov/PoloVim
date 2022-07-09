return {
    handlers = {
        ["textDocument/inlayHint"] = require("modules.lsp.lsp.utils.inlay_hints").handler,
    },
    settings = {
        python = {
            analysis = {
                indexing = true,
                typeCheckingMode = "basic",
                diagnosticMode = "workspace",
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                },
                stubPath = vim.fn.expand("$HOME/typings"),
                diagnosticSeverityOverrides = {
                    reportMissingTypeStubs = "information",

                    reportGeneralTypeIssues = "warning",
                    reportUnboundVariable = "warning",
                    reportUndefinedVariable = "error",
                    reportUnknownMemberType = "information",
                    reportUnknownVariableType = "information",
                    reportUntypedClassDecorator = "none",
                    reportUntypedFunctionDecorator = "none",
                    reportFunctionMemberAccess = "warning",
                    reportUnknownArgumentType = "warning",
                    reportUnknownParameterType = "warning",
                    reportUnknownLambdaType = "warning",
                    reportUnusedImport = "information",
                    reportUnusedFunction = "information",
                    reportUnusedVariable = "information",
                    reportUnusedClass = "information",
                    strictParameterNoneValue = false,
                    reportOptionalSubscript = "warning",
                    reportOptionalMemberAccess = "warning",
                    reportOptionalIterable = "warning",
                    reportOptionalCall = "none",
                },
            },
        },
    },
}
