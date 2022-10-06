local Hydra = require("hydra")

local refactoring_visual = [[
^ ^ _e_: Extract Function         ^ ^
^ ^ _f_: Extract Function To File ^ ^
^ ^ _v_: Extract Variable         ^ ^
^ ^ _i_: Inline Variable          ^ ^
^ ^ _r_: Select refactor          ^ ^
^ ^ _V_: debug print_var          ^ ^
^ _<Esc>_: quit                   ^ ^
]]

Hydra({
    name = "Refactoring Visual ",
    hint = refactoring_visual,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = "v",
    body = "<leader>r",
    heads = {
        { "e", "<cmd>lua require('refactoring').refactor('Extract Function')<CR>", { exit = false } },
        { "f", "<cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", { exit = true } },
        { "v", "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>", { exit = true } },
        { "i", "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>", { exit = true } },
        { "V", "<cmd>lua require('refactoring').debug.print_var({})<CR>", { exit = true } },
        { "r", "<cmd>lua require('refactoring').select_refactor()<CR>", { exit = true } },
        { "<Esc>", nil, { nowait = true, exit = true, desc = false } },
    },
})

local refactoring_normal = [[
^ ^ _d_: PyCopyReferenceDotted    ^ ^
^ ^ _p_: PyCopyReferencePytest    ^ ^
^ ^ _b_: Extract Block            ^ ^
^ ^ _B_: Extract Block To File    ^ ^
^ ^ _i_: Extract Variable         ^ ^
^ ^ _c_: debug.cleanup            ^ ^
^ _<Esc>_: quit                   ^ ^
]]

Hydra({
    name = "Refactoring normal ",
    hint = refactoring_normal,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = "n",
    body = "<leader>r",
    heads = {
        { "d", "<cmd>PythonCopyReferenceDotted<CR>", { exit = false } },
        { "p", "<cmd>PythonCopyReferencePytest<CR>", { exit = false } },
        { "b", "<cmd>lua require('refactoring').refactor('Extract Block')<CR>", { exit = false } },
        { "B", "<cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", { exit = true } },
        { "i", "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>", { exit = true } },
        { "c", "<cmd>lua require('refactoring').debug.cleanup({})<CR>", { exit = true } },
        { "<Esc>", nil, { nowait = true, exit = true, desc = false } },
    },
})

local debug_time = [[
^ ^ _v_: Debug Above  ^ ^
^ ^ _V_: Debug Below  ^ ^
]]

Hydra({
    name = "Refactoring Visual ",
    hint = debug_time,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = "n",
    body = "dv",
    heads = {
        { "<Esc>", nil, { nowait = true, exit = true, desc = false } },

        { "v", "<cmd>lua require('refactoring').debug.printf({below = true})<CR>", { exit = false } },
        { "V", "<cmd>lua require('refactoring').debug.printf({below = false})<CR>", { exit = true } },
    },
})
