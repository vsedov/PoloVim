local Hydra = require("hydra")

local hint = [[
^^^^^^           Move         ^^^^^^   ^^     Split         ^^^^    Size
^^^^^^------------------------^^^^^^   ^^---------------    ^^^^-------------
^ ^ _k_ ^ ^   ^ ^   _wk_ ^ ^            _s_: horizontally    _+_ _-_: height
_h_ ^ ^ _l_   _wh_ _<cr>_ _wl_          _v_: vertically      _>_ _<_: width
^ ^ _j_ ^ ^   ^  ^  _wj_ ^  ^           _q_: exit           ^ _=_ ^: equalize
focus^^^^^^       winshift ^^^^^^
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
        { "wh", "<Cmd>WinShift left<CR>" },
        { "wj", "<Cmd>WinShift down<CR>" },
        { "wk", "<Cmd>WinShift up<CR>" },
        { "wl", "<Cmd>WinShift right<CR>" },
        { "<cr>", "<Cmd>WinShift<CR>" },

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
