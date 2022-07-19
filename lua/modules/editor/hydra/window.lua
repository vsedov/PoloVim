local Hydra = require("hydra")
local splits = require("smart-splits")

local function cmd(command)
    return table.concat({ "<Cmd>", command, "<CR>" })
end

local window_hint = [[
 ^^^^^^^^^^^^             Move         ^^    Size   ^^  ^^     Split
 ^^^^^^^^^^^^------------------------- ^^-----------^^  ^^---------------
 ^ ^ _k_ ^ ^  ^  ^  _wk_  ^  ^  ^ ^ _K_ ^ ^  ^   _<A-k>_   ^   _s_: horizontally 
 _h_ ^ ^ _l_  _wh_ _<cr>_ _wl_  _H_ ^ ^ _L_  _<A-h>_ _<A-l>_   _v_: vertically
 ^ ^ _j_ ^ ^  ^  ^  _wj_  ^  ^  ^ ^ _J_ ^ ^  ^   _<A-j>_   ^   _q_, _c_: close
 ^^ focus ^  ^^winshift^  ^^Split^^^^^^^^^^  ^_=_: equalize^   _z_: maximize
 ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^  ^ ^  ^ ^ ^ ^ ^ ^                  _o_: remain only 
 _b_: choose buffer
]]
Hydra({
    name = "Windows",
    hint = window_hint,
    config = {
        invoke_on_body = true,
        hint = {
            border = "rounded",
            offset = -1,
        },
    },
    mode = "n",
    body = "<C-w>",
    heads = {
        { "h", "<C-w>h" },
        { "j", "<C-w>j" },
        { "k", cmd([[try | wincmd k | catch /^Vim\%((\a\+)\)\=:E11:/ | close | endtry]]) },
        { "l", "<C-w>l" },

        { "wh", cmd([[WinShift left]]) },
        { "wj", cmd([[WinShift down]]) },
        { "wk", cmd([[WinShift up]]) },
        { "wl", cmd([[WinShift right]]) },
        { "<cr>", cmd([[WinShift]]) },

        { "H", "<C-w>H", { exit = true, desc = "<c-w>H" } },
        { "J", "<C-w>J", { exit = true, desc = "<c-w>J" } },
        { "K", "<C-w>K", { exit = true, desc = "<c-w>K" } },
        { "L", "<C-w>L:", { exit = true, desc = "<c-w>L" } },

        {
            "<A-h>",
            function()
                splits.resize_left(2)
            end,
        },
        {
            "<A-j>",
            function()
                splits.resize_down(2)
            end,
        },
        {
            "<A-k>",
            function()
                splits.resize_up(2)
            end,
        },
        {
            "<A-l>",
            function()
                splits.resize_right(2)
            end,
        },
        { "=", "<C-w>=", { desc = "equalize" } },

        { "s", "<C-w>s" },
        { "<C-s>", "<C-w><C-s>", { desc = false } },
        { "v", "<C-w>v" },
        { "<C-v>", "<C-w><C-v>", { desc = false } },

        { "w", "<C-w>w", { exit = true, desc = false } },
        { "<C-w>", "<C-w>w", { exit = true, desc = false } },

        { "z", cmd("MaximizerToggle!"), { desc = "maximize" } },
        { "<C-z>", cmd("MaximizerToggle!"), { exit = true, desc = false } },

        { "o", "<C-w>o", { exit = true, desc = "remain only" } },
        { "<C-o>", "<C-w>o", { exit = true, desc = false } },

        { "b", choose_buffer, { exit = true, desc = "choose buffer" } },

        { "c", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]) },
        { "q", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]), { desc = "close window" } },
        { "<C-q>", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]), { desc = false } },
        { "<C-c>", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]), { desc = false } },

        { "<Esc>", nil, { exit = true, desc = false } },
    },
})
