local leader = "<leader>r"
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local config = {
    Runner = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        w = { cmd("OverseerToggle"), { desc = "OS Toggle", exit = true } },
        s = { cmd("OverseerRun"), { desc = "OS Run", exit = true } },
        d = { cmd("OverseerQuickAction"), { desc = "OS Quick Action", exit = true } },
        D = { cmd("OverseerTaskAction"), { desc = "OS Action", exit = true } },
        b = { cmd("OverseerBuild"), { desc = "OS Build", exit = true } },
        l = { cmd("OverseerLoadBundle"), { desc = "OS Load", exit = true } },
        R = { cmd("OverseerRunCmd"), { desc = "OS Run Cmd", exit = true } },

        ["<cr>"] = {
            function()
                local overseer = require("overseer")
                command = "Run "
                    .. vim.bo.filetype:gsub("^%l", string.upper)
                    .. " file ("
                    .. vim.fn.expand("%:t")
                    .. ")"
                vim.notify(command)
                overseer.run_template({ name = command }, function(task)
                    if task then
                        overseer.run_action(task, "open float")
                    else
                        vim.notify("Task not found")
                    end
                end)
            end,
            { exit = false, desc = "OS Fast Run" },
        },

        r = { cmd("RunCode"), { exit = true, desc = "RunCode" } },
        as = {
            function()
                mode = vim.fn.mode()
                if mode == "n" then
                    require("sniprun").run()
                else
                    require("sniprun").run("v")
                end
            end,
            { exit = true, desc = "SnipRun" },
        },
        ac = {
            function()
                require("sniprun").clear_repl()
            end,
            { exit = true, desc = "SnipRun Clear Repl" },
        },
        ai = {
            function()
                require("sniprun").info()
            end,
            { exit = true, desc = "SnipRun Info" },
        },
        aa = {
            function()
                require("sniprun.display").close_all()
            end,
            { exit = true, desc = "SnipRun Close All" },
        },
    },
}
local bracket = { "<cr>", "w", "s", "r", "R" }

return {
    config,
    "Runner",
    { { "d", "D", "b", "l" }, { "as", "ac", "ai", "aa" } },
    bracket,
    6,
    3,
}
