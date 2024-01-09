local bracket = { "n", "N" }
local leader = ";A"
local config = {
    Attempt = {
        color = "red",
        body = leader,

        ["<ESC>"] = { nil, { exit = true } },
        n = {
            function()
                require("attempt").new_select()
            end,
            { desc = "New Attempt", nowait = true, silent = true, exit = true },
        },
        N = {
            function()
                require("attempt").new_input_ext()
            end,
            { desc = "New Attempt", nowait = true, silent = true, exit = true },
        },

        r = {
            function()
                require("attempt").run()
            end,
            { desc = "Run Attempt", nowait = true, silent = true },
        },
        d = {
            function()
                require("attempt").delete_buf()
            end,
            { desc = "Delete Attempt", nowait = true, silent = true },
        },
        R = {
            function()
                require("attempt").rename_buf()
            end,
            { desc = "Rename Attempt", nowait = true, silent = true },
        },
        T = {
            function()
                vim.cmd([[Telescope attempt]])
            end,
            { desc = "Telescope Attempt", nowait = true, silent = true },
        },
    },
}
return {
    config,
    "Attempt",
    { { "r", "d", "R", "T" } },
    bracket,
    6,
    3,
    1,
}
