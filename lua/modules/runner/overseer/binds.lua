local overseer = require("overseer")
local action_util = require("overseer.action_util")

lambda.command("WatchFormat", function()
    overseer.run_template({ name = "PythonFormat" }, function(task)
        if task then
            -- task:add_component({ "format_on_save", path = vim.fn.expand("%:p") })
            local main_win = vim.api.nvim_get_current_win()
            overseer.run_action(task, "open float")
            vim.api.nvim_set_current_win(main_win)
        else
            vim.notify("WatchFormat not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
        end
    end)
end, {})
lambda.command("OverseerRestartLast", function()
    local overseer = require("overseer")
    local tasks = overseer.list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
    else
        overseer.run_action(tasks[1], "restart")
    end
end, {})
lambda.command("Grep", function(params)
    local args = vim.fn.expandcmd(params.args)
    -- Insert args at the '$*' in the grepprg
    local cmd, num_subs = vim.o.grepprg:gsub("%$%*", args)
    if num_subs == 0 then
        cmd = cmd .. " " .. args
    end
    local cwd
    local has_oil, oil = pcall(require, "oil")
    if has_oil then
        cwd = oil.get_current_dir()
    end
    local task = overseer.new_task({
        cmd = cmd,
        cwd = cwd,
        name = "grep " .. args,
        components = {
            {
                "on_output_quickfix",
                errorformat = vim.o.grepformat,
                open = not params.bang,
                open_height = 8,
                items_only = true,
            },
            -- We don't care to keep this around as long as most tasks
            { "on_complete_dispose", timeout = 30 },
            "default",
        },
    })
    task:start()
end, { nargs = "*", bang = true, bar = true, complete = "file" })
--
lambda.command("OverseerDebugParser", 'lua require("overseer.parser.debug").start_debug_session()', {})

vim.keymap.set("n", "_W", function()
    local overseer = require("overseer")
    local tasks = overseer.list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
        vim.cmd([[CompilerOpen]])
    else
        overseer.run_action(tasks[1], "restart")
    end
end)

vim.keymap.set("n", "_l", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local task = vim.tbl_filter(function(t)
        return (t.strategy.bufnr == bufnr)
    end, overseer.list_tasks())[1]
    if task then
        action_util.run_task_action(task)
    else
        vim.cmd("OverseerTaskAction")
    end
end)

vim.keymap.set("n", "_k", "<cmd>OverseerTaskAction<cr>")
vim.keymap.set("n", "_w", "<cmd>OverseerToggle<cr>")

vim.keymap.set("n", "<leader>>", "<cmd>OverseerQuickAction open<cr>")
vim.keymap.set("n", "<leader><", "<cmd>OverseerQuickAction open here<cr>")
