-- Quick Note: I think this is a great language server that provides almost everything you would
-- need thoughthere are a few isseus that are a bit annoying, and i hope that they get resolved
-- soon
local py = require("modules.lsp.lsp.providers.python.utils.python_help")

return {
    init_options = {
        jediSettings = {
            case_insensitive_completion = true,
            add_bracket_after_function = true,
            dynamic_params = true,
            -- Allot of machine learning models that are set from default.
            autoImportModules = { "numpy", "matplotlib", "random", "math", "scipy" },
        },
    },

    on_new_config = function(new_config, new_root_dir)
        new_config.settings.python.pythonPath = vim.fn.exepath("python")
        print(new_config.settings.python.pythonPath)
        new_config.cmd_env.PATH = py.env(new_root_dir) .. new_config.cmd_env.PATH

        local pep582 = py.pep582(new_root_dir)
        if pep582 ~= nil then
            new_config.settings.python.analysis.extraPaths = { pep582 }
        end
    end,
}
