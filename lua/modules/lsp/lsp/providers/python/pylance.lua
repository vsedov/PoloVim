local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")
local utils = require("modules.lsp.lsp.providers.python.utils")
local util = require("lspconfig.util")
local lsp_util = require("vim.lsp.util")
local path = require("lspconfig/util").path
-- client.server_capabilities.executeCommandProvider
local _commands = {
    "pyright.createtypestub",
    "pyright.organizeimports",
    "pyright.addoptionalforparam",
    "python.createTypeStub",
    "python.orderImports",
    "python.addOptionalForParam",
    "python.removeUnusedImport",
    "python.addImport",
    "python.intellicode.completionItemSelected",
    "python.intellicode.loadLanguageServerExtension",
    "pylance.extractMethod",
    "pylance.extractVariable",
    "pylance.dumpFileDebugInfo",
    "pylance.completionAccepted",
    "pylance.executedClientCommand",
}

local function organize_imports()
    local params = {
        command = "pyright.organizeimports",
        arguments = { vim.uri_from_bufnr(0) },
    }
    vim.lsp.buf.execute_command(params)
end

local function extract_variable()
    local pos_params = vim.lsp.util.make_given_range_params()
    local params = {
        command = "pylance.extractVariable",
        arguments = {
            vim.api.nvim_buf_get_name(0),
            pos_params.range,
        },
    }
    vim.lsp.buf.execute_command(params)
    -- vim.lsp.buf.rename()
end

local function extract_method()
    local pos_params = vim.lsp.util.make_given_range_params()
    local params = {
        command = "pylance.extractMethod",
        arguments = {
            vim.api.nvim_buf_get_name(0),
            pos_params.range,
        },
    }
    vim.lsp.buf.execute_command(params)
    -- vim.lsp.buf.rename()
end

local function on_workspace_executecommand(err, actions, ctx)
    if ctx.params.command:match("WithRename") then
        ctx.params.command = ctx.params.command:gsub("WithRename", "")
        vim.lsp.buf.execute_command(ctx.params)
    end
end

local M = {}
M.creation = function()
    require("lspconfig.configs").pylance = {
        default_config = {
            name = "pylance",
            autostart = true,
            single_file_support = true,
            cmd = {
                "node",
                vim.fn.expand(
                    "/home/viv/.local/share/nvim/lsp_servers/pylance/extension/dist/server.bundle.js",
                    false,
                    true
                )[1],
                "--stdio",
            },
            filetypes = { "python" },
            root_dir = function(fname)
                local markers = {
                    "Pipfile",
                    "pyproject.toml",
                    "pyrightconfig.json",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                }
                -- return markers
                return lsputil.root_pattern(unpack(markers))(fname)
                    or lsputil.find_git_ancestor(fname)
                    or lsputil.path.dirname(fname)
            end,
            handlers = {
                ["workspace/executeCommand"] = on_workspace_executecommand,
            },
            settings = {
                python = {
                    telemetry = {
                        enable = false,
                    },
                },
                telemetry = {
                    telemetryLevel = "off",
                },
            },
            docs = {
                package_json = vim.fn.expand(
                    "/home/viv/.local/share/nvim/lsp_servers/pylance/extension/package.json",
                    false,
                    true
                )[1],
                description = [[
         https://github.com/microsoft/pyright
         `pyright`, a static type checker and language server for python
         ]],
            },
        },
    }
end
local Path = require("plenary.path")
local scan = require("plenary.scandir")

function pathFinder(hidden_file, filename, error)
    hidden_file = hidden_file or false

    local cwd = vim.fn.getcwd()
    local current_path = vim.api.nvim_exec(":echo @%", 1)
    local parents = Path:new(current_path):parents()
    for _, parent in pairs(parents) do
        local files = scan.scan_dir(parent, { hidden = hidden_file, depth = 1 })
        for _, file in pairs(files) do
            if file == parent .. "/" .. filename then
                return parent, file
            end
        end

        if parent == cwd then
            break
        end
    end

    vim.notify(error, "error", { title = "py.nvim" })
end

local function get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end

    -- Find and use virtualenv via poetry in workspace directory.
    -- Change this to get it from the root file where git is
    local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
    -- local match = pathFinder(false, poetry.lock, "Poetry env not found")
    if match ~= "" then
        local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
        return path.join(venv, "bin", "python")
    end

    -- Fallback to system Python.
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

local function on_window_logmessage(err, content, ctx)
    if content.type == 3 then
        vim.notify(content.message)
    end
end

M.attach_config = function(client, bufnr)
    client.commands["pylance.extractVariableWithRename"] = function(command, enriched_ctx)
        command.command = "pylance.extractVariable"
        vim.lsp.buf.execute_command(command)
    end

    client.commands["pylance.extractMethodWithRename"] = function(command, enriched_ctx)
        command.command = "pylance.extractMethod"
        vim.lsp.buf.execute_command(command)
    end

    vim.api.nvim_buf_create_user_command(
        bufnr,
        "PylanceOrganizeImports",
        organize_imports,
        { desc = "Organize Imports" }
    )

    vim.api.nvim_buf_create_user_command(
        bufnr,
        "PylanceExtractVariable",
        extract_variable,
        { range = true, desc = "Extract variable" }
    )

    vim.api.nvim_buf_create_user_command(
        bufnr,
        "PylanceExtractMethod",
        extract_method,
        { range = true, desc = "Extract methdod" }
    )

    if lambda.config.lsp.python.pylance.use_inlay_hints then
        utils.autocmds.InlayHintsAU()
    end
    if lambda.config.lsp.use_semantic_token then
        utils.autocmds.SemanticTokensAU()
    end
end
M.config = {
    settings = {
        python = {
            analysis = {
                completeFunctionParens = true,
                indexing = true,
                typeCheckingMode = "basic",
                diagnosticMode = "workspace",
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                },
                diagnosticSeverityOverrides = {
                    -- information : this can get very anonying
                    reportMissingTypeStubs = false,
                    -- stuff from top
                    -- reportGeneralTypeIssues = "warning",
                    -- reportUnboundVariable = "warning",
                    -- reportUndefinedVariable = "error",
                    -- reportUntypedClassDecorator = "none",
                    -- reportUntypedFunctionDecorator = "none",
                    -- reportFunctionMemberAccess = "warning",
                    --
                    -- reportUnknownMemberType = "information",
                    -- reportUnknownVariableType = "information",
                    -- reportUnknownArgumentType = "warning",
                    -- reportUnknownParameterType = "warning",
                    -- reportUnknownLambdaType = "warning",
                    --
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
    before_init = function(_, config)
        local stub_path = require("lspconfig/util").path.join(
            vim.fn.stdpath("data"),
            "site",
            "pack",
            "packer",
            "opt",
            "python-type-stubs"
        )
        config.settings.python.analysis.stubPath = stub_path
    end,
    on_init = function(client)
        client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
    end,
}

return M
