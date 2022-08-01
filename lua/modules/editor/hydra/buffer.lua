local Hydra = require("hydra")

local buffer_config = function()
    local hint
    local config
    if lambda.config.tabby_or_bufferline then
        hint = [[
  ^^^^                Bufferline                  ^^^^
  ^^^^--------------------------------------------^^^^
   _l_: BufferLineCycleNext _h_: BufferLineCyclePrev
   _p_: BufferLineTogglePin _c_: BufferLinePick
   _H_: Move Next           _L_: Move Prev
   _ot_: Sort Tabs          _od_: Sort Dir
   _oD_: Sort relative dir  _D_: BufferLinePickClose
                    _b_: Tele Buffer

  ^^^^--------------------------------------------^^^^
  ^^^^                   Delete                   ^^^^
  ^^^^--------------------------------------------^^^^
   _qh_: Del Hidden _qn_: Del NameLess _qt_: Del This
  ^^^^--------------------------------------------^^^^
  ^^^^                   Reacher                  ^^^^
  ^^^^--------------------------------------------^^^^

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
                hint = { border = "single" },
                invoke_on_body = true,
            },
            heads = {
                { "S", ":ReachOpen buffers<CR>", { desc = "Next buffer" } },
                { "s", ":ReachOpen tabpages<CR>", { desc = "Next buffer" } },

                { "l", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" } },
                { "h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" } },
                { "p", "<Cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" } },
                { "c", "<Cmd>BufferLinePick<CR>", { desc = "Pin buffer" } },

                { "H", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move Next" } },
                { "L", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move Prev" } },
                { "D", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close", exit = true } },
                { "ot", "<Cmd>BufferLineSortByTabs<CR>", { desc = "Sort by tabs", exit = true } },
                { "od", "<Cmd>BufferLineSortByDirectory<CR>", { desc = "Sort by dir", exit = true } },
                {
                    "oD",
                    "<Cmd>BufferLineSortByRelativeDirectory<CR>",
                    { desc = "Sort by relative dir ", exit = true },
                },

                { "d", "<Cmd>Bwipeout<CR>", { desc = "delete buffer" } },
                { "<Esc>", nil, { exit = true, desc = "Quit" } },
                { "b", "<cmd>Telescope buffers<CR>" },

                { "qh", "<cmd>BDelete hidden<CR>" },
                { "qn", "<cmd>BDelete! nameless<CR>" },
                { "qt", "<cmd>BDelete! this<CR>" },
            },
        }
    else
        hint = [[
^^^^                    Tabby                   ^^^^
^^^^--------------------------------------------^^^^
  _l_: tabn                       _h_: tabp
  _n_: $tabnew                    _c_: tabclose
^^^^--------------------------------------------^^^^
  _H_: +tabmove                   _L_: -tabmove
              _b_: Tele Buffer
              _p_: tabonly
^^^^--------------------------------------------^^^^
^^^^                   Delete                   ^^^^
^^^^--------------------------------------------^^^^
              _qh_: Del Hidden 
              _qn_: Del NameLess 
              _qt_: Del This
              _d_: Bwipeout
^^^^--------------------------------------------^^^^
^^^^                  Reacher                   ^^^^
^^^^--------------------------------------------^^^^

  _S_: ReachOpen buffers   _s_: ReachOpen Tabs

]]
        config = {
            hint = hint,
            name = "Tab management",
            mode = "n",
            color = "teal",
            body = "<leader>b",
            config = {
                hint = { border = "single" },
                invoke_on_body = true,
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
