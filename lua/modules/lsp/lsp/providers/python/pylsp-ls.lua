local util = require("lspconfig/util")
-- local venv_path = os.getenv("VIRTUAL_ENV") -- could be nil
local python_path = "/usr/bin/python"
local pylsp_path = "/home/viv/.local/bin/pylsp"

return {
    cmd = { python_path, pylsp_path },
    settings = {
        pylsp = {
            configurationSources = { "flake8" },
            plugins = {
                jedi_completion = {
                    enabled = true,
                    include_params = true,
                    cache_for = { "numpy", "discord.py", "fastapi" },
                },
                jedi_hover = { enabled = true },
                jedi_definition = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true, all_scopes = true, include_import_symbols = true },

                yapf = { enabled = true },
                flake8 = { enabled = true },
                isort = { enabled = true },
                -- rope_completion = { enabled = true },

                mccabe = { enabled = false, threshold = 15 },
                pylint = { enabled = false },
                preload = { enabled = false },
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                pyflakes = { enabled = false },
            },
            rope = { enable = true },
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
}
