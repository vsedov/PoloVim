-- https://github.com/Oliver-Leete/Configs/tree/master/nvim/lua
local overseer = require("overseer")
local constants = require("overseer.constants")
local files = require("overseer.files")
local STATUS = require("overseer.constants").STATUS
local TAG = constants.TAG

local isInProject = function(opts)
    return files.exists(files.join(opts.dir, "pyproject.toml")) or files.exists(files.join(opts.dir), "poetry.toml")
end

return {
    condition = {
        callback = function(opts)
            return isInProject(opts) or vim.bo.filetype == "python"
        end,
    },

    generator = function(_)
        local commands = {

            {
                name = "poetry build",
                cmd = "poetry run task build",
                condition = {
                    callback = isInProject,
                },

                unique = true,
            },
            {
                name = "Python run file (" .. vim.fn.expand("%:t:r") .. ")",
                tskName = "Running " .. vim.fn.expand("%:t:r"),
                cmd = "python " .. vim.fn.expand("%:p"),
                condition = { filetype = "python" },
                unique = true,
            },
            {
                name = "Poetry run file (" .. vim.fn.expand("%:t:r") .. ")",
                tskName = "Running " .. vim.fn.expand("%:t:r"),
                cmd = "poetry run python " .. vim.fn.expand("%:p"),
                condition = {
                    callback = isInProject,
                },
                unique = true,
            },

            {
                name = "Poetry run Project",
                tskName = "Poetry run Project",
                cmd = "poetry run task start",
                -- Find pyproject.toml to root of the project
                --  using vim.fs.find and upwards = true
                condition = {
                    callback = isInProject,
                },

                unique = true,
            },

            {
                name = "Poetry run pre-commit",
                tskName = "poetry run Project",
                cmd = "poetry run task lint",
                condition = {
                    callback = isInProject,
                },

                unique = true,
            },
            {
                name = "Python test server",
                tskName = "Running Tests",
                cmd = "python -m unittest discover",
                condition = { callback = isInProject },
                is_test_server = true,
                hide = true,
                unique = true,
            },
            {
                name = "Create Python Venv",
                tskName = "Python Venv",
                cmd = {
                    "python",
                },

                args = {
                    "-m",
                    "venv",
                    vim.fs.find(".git", {
                        file = true,
                        directories = true,
                        recursive = true,
                        pattern = ".git",
                    })[1],
                },
                unique = true,
                condition = { filetype = "python" },
            },
            {
                name = "Create WorkDir",
                unique = true,
                cmd = "mkdir -p /tmp/work",
                condition = { filetype = "python" },
            },
            {
                name = "Show python version",
                cmd = "python",
                args = " --version",

                unique = true,
                condition = { filetype = "python" },
            },
            {
                name = "Jedi upgrade",
                cmd = "pipx upgrade jedi-language-server",
                condition = { filetype = "python" },
                unique = true,
            },

            {
                name = "poetry freeze",
                cmd = "poetry export -f requirements.txt > requirements.txt --without-hashes",
                condition = {
                    callback = isInProject,
                },

                unique = true,
            },
        }
        local ret = {}
        local priority = 60
        for _, command in pairs(commands) do
            local comps = {
                "on_output_summarize",
                "on_exit_set_status",
                "on_complete_notify",
                "on_complete_dispose",
            }

            table.insert(ret, {
                name = command.name,
                builder = function()
                    return {
                        name = command.tskName or command.name,
                        cmd = command.cmd,
                        components = comps,
                        metadata = {
                            is_test_server = command.is_test_server,
                        },
                    }
                end,
                tags = command.tags,
                priority = priority,
                params = {},
                condition = command.condition,
            })
            priority = priority + 1
        end
        return ret
    end,
}
