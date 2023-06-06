local py = require("modules.lsp.lsp.providers.python.utils.python_help")

return {
    filetypes = { "python" },
    on_new_config = function(config, new_workspace)
        config.settings.python.pythonPath = vim.fn.exepath("python") or vim.fn.exepath("python3") or "python"
        config.cmd_env.PATH = py.env(new_workspace) .. new_workspace.cmd_env.PATH
        return config
    end,
}
