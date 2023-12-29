local Hydra = require("hydra")

local function cmd(command)
    return table.concat({ "<Cmd>", command, "<CR>" })
end

local function pick_window()
    local function filter(ids)
        return ids
    end

    local wid = require("window-picker").pick_window({
        include_current_win = true,
        filter_func = filter,
    })
    if type(wid) == "number" then
        vim.api.nvim_set_current_win(wid)
    end
end

local window_hint = [[
^^^^^^^^^^^^          Move            ^^    Size  ^^  ^^     Split
^^^^^^^^^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁ ^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^  ^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁

^ ^ _k_ ^ ^  ^  ^  _wk_  ^  ^  ^ ^ _K_ ^ ^  ^ ^   _<Up>_     ^   ^_s_: horizontally
_h_ ^ ^ _l_  _wh_ _<cr>_ _wl_  _H_ ^ ^ _L_  _<Left>_ _<Right>_  _v_: vertically
^ ^ _j_^ ^  ^  ^   _wj_  ^  ^  ^ ^ _J_ ^ ^  ^  ^ _<Down>_    ^   ^_q_, _c_: close
^^focus ^^  ^^winshift^  ^^Split^^^^^^^^^^   ^_=_: equalize^     _z_: maximize
^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^  ^ ^  ^ ^ ^ ^ ^ ^                    _o_: remain only
_?_ : Pick window  _m_: Template

]]
Hydra({
    name = "Windows",
    hint = window_hint,
    config = {
        invoke_on_body = true,
        hint = {
            offset = -1,
        },
    },
    mode = "n",
    body = "<C-w>;",
    heads = {
        {
            "h",
            function()
                require("smart-splits").move_cursor_left()
            end,
        },
        {
            "j",
            function()
                require("smart-splits").move_cursor_down()
            end,
        },
        {
            "k",
            function()
                require("smart-splits").move_cursor_up()
            end,
        },
        {
            "l",
            function()
                require("smart-splits").move_cursor_right()
            end,
        },

        { "wh", cmd([[WinShift left]]) },
        { "wj", cmd([[WinShift down]]) },
        { "wk", cmd([[WinShift up]]) },
        { "wl", cmd([[WinShift right]]) },
        { "<cr>", cmd([[WinShift]]) },

        { "H", "<C-w>H", { exit = true, desc = "<c-w>H" } },
        { "J", "<C-w>J", { exit = true, desc = "<c-w>J" } },
        { "K", "<C-w>K", { exit = true, desc = "<c-w>K" } },
        { "L", "<C-w>L", { exit = true, desc = "<c-w>L" } },
        { "?", pick_window, { exit = true } },
        {
            "<Left>",
            function()
                require("smart-splits").resize_left(2)
            end,
        },
        {
            "<Down>",
            function()
                require("smart-splits").resize_down(2)
            end,
        },
        {
            "<Up>",
            function()
                require("smart-splits").resize_up(2)
            end,
        },
        {
            "<Right>",
            function()
                require("smart-splits").resize_right(2)
            end,
        },
        {
            "m",
            function()
                vim.cmd([[Template main]])
            end,
            { desc = "Soft Toggle Cava" },
        },
        { "=", "<C-w>=", { desc = "equalize" } },

        { "s", "<C-w>s" },
        { "<C-s>", "<C-w><C-s>", { desc = false } },
        { "v", "<C-w>v" },
        { "<C-v>", "<C-w><C-v>", { desc = false } },

        { "w", "<C-w>w", { exit = true, desc = false } },

        { "z", cmd("MaximizerToggle!"), { desc = "maximize" } },
        { "<C-z>", cmd("MaximizerToggle!"), { exit = true, desc = false } },
        { "<C-o>", "<C-w>o", { exit = true, desc = false } },

        { "o", cmd("BufOnly"), { exit = true, desc = "remain only" } },
        { "<C-o>", "<C-w>o", { exit = true, desc = false } },
        { "c", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]) },
        { "q", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]), { desc = "close window" } },
        { "<C-q>", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]), { desc = false } },
        { "<C-c>", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]), { desc = false } },

        { "<Esc>", nil, { exit = true, desc = false } },
    },
})
