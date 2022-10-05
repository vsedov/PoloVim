local Hydra = require("hydra")

local buffer_config = function()
    local hint
    local config
    if lambda.config.tabby_or_bufferline then
        local three = require("three")
        -- Keymaps for bufferline

        local function buffer_move()
            vim.ui.input({ prompt = "Move buffer to:" }, function(idx)
                idx = idx and tonumber(idx)
                if idx then
                    three.move_buffer(idx)
                end
            end)
        end

        vim.api.nvim_create_user_command("ProjectDelete", function()
            three.remove_project()
        end, {})

hint = [[
  ^^^^                Bufferline                  ^^^^
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
   _l_: three next          _h_: three prev
   _p_: three pin           _c_: BufferLinePick
   _H_: Move Next           _L_: Move Prev
   _D_: Pick Close          _q_: Smart Close 
   _m_: Three Move          _Q_: Close Buffer
   _ot_: Sort Tabs          _od_: Sort Dir
   _or_: Sort relative dir  _b_: Tele Buffer

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

                { "[", three.wrap(three.next_tab, { wrap = true }, { desc = "[G]oto next [T]ab" }) },
                { "]", three.wrap(three.prev_tab, { wrap = true }, { desc = "[G]oto prev [T]ab" }) },

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
                { "b", "<cmd>Telescope buffers<CR>" },

                { "qh", "<cmd>BDelete hidden<CR>" },
                { "qn", "<cmd>BDelete! nameless<CR>" },
                { "qt", "<cmd>BDelete! this<CR>" },

                { "l", three.next, { desc = "Next buffer" } },
                { "h", three.prev, { desc = "Prev buffer" } },
                { "p", three.toggle_pin, { desc = "Pin buffer" } },
                { "q", three.smart_close, { desc = "[C]lose window or buffer" } },
                { "Q", three.close_buffer, { desc = "[B]uffer [C]lose" } },
                { "H", three.hide_buffer, { desc = "[B]uffer [H]ide" } },
                { "m", buffer_move, { desc = "[B]uffer [M]ove" } },

                { "1", three.wrap(three.jump_to, 1), { desc = "Jump to buffer 1" } },
                { "2", three.wrap(three.jump_to, 2), { desc = "Jump to buffer 2" } },
                { "3", three.wrap(three.jump_to, 3), { desc = "Jump to buffer 3" } },
                { "4", three.wrap(three.jump_to, 4), { desc = "Jump to buffer 4" } },
                { "5", three.wrap(three.jump_to, 5), { desc = "Jump to buffer 5" } },
                { "6", three.wrap(three.jump_to, 6), { desc = "Jump to buffer 6" } },
                { "7", three.wrap(three.jump_to, 7), { desc = "Jump to buffer 7" } },
                { "8", three.wrap(three.jump_to, 8), { desc = "Jump to buffer 8" } },
                { "9", three.wrap(three.jump_to, 9), { desc = "Jump to buffer 9" } },
                { "0", three.wrap(three.jump_to, 10), { desc = "Jump to buffer 10" } },
                { "#", three.wrap(three.next, { delta = 100 }), { desc = "Jump to last buffer" } },
            },
        }
    else
        hint = [[
^^^^                    Tabby                   ^^^^
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  _l_: tabn                       _h_: tabp
  _n_: $tabnew                    _c_: tabclose
^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

  _H_: +tabmove                   _L_: -tabmove
              _b_: Tele Buffer
              _p_: tabonly

^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
^^^^                   Delete                   ^^^^
^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

              _qh_: Del Hidden
              _qn_: Del NameLess
              _qt_: Del This
              _d_: Bwipeout

^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
^^^^                  Reacher                   ^^^^
^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

  _S_: ReachOpen buffers   _s_: ReachOpen Tabs

]]
        config = {
            hint = hint,
            name = "Tab management",
            mode = "n",
            color = "teal",
            body = "<leader>b",
            config = {
                hint = { border = "single", position = "bottom-right" },
            },
            heads = {
                { "S", ":ReachOpen buffers<CR>", { desc = "Next buffer" } },
                { "s", ":ReachOpen tabpages<CR>", { desc = "Next buffer" } },

                { "l", ":tabn<CR>", { desc = "Next buffer" } },
                { "h", ":tabp<CR>", { desc = "Prev buffer" } },

                { "n", ":$tabnew<CR>", { desc = "Pin buffer" } },
                { "c", ":tabclose<CR>", { desc = "Pin buffer" } },

                { "H", ":+tabmove<CR>", { desc = "Move Next" } },
                { "L", ":-tabmove<CR>", { desc = "Move Prev" } },

                { "p", "<Cmd>tabonly<CR>", { desc = "Pick buffer to close", exit = true } },

                { "d", "<Cmd>Bwipeout<CR>", { desc = "delete buffer" } },
                { "<Esc>", nil, { exit = true, desc = "Quit" } },
                { "b", "<cmd>Telescope buffers<CR>" },

                { "qh", "<cmd>BDelete hidden<CR>" },
                { "qn", "<cmd>BDelete! nameless<CR>" },
                { "qt", "<cmd>BDelete! this<CR>" },
            },
        }
    end
    Hydra(config)
end
return {
    buffer = buffer_config,
}
