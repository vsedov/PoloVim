local leader = ";h"

-- {
--     "g,",
--     function()
--         vim.cmd("HopVertical")
--     end,
--     desc = "Hop Vertical",
-- },
-- {
--     "g<cr>",
--     function()
--         vim.cmd("HopPattern")
--     end,
--     desc = "Hop Pattern",
-- },
local config = {
    Hop = {
        color = "pink",
        body = leader,
        mode = { "n", "x", "v" },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        ["<cr>"] = {
            function()
                vim.cmd([[HopPattern]])
            end,
            { nowait = true, silent = true, desc = "Hop pattern" },
        },
        v = {
            function()
                vim.cmd([[HopVertical]])
            end,
            { nowait = true, silent = true, desc = "Hop vertical" },
        },

        w = {
            function()
                vim.cmd([[HopWord]])
            end,
            { nowait = true, silent = true, desc = "Hop word" },
        },
        a = {
            function()
                vim.cmd([[HopAnywhere]])
            end,
            { nowait = true, silent = true, desc = "Hop anywhere" },
        },
        c = {
            function()
                vim.cmd([[HopChar1]])
            end,
            { nowait = true, silent = true, desc = "Hop char 1" },
        },
        C = {
            function()
                vim.cmd([[HopChar2]])
            end,
            { nowait = true, silent = true, desc = "Hop char 2" },
        },
        n = {
            function()
                vim.cmd([[HopLine]])
            end,
            { nowait = true, silent = true, desc = "Hop line" },
        },
        s = {
            function()
                vim.cmd([[HopLineStart]])
            end,
            { nowait = true, silent = true, desc = "Hop line start" },
        },
    },
}

return {
    config,
    "Hop",
    { { "c", "C", "n", "s" } },
    { "<cr>", "w", "a" },
    6,
    3,
}
