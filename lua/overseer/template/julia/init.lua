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
            return files.exists(files.join(opts.dir, "Project.toml")) or vim.bo.filetype == "julia"
        end,
    },

    generator = function(_)
        local commands = {
            {
                name = "Julia test server",
                tskName = vim.g.project .. " Test Server",
                cmd = "julia -t auto -e 'using Revise, DaemonMode; serve(print_stack=true, async=false)'",
                condition = { callback = condFunc },
            },
            {
                name = "Julia Open Repl",
                tskName = "Julia Repl",
                cmd = "julia",
            },
            {
                name = "Julia Open Repl in Project",
                tskName = vim.g.project .. " Repl",
                cmd = "julia",
                condition = { callback = condFunc },
            },
            {
                name = "Julia package precompile",
                cmd = "~/.config/nvim/filetype/julia/precompile",
                tskName = vim.g.project .. " Precompile",
                tags = { TAG.BUILD },
                condition = { callback = condFunc },
            },
            {
                name = "Julia build documentation",
                tskName = vim.g.project .. " Doc Build",
                cmd = "~/.config/nvim/filetype/julia/docBuild",
                condition = { callback = condFunc },
            },
            {
                name = "Julia open prebuilt documentation",
                cmd = "browser " .. vim.fn.expand("%:p:h") .. "/docs/build/index.html & sleep 5",
                condition = { callback = condFunc },
            },
            {
                name = "Julia documentation server",
                tskName = vim.g.project .. " Doc Server",
                cmd = [[julia --project=docs -e 'using Revise, ]]
                    .. vim.g.project
                    .. [[, LiveServer; servedocs(launch_browser=true)']],
                components = { "default", { "on_complete_restart", statuses = { STATUS.FAILURE, STATUS.SUCCESS } } },
                condition = { callback = condFunc },
            },
            {
                name = "Open live documentation server",
                cmd = "browser http://localhost:8000 & sleep 5",
                condition = { callback = condFunc },
            },
            {
                name = "Julia documentation tests",
                tskName = vim.g.project .. " Doc Test",
                cmd = "~/.config/nvim/filetype/julia/docTest",
                tags = { TAG.TEST },
                condition = { callback = condFunc },
            },
            {
                name = "Julia retune benchmarks",
                tskName = vim.g.project .. " Retune Bench",
                cmd = [[julia -e '
                using BenchmarkTools
                include("benchmark/PackageBenchmarks.jl")
                tune!(suite)
                BenchmarkTools.save(joinpath(dirname(@__FILE__), "params.json"), params(suite))
                ']],
                condition = { callback = condFunc },
            },
            {
                name = "Julia run file (" .. vim.fn.expand("%:t:r") .. ")",
                tskName = "Running " .. vim.fn.expand("%:t:r"),
                cmd = "julia " .. vim.fn.expand("%:p"),
                condition = { filetype = "julia" },
            },
            {
                name = "Julia profile imports",
                tskName = vim.g.project .. " Profile Imports",
                cmd = [[julia +beta -e '@time_imports using ]] .. vim.g.project .. "'",
                condition = { callback = condFunc },
            },
            {
                name = "Julia profile file (" .. vim.fn.expand("%:t:r") .. ")",
                tskName = "Profiling " .. vim.fn.expand("%:t:r"),
                cmd = "julia ~/.config/nvim/filetype/julia/prof.jl " .. vim.fn.expand("%:p"),
                condition = { filetype = "julia" },
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

        local profileHandler = io.popen(
            [[rg --no-filename --no-heading --no-line-number -e ".*\[\"(.*?)\"\].*@benchmarkable(.*)\$" -r "\$1	\$2"]]
        )
        if profileHandler then
            local Profilable = profileHandler:read("*a")
            profileHandler:close()

            for s in Profilable:gmatch("([^\r\n]+)") do
                local name, command = s:match("([^\t]+)\t([^\t]+)")
                table.insert(ret, {
                    name = "Profile " .. name,
                    builder = function()
                        return {
                            name = "Julia profile " .. name,
                            cmd = "~/.config/nvim/filetype/julia/profBench '" .. command .. "'",
                        }
                    end,
                    priority = priority + 1,
                    params = {},
                })
            end
        end
        return ret
    end,
}
