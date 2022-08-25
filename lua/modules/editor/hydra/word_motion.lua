local Hydra = require("hydra")

Hydra({
    name = "Quick words",
    config = {
        hint = {
            position = "bottom",
            border = "single",
        },
    },

    mode = { "n", "x", "o" },
    body = "<localleader><localleader>",
    heads = {
        { "w", "<Plug>(smartword-w)" },
        { "b", "<Plug>(smartword-b)" },
        { "e", "<Plug>(smartword-e)" },
        { "ge", "<Plug>(smartword-ge)" },
        { "<Esc>", nil, { exit = true, mode = "n" } },
    },
})
