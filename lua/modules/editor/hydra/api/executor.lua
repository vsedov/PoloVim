local leader = ";r"
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end
bracket = { "<cr>", "r" }

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
    },
}

return {
    config,
    "Executor",
    { { "S", "s" }, { "R", "I", "H" } },
    bracket,
    6,
    3,
}
