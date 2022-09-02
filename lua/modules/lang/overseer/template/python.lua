local overseer = require("overseer")
local constants = require("overseer.constants")
local files = require("overseer.files")
local STATUS = require("overseer.constants").STATUS
local TAG = constants.TAG
local commands = {
    {
        name = "Python run file (" .. vim.fn.expand("%:t:r") .. ")",
        tskName = "Running " .. vim.fn.expand("%:t:r"),
        cmd = "python " .. vim.fn.expand("%:p"),
        condition = { filetype = "python" },
    },
    {
        name = "Poetry run file (" .. vim.fn.expand("%:t:r") .. ")",
        tskName = "Running " .. vim.fn.expand("%:t:r"),
        cmd = "poetry run python" .. vim.fn.expand("%:p"),
        condition = {
            callback = function(opts)
                return files.exists(files.join(opts.dir, "pyproject.toml"))
                    or files.exists(files.join(opts.dir, "poetry.toml"))
            end,
        },
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
        condition = { filetype = "python" },
    },
    {
        name = "Create WorkDir",
        cmd = "mkdir -p /tmp/work",
        condition = { filetype = "python" },
    },
    {
        name = "Run Tests",
        tskName = "Running Tests",
        cmd = "python -m unittest discover",
        condition = { filetype = "python" },
    },
    {
        name = "Show python version",
        cmd = "python",
        args = " --version",
        condition = { filetype = "python" },
    },
    -- vscode tasks.json wraper
    {
        name = "Jedi upgrade",
        cmd = "pipx upgrade jedi-language-server",
        condition = { filetype = "python" },
    },
    {
        name = "Poetry run Project",
        tskName = "Poetry run Project",
        cmd = "poetry run task start",
        -- Find pyproject.toml to root of the project
        --  using vim.fs.find and upwards = true
        condition = {
            callback = function(opts)
                return files.exists(files.join(opts.dir, "pyproject.toml"))
                    or files.exists(files.join(opts.dir, "poetry.toml"))
            end,
        },
    },
    {
        name = "Poetry run pre-commit",
        tskName = "poetry run Project",
        cmd = "poetry run task lint",
        condition = {
            callback = function(opts)
                return files.exists(files.join(opts.dir, "pyproject.toml"))
                    or files.exists(files.join(opts.dir, "poetry.toml"))
            end,
        },
    },
    {
        name = "poetry build",
        cmd = "poetry run task build",
        condition = {
            callback = function(opts)
                return files.exists(files.join(opts.dir, "pyproject.toml"))
                    or files.exists(files.join(opts.dir, "poetry.toml"))
            end,
        },
    },
    {
        name = "poetry freeze",
        cmd = "poetry export -f requirements.txt > requirements.txt --without-hashes",
        condition = {
            callback = function(opts)
                return files.exists(files.join(opts.dir, "pyproject.toml"))
                    or files.exists(files.join(opts.dir, "poetry.toml"))
            end,
        },
    },
}

local ret = {}
for _, command in pairs(commands) do
    table.insert(ret, {
        name = command.name,
        builder = command.builder or function()
            return {
                name = command.tskName or command.name,
                cmd = command.cmd,
                components = command.components or { "default" },
            }
        end,
        tags = command.tags,
        params = command.params or {},
        condition = command.condition,
    })
end
return ret
