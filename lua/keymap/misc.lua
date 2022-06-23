local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {

    ["n|<F2>"] = map_cu("UndotreeToggle","Undo Tree"):with_noremap():with_silent(),
    ["n|<Leader>om"] = map_cu("MarkdownPreview" , "MarkDown preview"):with_noremap():with_silent(),
    ["n|<leader>sw"] = map_cu("ISwapWith", "Swap parameters"):with_noremap():with_silent(),
    ["n|<C-W><C-M>"] = map_cmd("<cmd>WinShift<CR>", "Winshift Module"):with_noremap(),
    ["n|<C-W>m"] = map_cmd("<cmd>WinShift<CR>","Winshift Module"):with_noremap(),
    ["n|<C-W>X"] = map_cmd("<cmd>WinShift left<CR>"):with_noremap(),
    ["n|<C-M>H"] = map_cmd("<cmd>WinShift swap<CR>"):with_noremap(),
    ["n|<C-M>J"] = map_cmd("<cmd>WinShift down<CR>"):with_noremap(),
    ["n|<C-M>K"] = map_cmd("<cmd>WinShift up<CR>"):with_noremap(),
    ["n|<C-M>L"] = map_cmd("<cmd>WinShift right<CR>"):with_noremap(),

    ["n|<Leader>d"] = map_cr("lua require('neogen').generate()","Neogen"):with_noremap():with_silent(),
    ["n|<Leader>dc"] = map_cr("lua require('neogen').generate({type = 'class'})","Neogen Class"):with_noremap():with_silent(),
    ["n|<Leader>ds"] = map_cr("lua require('neogen').generate({type = 'type'})","Neogen Type"):with_noremap():with_silent(),

    ["n|<Leader>b["] = map_cr("BufferLineMoveNext", "Bufferline move next"):with_noremap():with_silent(),
    ["n|<Leader>b]"] = map_cr("BufferLineMovePrev", "Bufferline move prev"):with_noremap():with_silent(),
    ["n|<leader>bg"] = map_cr("BufferLinePick", "Pick Buffer"):with_noremap():with_silent(),
    ["n|<localleader>1"] = map_cr("BufferLineGoToBuffer 1 ", "buf goto 1"):with_silent(),
    ["n|<localleader>2"] = map_cr("BufferLineGoToBuffer 2" , "buf goto 2"):with_silent(),
    ["n|<localleader>3"] = map_cr("BufferLineGoToBuffer 3 ", "buf goto 3"):with_silent(),
    ["n|<localleader>4"] = map_cr("BufferLineGoToBuffer 4 ", "buf goto 4"):with_silent(),
    ["n|<localleader>5"] = map_cr("BufferLineGoToBuffer 5 ", "buf goto 5"):with_silent(),
    ["n|<localleader>6"] = map_cr("BufferLineGoToBuffer 6 ", "buf goto 6"):with_silent(),
    ["n|<localleader>7"] = map_cr("BufferLineGoToBuffer 7 ", "buf goto 7"):with_silent(),
    ["n|<localleader>8"] = map_cr("BufferLineGoToBuffer 8 ", "buf goto 8"):with_silent(),
    ["n|<localleader>9"] = map_cr("BufferLineGoToBuffer 9 ", "buf goto 9"):with_silent(),
    ["n|<localleader>q"] = map_cr("BufferLinePickClose"):with_silent(),

    ["n|<leader>bh"] = map_cr("BDelete hidden", "Delete all hidden Buffers"):with_silent():with_nowait():with_noremap(),
    ["n|<leader>bu"] = map_cr("BDelete! nameless","Delete nameless Buffers"):with_silent():with_nowait():with_noremap(),
    ["n|<leader>bd"] = map_cr("BDelete! this","Delete this buffer"):with_silent():with_nowait():with_noremap(),
}
return plug_map
