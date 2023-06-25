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
        s = {
            function()
                vim.ui.select({ "popup", "split" }, function(selected)
                    if selected == "popup" then
                        cmd("ExecutorSwapToPopup")()
                    else
                        cmd("ExecutorSwapToSplit")()
                    end
                    vim.cmd("ExecutorToggleDetail")
                end)
            end,
            { exit = true, desc = "Swap to popup/split" },
        },

        S = { cmd("ExecutorToggleDetail"), { exit = true, desc = "Toggle details" } },

        w = {
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

return {
    config,
    "Executor",
    { { "S", "s", "S", "R" }, { "w", "C", "c", "i" } },
    bracket,
    6,
    3,
}
