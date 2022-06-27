local Hydra = require("hydra")

local hint = [[
  ^^^^                Bufferline      			  ^^^^
  ^^^^--------------------------------------------^^^^  
   _g_: Bufferline Pick 				_q_: Buf del
  ^^^^--------------------------------------------^^^^  
  ^^^^                Delete  	      			  ^^^^
  ^^^^--------------------------------------------^^^^  
   _h_: Del Hidden _u_: Del NameLess _d_: Del This
]]

Hydra({
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom",
            border = "rounded",
        },
    },
    mode = "n",
    body = "<leader>b",
    heads = {
        { "g", "<cmd>BufferLinePick<CR>" },
        { "q", "<cmd>BufferLinePickClose <CR>" },

        { "1", "<cmd>BufferLineGoToBuffer 1<CR>" },
        { "2", "<cmd>BufferLineGoToBuffer 2<CR>" },
        { "3", "<cmd>BufferLineGoToBuffer 3<CR>" },
        { "4", "<cmd>BufferLineGoToBuffer 4<CR>" },
        { "5", "<cmd>BufferLineGoToBuffer 5<CR>" },
        { "6", "<cmd>BufferLineGoToBuffer 6<CR>" },
        { "7", "<cmd>BufferLineGoToBuffer 7<CR>" },
        { "8", "<cmd>BufferLineGoToBuffer 8<CR>" },
        { "9", "<cmd>BufferLineGoToBuffer 9<CR>" },

        { "h", "<cmd>BDelete hidden<CR>" },
        { "u", "<cmd>BDelete! nameless<CR>" },
        { "d", "<cmd>BDelete! this<CR>" },
    },
})
