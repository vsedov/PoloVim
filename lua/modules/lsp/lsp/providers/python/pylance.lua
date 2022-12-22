local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")
local utils = require("modules.lsp.lsp.providers.python.utils")
local util = require("lspconfig.util")
local lsp_util = require("vim.lsp.util")
local path = require("lspconfig/util").path
local Path = require("plenary.path")

local py = require("modules.lsp.lsp.providers.python.utils.python_help")

local M = {}

M.attach_config = function(client, bufnr)
    local caps = client.server_capabilities
    if lambda.config.lsp.python.use_inlay_hints then
        utils.autocmds.InlayHintsAU()
    end
    client.server_capabilities.semanticTokensProvider = {
        legend = {
            tokenTypes = {
                "comment",
                "keyword",
                "string",
                "number",
                "regexp",
                "type",
                "class",
                "interface",
                "enum",
                "enumMember",
                "typeParameter",
                "function",
                "method",
                "property",
                "variable",
                "parameter",
                "module",
                "intrinsic",
                "selfParameter",
                "clsParameter",
                "magicFunction",
                "builtinConstant",
            },
            tokenModifiers = {
                "declaration",
                "static",
                "abstract",
                "async",
                "documentation",
                "typeHint",
                "typeHintComment",
                "readonly",
                "decorator",
                "builtin",
            },
        },
        range = true,
        full = {
            delta = false,
        },
    }
end

M.config = {
    settings = {
        python = {
            analysis = {
                useLibraryCodeForTypes = true,
                completeFunctionParens = true,
                autoImportCompletions = true,
                typeCheckingMode = "off", -- 'strict' or 'basic'
                reportImportCycles = true, -- Use mypy via null-ls for type checking.

                indexing = true,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                },
                -- Honestly just shut this thing up , its actually very annoying
                -- when it just keeps giving pointless error messages.
                diagnosticSeverityOverrides = {
                    --felse: this can get very anonying
                    reportMissingTypeStubs = false,
                    reportGeneralTypeIssues = false,
                    reportUnboundVariable = false,
                    reportUndefinedVariable = "error",
                    reportUntypedClassDecorator = "none",
                    reportUntypedFunctionDecorator = "none",
                    reportFunctionMemberAccess = false,
                    --
                    reportUnknownMemberType = false,
                    reportUnknownVariableType = false,
                    reportUnknownArgumentType = false,
                    reportUnknownParameterType = false,
                    reportUnknownLambdaType = false,
                    strictParameterNoneValue = false,
                    reportOptionalSubscript = false,
                    reportOptionalMemberAccess = false,
                    reportOptionalIterable = false,
                    reportOptionalCall = "none",
                },
            },
        },
    },
    before_init = function(_, config)
        local stub_path = require("lspconfig/util").path.join(
            vim.fn.stdpath("data"),
            "site",
            "pack",
            "packer",
            "typings",
            "opt",
            "python-type-stubs"
        )
        config.settings.python.analysis.stubPath = stub_path
    end,
    on_new_config = function(new_config, new_root_dir)
        py.env(new_root_dir)
        new_config.settings.python.pythonPath = vim.fn.exepath("python") or vim.fn.exepath("python3") or "python"
        -- new_config.cmd_env.PATH = py.env(new_root_dir) .. new_config.cmd_env.PATH

        local pep582 = py.pep582(new_root_dir)

        if pep582 ~= nil then
            new_config.settings.python.analysis.extraPaths = { pep582 }
        end
    end,
}

return M
