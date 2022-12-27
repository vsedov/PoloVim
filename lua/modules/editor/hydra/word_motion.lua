local Hydra = require("hydra")

local harpoon_hint_visual = [[
^ ^ _w_: w       ^ ^
^ ^ _b_: b       ^ ^
^ ^ _e_: e       ^ ^
^ ^ _ge_: ge     ^ ^
^ _<Esc>_: quit  ^ ^
]]

Hydra({
    name = "Quick words",

    hint = harpoon_hint_visual,
    config = {
        color = "teal",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = "single",
        },
    },
    mode = { "n", "x", "o" },
    body = "<localleader>w",
    heads = {
        { "w", "<Plug>(smartword-w)", { exit = false } },
        { "b", "<Plug>(smartword-b)", { exit = false } },
        { "e", "<Plug>(smartword-e)", { exit = false } },
        { "ge", "<Plug>(smartword-ge)", { exit = false } },
        { "<Esc>", nil, { exit = true, mode = "n" } },
    },
})
