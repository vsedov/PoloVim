local leader = "<leader>m"

local exit = { nil, { exit = true, desc = "EXIT" } }

local config = {
    Muren = {
        color = "red",
        body = leader,
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        m = {
            function()
                vim.cmd("MurenToggle")
            end,
            { desc = "Toggle UI", exit = true },
        },
        o = {
            function()
                vim.cmd("MurenOpen")
            end,
            { desc = "Open UI", exit = true },
        },
        c = {
            function()
                vim.cmd("MurenClose")
            end,
            { desc = "Close UI", exit = true },
        },

        f = {
            function()
                vim.cmd("MurenFresh")
            end,
            { desc = "Open Fresh UI", exit = true },
        },
        u = {
            function()
                vim.cmd("MurenUnique")
            end,
            { desc = "Open Unique UI", exit = true },
        },
    },
}
local bracket = { "m", "o", "c", "f", "u" }
return {
    config,
    "Muren",
    {},
    bracket,
    6,
    3,
}
