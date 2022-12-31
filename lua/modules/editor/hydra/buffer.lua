local Hydra = require("hydra")
local reach_options = {
    handle = "dynamic",
    show_current = true,
    sort = function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end,
}

local hint
local config

-- Keymaps for bufferline

local function buffer_move()
    vim.ui.input({ prompt = "Move buffer to:" }, function(idx)
        idx = idx and tonumber(idx)
        if idx then
            require("three").move_buffer(idx)
        end
    end)
end

vim.api.nvim_create_user_command("ProjectDelete", function()
    require("three").remove_project()
end, {})

hint = [[
  ^^^^                Bufferline                  ^^^^
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
   _l_: next                _h_: prev
   _p_: three pin           _c_: BufferLinePick
   _H_: Move Next           _L_: Move Prev
   _D_: Pick Close          _q_: Smart Close
   _m_: Three Move          _Q_: Close Buffer
   _ot_: Sort Tabs          _od_: Sort Dir
   _or_: Sort relative dir  _b_:  Buffer Jump
   _tl_: next               _th_: prev
   
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^               BufferJumper                 ^^^^
  ^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

        _1_: Jump 1    _2_: Jump 2    _3_: Jump 3
        _4_: Jump 4    _5_: Jump 5    _6_: Jump 6
        _7_: Jump 7    _8_: Jump 8    _9_: Jump 9
                     _0_: Jump 0
                     _#_: last buffer

  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                  Tabs                      ^^^^
  ^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

    _[_: tabn                        _]_: tabp
    _n_: $tabnew                     _C_: tabclose
    _>_: +tabmove                    _<_: -tabmove
                    _P_: tabonly

  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                   Delete                   ^^^^
  ^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

   _qh_: Del Hidden _qn_: Del NameLess _qt_: Del This

  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                   Reacher                  ^^^^
  ^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

    _S_: ReachOpen buffers   _s_: ReachOpen Tabs

   _d_: Bwipeout
]]
config = {
    hint = hint,
    name = "Buffer management",
    mode = "n",
    color = "teal",
    body = "<leader>b",
    config = {
        hint = { border = "single", position = "bottom-right" },
        invoke_on_body = true,
    },
    heads = {

        { "[", require("three").wrap(require("three").next_tab, { wrap = true }, { desc = "[G]oto next [T]ab" }) },
        { "]", require("three").wrap(require("three").prev_tab, { wrap = true }, { desc = "[G]oto prev [T]ab" }) },

        { "n", ":$tabnew<CR>", { desc = "Pin buffer" } },
        { "C", ":tabclose<CR>", { desc = "Pin buffer" } },
        { ">", ":+tabmove<CR>", { desc = "Move Next" } },
        { "<", ":-tabmove<CR>", { desc = "Move Prev" } },
        { "P", "<Cmd>tabonly<CR>", { desc = "Pick buffer to close", exit = true } },

        { "S", ":ReachOpen buffers<CR>", { desc = "Next buffer" } },
        { "s", ":ReachOpen tabpages<CR>", { desc = "Next buffer" } },

        { "c", "<Cmd>BufferLinePick<CR>", { desc = "Pin buffer" } },

        { "H", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move Next" } },
        { "L", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move Prev" } },
        { "D", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close", exit = true } },
        { "ot", "<Cmd>BufferLineSortByTabs<CR>", { desc = "Sort by tabs", exit = true } },
        { "od", "<Cmd>BufferLineSortByDirectory<CR>", { desc = "Sort by dir", exit = true } },
        {
            "or",
            "<Cmd>BufferLineSortByRelativeDirectory<CR>",
            { desc = "Sort by relative dir ", exit = true },
        },

        { "d", "<Cmd>Bwipeout<CR>", { desc = "delete buffer" } },
        { "<Esc>", nil, { exit = true, desc = "Quit" } },
        {
            "b",

            ":Telescope buffers<CR>",
            { exit = true },
        },

        { "qh", "<cmd>BDelete hidden<CR>" },
        { "qn", "<cmd>BDelete! nameless<CR>" },
        { "qt", "<cmd>BDelete! this<CR>" },

        { "tl", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" } },
        { "th", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" } },

        { "l", require("three").wrap(require("three").next, { wrap = true }, { desc = "[G]oto next [B]uffer" }) },
        { "h", require("three").wrap(require("three").prev, { wrap = true }, { desc = "[G]oto prev [B]uffer" }) },

        { "p", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" } },

        { "q", require("three").smart_close, { desc = "[C]lose window or buffer" } },
        { "Q", require("three").close_buffer, { desc = "[B]uffer [C]lose" } },

        { "H", require("three").hide_buffer, { desc = "[B]uffer [H]ide" } },

        { "m", buffer_move, { desc = "[B]uffer [M]ove" } },

        { "1", require("three").wrap(require("three").jump_to, 1), { desc = "Jump to buffer 1" } },
        { "2", require("three").wrap(require("three").jump_to, 2), { desc = "Jump to buffer 2" } },
        { "3", require("three").wrap(require("three").jump_to, 3), { desc = "Jump to buffer 3" } },
        { "4", require("three").wrap(require("three").jump_to, 4), { desc = "Jump to buffer 4" } },
        { "5", require("three").wrap(require("three").jump_to, 5), { desc = "Jump to buffer 5" } },
        { "6", require("three").wrap(require("three").jump_to, 6), { desc = "Jump to buffer 6" } },
        { "7", require("three").wrap(require("three").jump_to, 7), { desc = "Jump to buffer 7" } },
        { "8", require("three").wrap(require("three").jump_to, 8), { desc = "Jump to buffer 8" } },
        { "9", require("three").wrap(require("three").jump_to, 9), { desc = "Jump to buffer 9" } },
        { "0", require("three").wrap(require("three").jump_to, 10), { desc = "Jump to buffer 10" } },
        { "#", require("three").wrap(require("three").next, { delta = 100 }), { desc = "Jump to last buffer" } },
    },
}
Hydra(config)
