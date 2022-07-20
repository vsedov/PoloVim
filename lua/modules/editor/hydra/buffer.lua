local Hydra = require("hydra")

local hint = [[
  ^^^^                Bufferline                  ^^^^
  ^^^^--------------------------------------------^^^^  
   _l_: BufferLineCycleNext _h_: BufferLineCyclePrev
   _p_: BufferLineTogglePin _c_: BufferLinePick
   _H_: Move Next           _L_: Move Prev 
   _ot_: Sort Tabs          _od_: Sort Dir 
   _oD_: Sort relative dir  _D_: BufferLinePickClose
                     _b_: Tele Buffer

  ^^^^--------------------------------------------^^^^  
  ^^^^                Delete                      ^^^^
  ^^^^--------------------------------------------^^^^  
   _qh_: Del Hidden _qn_: Del NameLess _qt_: Del This

   _d_: Bwipeout    
]]

local buffer_hydra = Hydra({
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
        { "l", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" } },
        { "h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" } },
        { "p", "<Cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" } },
        { "c", "<Cmd>BufferLinePick<CR>", { desc = "Pin buffer" } },

        { "H", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move Next" } },
        { "L", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move Prev" } },
        { "D", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close", exit = true } },
        { "ot", "<Cmd>BufferLineSortByTabs<CR>", { desc = "Sort by tabs", exit = true } },
        { "od", "<Cmd>BufferLineSortByDirectory<CR>", { desc = "Sort by dir", exit = true } },
        { "oD", "<Cmd>BufferLineSortByRelativeDirectory<CR>", { desc = "Sort by relative dir ", exit = true } },

        { "d", "<Cmd>Bwipeout<CR>", { desc = "delete buffer" } },
        { "<Esc>", nil, { exit = true, desc = "Quit" } },
        { "b", "<cmd>Telescope buffers<CR>" },

        { "qh", "<cmd>BDelete hidden<CR>" },
        { "qn", "<cmd>BDelete! nameless<CR>" },
        { "qt", "<cmd>BDelete! this<CR>" },
    },
})
