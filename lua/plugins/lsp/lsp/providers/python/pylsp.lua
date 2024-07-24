local util = require("lspconfig/util")
local py = require("modules.lsp.lsp.providers.python.utils.python_help")
local path = require("mason-core.path")
return {
    settings = {
        pylsp = {
            plugins = {
                pyflakes = { enabled = false },
                yapf = { enabled = false },
                isort = { enabled = false },
                mccabe = { enabled = false, threshold = 15 },
                pylint = { enabled = false },
                preload = { enabled = false },
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                ruff = { enable = false },
                flake8 = { enabled = false },
                jedi_completion = { fuzzy = true, enabled = true },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true, all_scopes = true },
                rope = { enable = true },
                rope_completion = { enabled = false },
            },
        },
    },
    root_dir = function(fname)
        local root_files = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
        }
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    on_new_config = function(client)
        client.config.settings.python.pythonPath = function()
            if vim.env.VIRTUAL_ENV or require("modules.lsp.lsp.providers.python.utils.python_help").in_any_env() then
                return vim.fn.exepath("python3")
            end

            if vim.env.VIRTUAL_ENV then
                return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
            end
            local pep582 = py.pep582(client)
            if pep582 ~= nil then
                client.config.settings.python.analysis.extraPaths = { pep582 }
            end
        end
    end,
}
