local Hydra = require("hydra")

local hint = [[
^^^^^^           Move         ^^^^^^   ^^     Split         ^^^^    Size
^^^^^^------------------------^^^^^^   ^^---------------    ^^^^------------- 
^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^   ^ ^ _wk_ ^ ^     _s_: horizontally    _+_ _-_: height
_h_ ^ ^ _l_   _H_ ^ ^ _L_   _wh_ ^ ^ _wl_    _v_: vertically      _>_ _<_: width
^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^   ^  ^ _wj_^  ^    _q_: exit           ^ _=_ ^: equalize
focus^^^^^^   window^^^^^^  float ^^^^^^
^ ^ ^ ^ ^ ^   ^ ^ ^ ^ ^ ^    _b_: choose buffer   ^ ^ ^ ^    _<Esc>_ 
]]

Hydra({
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = false,
        hint = {
            position = "bottom",
            border = "single",
        },
    },
    mode = "n",
    body = "<C-w>",
    heads = {
        -- Move focus
        { "h", "<C-w>h" },
        { "j", "<C-w>j" },
        { "k", "<C-w>k" },
        { "l", "<C-w>l" },

        -- Move window
        { "H", "<Cmd>WinShift left<CR>" },
        { "J", "<Cmd>WinShift down<CR>" },
        { "K", "<Cmd>WinShift up<CR>" },
        { "L", "<Cmd>WinShift right<CR>" },
        -- Split
        { "s", "<C-w>s" },
        { "v", "<C-w>v" },
        -- Size
        { "+", "<C-w>+" },
        { "-", "<C-w>-" },
        { ">", "2<C-w>>", { desc = "increase width" } },
        { "<", "2<C-w><", { desc = "decrease width" } },
        { "=", "<C-w>=", { desc = "equalize" } },
        { "b", "<Cmd>BufExplorer<CR>", { exit = true, desc = "choose buffer" } },
        { "<Esc>", nil, { exit = true } },
        { "q", "<Cmd>Bwipeout<CR>", { desc = "close window" } },
    },
})

Hydra({
    name = "Side Scroll",
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom",
            border = "rounded",
        },
    },
    mode = "n",
    body = "\\z",
    heads = {
        { "h", "5zh" },
        { "l", "5zl", { desc = "←/→" } },
        { "H", "zH" },
        { "L", "zL", { desc = "half screen ←/→" } },
    },
})
