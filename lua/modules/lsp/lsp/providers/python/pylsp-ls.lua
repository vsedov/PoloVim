return {
    -- if python format by efm, disable formatting capabilities for pylsp
    settings = {
        pylsp = {
            -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
            plugins = {
                -- Formatting is taken care of by null-ls
                ["pylsp_black"] = { enabled = false },
                ["pyls_isort"] = { enabled = false },
                flake8 = { enabled = false },
                -- flake8 = {
                --   enabled = true,
                --   exclude = ".git,__pycache__,build,dist,.eggs",
                --   ignore = flake8_ignore,
                -- },
                jedi_completion = {
                    eager = true,
                    cache_labels_for = { "pandas", "numpy", "pydantic", "fastapi", "flask", "sqlalchemy" },
                },
                pylsp_mypy_rnx = { enabled = false },
                -- pylsp_mypy_rnx = {
                --   log = { file = log_dir .. "/pylsp-mypy-rnx.log", level = "DEBUG" },
                --   enabled = true,
                --   live_mode = false,
                --   dmypy = true,
                --   daemon_args = {
                --     start = { "--log-file", log_dir .. "/dmypy.log" },
                --     check = { "--perf-stats-file", log_dir .. "/dmypy-check-perfs.json" },
                --   },
                --   args = {
                --     "--sqlite-cache", -- Use an SQLite database to store the cache.
                --     "--cache-fine-grained", -- Include fine-grained dependency information in the cache for the mypy daemon.
                --   },
                -- },
                -- Disabled ones:
                mccabe = { enabled = false },
                preload = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                rope_completion = { enabled = false },
                yapf = { enabled = false },
            },
        },
    },
}
