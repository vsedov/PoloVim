-- -- https://github.com/Oliver-Leete/Configs/tree/master/nvim/lua
local overseer = require("overseer")
local constants = require("overseer.constants")
local files = require("overseer.files")
local STATUS = require("overseer.constants").STATUS
local TAG = constants.TAG

return {
    condition = {
        callback = function(opts)
            return files.exists(files.join(opts.dir, "pyproject.toml")) or vim.bo.filetype == "python"
        end,
    },
    generator = function(_)
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
        }

        local ret = {}
        local priority = 60
        for _, command in pairs(commands) do
            table.insert(ret, {
                name = command.name,
                builder = function()
                    return {
                        name = command.tskName or command.name,
                        cmd = command.cmd,
                        components = command.components or { "default" },
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
