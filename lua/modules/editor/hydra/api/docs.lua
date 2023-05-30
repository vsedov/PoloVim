local bracket = { "d", "s", "c", "D" }

local config = {
    Docs = {
        color = "pink",
        body = "<leader>d",
        mode = { "n", "v", "x", "o" },
        ["<Esc>"] = { nil, { exit = true } },
        -- Neogen stuff
        d = {
            function()
                require("neogen").generate()
            end,
            { nowait = true, silent = true, desc = "Gen Doc ", exit = true },
        },
        c = {
            function()
                require("neogen").generate({ type = "class" })
            end,
            { nowait = true, silent = true, desc = "Gen class ", exit = true },
        },
        s = {
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
        D = {
            function()
                vim.cmd("DocsViewToggle")
            end,
            { nowait = true, silent = true, desc = "Live Docs ", exit = true },
        },
    },
}

return {
    config,
    "Docs",
    { "i", "p" },
    { "d", "s", "c", "D" },
    5,
    3,
}
