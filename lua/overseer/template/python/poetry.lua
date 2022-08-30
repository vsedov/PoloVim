-- https://github.com/Oliver-Leete/Configs/tree/master/nvim/lua
local overseer = require("overseer")
local constants = require("overseer.constants")
local files = require("overseer.files")
local STATUS = require("overseer.constants").STATUS
local TAG = constants.TAG

local condFunc = function(opts)
    return files.exists(files.join(opts.dir, "Project.toml"))
end

return {
    condition = {
        callback = function(opts)
            return files.exists(files.join(opts.dir, "pyproject.toml"))
        end,
    },

    generator = function(_)
        local commands = {
            {
                name = "Poetry run Project",
                tskName = "Poetry run Project",
                cmd = "poetry run task start",
            },
            {
                name = "Poetry run pre-commit",
                tskName = "Poetry run Project",
                cmd = "poetry run task lint",
            },
            {
                name = "Poetry build",
                cmd = "poetry run task build",
            },
            {
                name = "Poetry freeze",
                cmd = "poetry export -f requirements.txt > requirements.txt --without-hashes",
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
                condition = command.condition or condFunc,
            })
            priority = priority + 1
        end
        return ret
    end,
}
