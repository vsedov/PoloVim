local hydra = require("hydra")

hydra({
    name = "Parenth-mode",
    config = { color = "pink" },
    mode = "n",
    body = "<localleader>p",
    heads = {
        {
            "j",
            function()
                vim.fn.search("[({[]")
            end,
            { nowait = true, desc = "next (" },
        },
        {
            "k",
            function()
                vim.fn.search("[({[]", "b")
            end,
            { nowait = true, desc = "previous (" },
        },
        { "dj", "d]%", { nowait = true, desc = "next (" } },
        { "dJ", "d%", { nowait = true, desc = "next (" } },
        { "cj", "ct)", { nowait = true, desc = "next (" } },
        { "cJ", "c%", { nowait = true, desc = "next (" } },
        { km.localleader("p"), nil, { exit = true } },
    },
})
