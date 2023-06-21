local leader = ";r"
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end
local bracket = { "<cr>", "r" }

local config = {
    Executor = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        r = { cmd("ExecutorSetCommand"), { desc = "Set custom command", exit = true } },
        ["<cr>"] = {
            function()
                local command = "Run "
                    .. vim.bo.filetype:gsub("^%l", string.upper)
                    .. " file ("
                    .. vim.fn.expand("%:t")
                    .. ")"
                vim.notify(command)
                vim.cmd("ExecutorRun")
            end,
            { silent = true, exit = true, desc = "Execute command" },
        },

        R = { cmd("ExecutorReset"), { exit = true, desc = "Reset Executor" } },
        S = { cmd("ExecutorSwapToSplit"), { exit = true, desc = "Swap to Split view" } },
        s = { cmd("ExecutorSwapToPopup"), { exit = true, desc = "Swap to Popup view" } },
        I = { cmd("ExecutorShowDetail"), { exit = true, desc = "Show details" } },
        H = { cmd("ExecutorHideDetail"), { exit = true, desc = "Hide details" } },

        [";"] = {
            function()
                local mode = vim.fn.mode()

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
        D = {
            function()
                require("sniprun").info()
            end,
            { exit = true, desc = "SnipRun Info" },
        },
        A = {
            function()
                require("sniprun.display").close_all()
            end,
            { exit = true, desc = "SnipRun Close All" },
        },
    },
}

return {
    config,
    "Executor",
    { { "S", "s" }, { "R", "I", "H" }, { ";", "C", "D", "A" } },
    bracket,
    6,
    3,
}
