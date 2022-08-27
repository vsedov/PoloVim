local commands = {
    {
        name = "Python run file (" .. vim.fn.expand("%:t:r") .. ")",
        tskName = "Running " .. vim.fn.expand("%:t:r"),
        cmd = "python " .. vim.fn.expand("%:p"),
        condition = { filetype = "python" },
    },
    {
        name = "Lua run file (" .. vim.fn.expand("%:t:r") .. ")",
        tskName = "Running " .. vim.fn.expand("%:t:r"),
        cmd = "lua " .. vim.fn.expand("%:p"),
        condition = { filetype = "lua" },
    },
    {
        name = "bash run file (" .. vim.fn.expand("%:t:r") .. ")",
        tskName = "Running " .. vim.fn.expand("%:t:r"),
        cmd = "bash " .. vim.fn.expand("%:p"),
        condition = { filetype = "bash" },
    },

    {
        name = "Compile C++ with gdb flag",
        builder = function(params)
            return {
                cmd = {
                    "g++",
                    "-g",
                    vim.api.nvim_buf_get_name(0),
                    "-o",
                    string.format("%s.out", e("%:p:r")),
                },
            }
        end,
        tags = { "BUILD" },
        params = {},
        condition = {
            filetype = { "c", "cpp" },
        },
    },
    {
        name = "Runner",
        builder = function()
            local cmd = "python "
            local ft = vim.bo.filetype
            local runnable = {
                python = "python " .. vim.fn.expand("%:p"),
                lua = "lua " .. vim.fn.expand("%:p"),
            }
            if runnable[ft] then
                cmd = runnable[ft]
            else
                cmd = ""
            end
            return {
                name = "Runner",
                cmd = cmd,
            }
        end,
        priority = 5,
        condition = {
            filetype = { "py", "lua", "c", "cpp", "sh", "rust" },
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
