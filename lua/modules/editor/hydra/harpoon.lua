local Hydra = require("hydra")

local harpoon_hint = [[
^ ^ _<enter>_: Toggle Harpoon   _]_: Harpoon Toggle File      ^ ^
^ ^ _a_: Harpoon add file       _;_: Memento toggle           ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _1_: open harpoon file 1    _n_: go to next harpoon file  ^ ^
^ ^ _2_: open harpoon file 2    _p_: go to prev harpoon file  ^ ^
^ ^ _3_: open harpoon file 3    _t_: harpoon marks            ^ ^
^ ^ _4_: open harpoon file 4    _c_: toggle quick cmd menu    ^ ^
^ ^ _5_: open harpoon file 5    _C_: memento Clear            ^ ^
^ ^ _6_: open harpoon file 6                                  ^ ^
^ ^ _7_: open harpoon file 7                                  ^ ^
^ ^ _8_: open harpoon file 8                                  ^ ^
^ ^ _9_: open harpoon file 9                                  ^ ^
^ ^                                                           ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^                             _<Esc>_: quit                 ^ ^
]]

Hydra({
    name = "harpoon",
    hint = harpoon_hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = "n",
    body = "<CR>",
    heads = {
        { "1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>" },
        { "2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>" },
        { "3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>" },
        { "4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>" },
        { "5", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>" },
        { "6", "<cmd>lua require('harpoon.ui').nav_file(6)<CR>" },
        { "7", "<cmd>lua require('harpoon.ui').nav_file(7)<CR>" },
        { "8", "<cmd>lua require('harpoon.ui').nav_file(8)<CR>" },
        { "9", "<cmd>lua require('harpoon.ui').nav_file(9)<CR>" },

        { "n", "<cmd>lua require('harpoon.ui').nav_next()<CR>" },
        { "p", "<cmd>lua require('harpoon.ui').nav_prev()<CR>" },
        { "t", "<cmd>Telescope harpoon marks<CR>", { exit = true } },
        { "c", "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", { exit = true } },
        { "]", [[<cmd>lua require("harpoon.mark").toggle_file()<CR>]], { exit = true } },
        { "<enter>", [[<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]], { exit = true } },
        { "a", [[<cmd>lua require("harpoon.mark").add_file()<CR>]] },

        { ";", [[<cmd>lua require("memento").toggle()<CR>]] },
        { "C", [[<cmd>lua require("memento").clear_history()<CR>]] },


        { "<Esc>", nil, { nowait = true, exit = true, desc = false } },
    },
})
