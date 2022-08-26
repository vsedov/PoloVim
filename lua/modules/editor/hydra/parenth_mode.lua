local hydra = require("hydra")

hydra({
    name = "Parenth-mode",
    config = { color = "pink", invoke_on_body = true },
    mode = "n",
    body = "\\<leader>",
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
        {
            "dj",
            function()
                lambda.execute_keys("d]%")
            end,
            { nowait = true, desc = "next (" },
        },
        {
            "dJ",
            function()
                lambda.execute_keys("d%")
            end,
            { nowait = true, desc = "next (" },
        },
        {
            "cj",
            function()
                lambda.execute_keys("ct)")
            end,
            { nowait = true, desc = "next (" },
        },
        {
            "cJ",
            function()
                lambda.execute_keys("c%")
            end,
            { nowait = true, desc = "next (" },
        },
    },
})
