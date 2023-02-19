local previous_cmd = ""
local overseer = require("overseer")
local ft = vim.api.nvim_create_user_command("T", function(param)
    vim.cmd("OverseerOpen!")
    param = "python %" or param
    vim.cmd("OverseerRunCmd " .. param)
    previous_cmd = param
end, { nargs = "?", force = true })

vim.keymap.set("n", "_W", "<Cmd>OverseerToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "_w", function()
    if previous_cmd == "" then
        vim.cmd([[T]])
    end
    vim.cmd("OverseerOpen")
    vim.cmd("OverseerRunCmd " .. previous_cmd)
end, { noremap = true, silent = true })

vim.api.nvim_create_user_command("Tp", function(param)
    -- vim.cmd("OverseerOpen")
    command = "Run " .. vim.bo.filetype:gsub("^%l", string.upper) .. " file (" .. vim.fn.expand("%:t") .. ")"
    overseer.run_template({ name = command }, function(task)
        if task then
            overseer.run_action(task, "open")
        end
    end)
end, { nargs = "?", force = true })

vim.api.nvim_create_user_command("WatchFormat", function()
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
