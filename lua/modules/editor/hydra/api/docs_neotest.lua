local leader = "<leader>d"
local bracket = { "d", "D", "E", "i", "p" }

local config = {
    ["Docs/Test"] = {
        color = "pink",
        body = leader,
        position = "bottom-right",
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        -- Neogen stuff
        d = {
            function()
                require("neogen").generate()
            end,
            { nowait = true, silent = true, desc = "Gen Doc ", exit = true },
        },
        E = {
            function()
                require("neogen").generate({ type = "class" })
            end,
            { nowait = true, silent = true, desc = "Gen class ", exit = true },
        },
        D = {
            function()
                require("neogen").generate({ type = "type" })
            end,
            { nowait = true, silent = true, desc = "Gen type ", exit = false },
        },

        -- Reference Stuff
        i = {
            function()
                vim.cmd("RefCopy")
            end,
            { nowait = true, silent = true, desc = "refCopy ", exit = true },
        },
        p = {

            function()
                vim.cmd("RefGo")
            end,
            { nowait = true, silent = true, desc = "RefGo ", exit = true },
        },
        -- Documentation types ?
        L = {
            function()
                vim.cmd("DocsViewToggle")
            end,
            { nowait = true, silent = true, desc = "Live Docs ", exit = true },
        },
    },
}
--

return {
    config,
    "Docs/Test",
    { { "L" } },
    bracket,
    6,
    4,
    1,
}
