local leader = "<leader>r"
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end
local bracket = { "<cr>", "W", "w", "r", "R", "q", "e", "s", "S", "d", "<leader>", "l" }

-- Open compiler
vim.keymap.set("n", "<F6>", "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })

-- Toggle compiler results
vim.keymap.set("n", "<S-7>", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })

local config = {
    Runner = {
        color = "red",
        body = leader,
        mode = { "n" },
        on_enter = function() end,
        ["<ESC>"] = { nil, { exit = true } },
        r = { cmd("CompilerOpen"), { desc = "Compiler Open", exit = true } },
        e = {
            function()
                local overseer = require("overseer")
                local action_util = require("overseer.action_util")

                local bufnr = vim.api.nvim_get_current_buf()
                local task = vim.tbl_filter(function(t)
                    return (t.strategy.bufnr == bufnr)
                end, overseer.list_tasks())[1]
                if task then
                    action_util.run_task_action(task)
                else
                    vim.cmd("OverseerTaskAction")
                end
            end,
            { desc = "OS Task Action", exit = true },
        },
        R = {
            function()
                vim.cmd("CompilerStop") -- (Optional, to dispose all tasks before redo)
                vim.cmd("CompilerRedo")
            end,
            { desc = "Compiler Redo", exit = true },
        },
        q = {
            function()
                vim.cmd("CompilerToggleResults")
            end,
            { desc = "Compiler Toggle Results", exit = true },
        },

        w = {
            function()
                local overseer = require("overseer")
                local tasks = overseer.list_tasks({ recent_first = true })
                if vim.tbl_isempty(tasks) then
                    vim.notify("No tasks found", vim.log.levels.WARN)
                    vim.cmd([[CompilerOpen]])
                else
                    -- print("Restarting task: " .. tasks[1])
                    vim.pretty_print(tasks)
                    overseer.run_action(tasks[1], "restart")
                end
            end,
            { desc = "Compiler Restart", exit = true },
        },

        W = { cmd("OverseerToggle"), { desc = "OS Toggle", exit = true } },
        s = {
            function()
                vim.cmd("OverseerRun")
                vim.cmd("OverseerOpen")
            end,
            { desc = "OS Run", exit = true },
        },
        S = { cmd("OverseerQuickAction open"), { desc = "OS Quick Action", exit = true } },
        d = { cmd("OverseerTaskAction"), { desc = "OS Action", exit = true } },
        b = { cmd("OverseerBuild"), { desc = "OS Build", exit = true } },
        l = { cmd("OverseerLoadBundle"), { desc = "OS Load", exit = true } },
        ["<leader>"] = { cmd("OverseerRunCmd"), { desc = "OS Run Cmd", exit = true } },

        ["<cr>"] = {
            function()
                local overseer = require("overseer")
                local command = "Run "
                    .. vim.bo.filetype:gsub("^%l", string.upper)
                    .. " file ("
                    .. vim.fn.expand("%:t")
                    .. ")"

                vim.notify(command)
                overseer.run_template({ name = command })
            end,
            { exit = true, desc = "OS Fast Run" },
        },

        [";"] = { cmd("RunCode"), { exit = true, desc = "RunCode" } },
    },
}

return {
    config,
    "Runner",
    { { "b" } },
    bracket,
    6,
    3,
    2,
}
