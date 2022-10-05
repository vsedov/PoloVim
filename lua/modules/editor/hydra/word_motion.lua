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
        { "w", "<Plug>(smartword-w)" },
        { "b", "<Plug>(smartword-b)" },
        { "e", "<Plug>(smartword-e)" },
        { "ge", "<Plug>(smartword-ge)" },
        { "<Esc>", nil, { exit = true, mode = "n" } },
    },
})
