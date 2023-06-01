local bracket = { "n", "N" }
local leader = ";A"
local config = {
    Attempt = {
        color = "red",
        body = leader,

        ["<ESC>"] = { nil, { exit = true } },
        n = { require("attempt").new_select, { desc = "New Attempt", nowait = true, silent = true, exit = true } },
        N = { require("attempt").new_input_ext, { desc = "New Attempt", nowait = true, silent = true, exit = true } },

        r = { require("attempt").run, { desc = "Run Attempt", nowait = true, silent = true } },
        d = { require("attempt").delete_buf, { desc = "Delete Attempt", nowait = true, silent = true } },
        R = { require("attempt").rename_buf, { desc = "Rename Attempt", nowait = true, silent = true } },
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
}
