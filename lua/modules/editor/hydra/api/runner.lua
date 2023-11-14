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
        mode = { "n" },
        on_enter = function() end,
        ["<ESC>"] = { nil, { exit = true } },
        w = { cmd("OverseerToggle"), { desc = "OS Toggle", exit = true } },
        s = { cmd("OverseerRun"), { desc = "OS Run", exit = true } },
        d = { cmd("OverseerQuickAction open"), { desc = "OS Quick Action", exit = true } },
        D = { cmd("OverseerTaskAction"), { desc = "OS Action", exit = true } },
        b = { cmd("OverseerBuild"), { desc = "OS Build", exit = true } },
        l = { cmd("OverseerLoadBundle"), { desc = "OS Load", exit = true } },
        r = { cmd("CompilerOpen"), { desc = "OS Compiler", exit = true } },
        ["<leader>"] = { cmd("OverseerRunCmd"), { desc = "OS Run Cmd", exit = true } },

        ["<cr>"] = {
            function()
                local overseer = require("overseer")
                local command = "Run "
                    .. vim.bo.filetype:gsub("^%l", string.upper)
                    .. " file ("
                    .. vim.fn.expand("%:t")
                    .. ")"

                overseer.run_template({ name = command })
            end,
            { exit = true, desc = "OS Fast Run" },
        },

        [";"] = { cmd("RunCode"), { exit = true, desc = "RunCode" } },
        W = {
            function()
                local mode = vim.fn.mode()

                if mode == "n" then
                    require("sniprun").run()
                else
                    require("sniprun").run("v")
                end
            end,
            { exit = true, desc = "SnipRun", mode = { "n", "v" } },
        },
        C = {
            function()
                require("sniprun").clear_repl()
            end,
            { exit = true, desc = "SnipRun Clear Repl" },
        },
        c = {
            function()
                require("sniprun.display").close_all()
            end,
            { exit = true, desc = "SnipRun Close All" },
        },

        i = {
            function()
                require("sniprun").info()
            end,
            { exit = true, desc = "SnipRun Info" },
        },
    },
}
local bracket = { "<cr>", "r", ";", "w", "s", "<leader>" }

return {
    config,
    "Runner",
    { { "d", "D", "b", "l" }, { "W", "c", "C", "i" } },
    bracket,
    6,
    3,
}
