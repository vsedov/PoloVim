local previous_cmd = ""
local overseer = require("overseer")

lambda.command("T", function(param)
    param = "python %" or param
    vim.cmd("OverseerRunCmd " .. param)
    previous_cmd = param
end, { nargs = "?", force = true })

vim.keymap.set("n", "_w", "<Cmd>OverseerToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "_W", function()
    vim.cmd("OverseerOpen")
    if previous_cmd == "" then
        vim.cmd([[T]])
        return
    else
        vim.cmd("OverseerRunCmd " .. previous_cmd)
    end
end, { noremap = true, silent = true })

lambda.command("Tp", function()
    -- vim.cmd("OverseerOpen")
    command = "Run " .. vim.bo.filetype:gsub("^%l", string.upper) .. " file (" .. vim.fn.expand("%:t") .. ")"
    overseer.run_template({ name = command }, function(task)
        if task then
            overseer.run_action(task, "open")
        end
    end)
end, { nargs = "?", force = true })

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
lambda.command("OverseerDebugParser", 'lua require("overseer").debug_parser()', {})
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
