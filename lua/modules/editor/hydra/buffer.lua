local Hydra = require("hydra")

local hint = [[
  ^^^^                Bufferline                  ^^^^
  ^^^^--------------------------------------------^^^^  
   _l_: BufferLineCycleNext _h_: BufferLineCyclePrev
   _p_: BufferLineTogglePin _c_: BufferLinePick
  ^^^^--------------------------------------------^^^^  
  ^^^^                Delete                      ^^^^
  ^^^^--------------------------------------------^^^^  
   _qh_: Del Hidden _qn_: Del NameLess _qt_: Del This

   _d_: Bwipeout   _D_: BufferLinePickClose 
]]

Hydra({
    hint = hint,
    name = "Buffer management",
    mode = "n",
    body = "<leader>b",
    color = "teal",
    config = {
        hint = { border = "single" },
        invoke_on_body = true,
    },
    heads = {
        { "l", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" } },
        { "h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" } },
        { "p", "<Cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" } },
        { "c", "<Cmd>BufferLinePick<CR>", { desc = "Pin buffer" } },
        { "d", "<Cmd>Bwipeout<CR>", { desc = "delete buffer" } },
        { "D", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close", exit = true } },
        { "<Esc>", nil, { exit = true, desc = "Quit" } },

        { "qh", "<cmd>BDelete hidden<CR>" },
        { "qn", "<cmd>BDelete! nameless<CR>" },
        { "qt", "<cmd>BDelete! this<CR>" },
    },
})
