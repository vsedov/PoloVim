local leader = ";r"
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local run_or_test = function(debug)
    local ft = vim.bo.filetype
    if ft == "lua" then
        return ":RunCode<CR>"
    else
        local m = vim.fn.mode()
        if m == "n" or m == "i" then
            cmd("Lab code run")
        else
            require("sniprun").run("v")
        end
    end
end

local bracket = { "<cr>", "w", "s", "r", "f" }
local config = {
    Runner = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        w = { cmd("OverseerToggle"), { desc = "OS Toggle", exit = true } },
        s = { cmd("OverseerRun"), { desc = "OS Run", exit = true } },
        d = { cmd("OverseerQuickAction"), { desc = "OS Quick Action", exit = true } },
        t = { cmd("OverseerTaskAction"), { desc = "OS Action", exit = true } },
        b = { cmd("OverseerBuild"), { desc = "OS Build", exit = true } },
        l = { cmd("OverseerLoadBundle"), { desc = "OS Load", exit = true } },
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
            { exit = true, desc = "OS Fast Run" },
        },

        r = { cmd("RunCode"), { exit = true, desc = "RunCode" } },
        f = {
            function()
                run_or_test()
            end,
            { exit = true, desc = "Run Code/Test" },
        },
        S = {
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
        C = {
            function()
                require("sniprun").clear_repl()
            end,
            { exit = true, desc = "SnipRun Clear Repl" },
        },
        I = {
            function()
                require("sniprun").info()
            end,
            { exit = true, desc = "SnipRun Info" },
        },
        R = {
            function()
                require("sniprun.display").close_all()
            end,
            { exit = true, desc = "SnipRun Close All" },
        },
    },
}
return {
    config,
    "Runner",
    { { "d", "t", "b", "l" }, { "S", "C", "I", "R" } },
    bracket,
    6,
    3,
}
