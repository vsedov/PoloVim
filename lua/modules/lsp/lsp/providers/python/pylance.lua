local py = require("modules.lsp.lsp.providers.python.utils.python_help")
local path = require("mason-core.path")

return {
    on_init = function(client)
        client.config.settings.python.pythonPath = (function(workspace)
            if vim.env.VIRTUAL_ENV then
                return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
            end
            if vim.fn.filereadable(path.concat({ workspace, "poetry.lock" })) then
                local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
                return path.concat({ venv, "bin", "python" })
            end
            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
        end)(client.config.root_dir)
    end,
    before_init = function(_, config)
        config.settings.python.analysis.stubPath = path.concat({
            vim.fn.stdpath("data"),
            "lazy",
            "site",
            "pack",
            "packer",
            "typings",
            "opt",
            "python-type-stubs",
        })
    end,
    on_new_config = function(new_config, new_root_dir)
        new_config.settings.python.pythonPath = vim.fn.exepath("python") or vim.fn.exepath("python3") or "python"
        new_config.cmd_env.PATH = py.env(new_root_dir) .. new_config.cmd_env.PATH

        local pep582 = py.pep582(new_root_dir)
        if pep582 ~= nil then
            new_config.settings.python.analysis.extraPaths = { pep582 }
        end
    end,
}
