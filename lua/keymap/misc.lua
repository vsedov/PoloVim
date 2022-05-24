local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {

    ["n|gpd"] = map_cu("GotoPrev"):with_noremap(),
    ["n|gpi"] = map_cu("GotoImp"):with_noremap(),
    ["n|gpt"] = map_cu("GotoTel"):with_noremap(),
    ["n|<Leader><F2>"] = map_cu("UndotreeToggle"):with_noremap():with_silent(),
    ["n|<Leader>om"] = map_cu("MarkdownPreview"):with_noremap():with_silent(),
    ["n|<leader>sw"] = map_cu("ISwapWith"):with_noremap():with_silent(),
    ["n|<C-W><C-M>"] = map_cmd("<cmd>WinShift<CR>"):with_noremap(),
    ["n|<C-W>m"] = map_cmd("<cmd>WinShift<CR>"):with_noremap(),
    ["n|<C-W>X"] = map_cmd("<cmd>WinShift left<CR>"):with_noremap(),
    ["n|<C-M>H"] = map_cmd("<cmd>WinShift swap<CR>"):with_noremap(),
    ["n|<C-M>J"] = map_cmd("<cmd>WinShift down<CR>"):with_noremap(),
    ["n|<C-M>K"] = map_cmd("<cmd>WinShift up<CR>"):with_noremap(),
    ["n|<C-M>L"] = map_cmd("<cmd>WinShift right<CR>"):with_noremap(),

    ["n|<Leader>vf"] = map_cmd("<Plug>(ultest-run-file)"):with_silent(),
    ["n|<Leader>vn"] = map_cmd("<Plug>(ultest-run-nearest)"):with_silent(),
    ["n|<Leader>vg"] = map_cmd("<Plug>(ultest-output-jump)"):with_silent(),
    ["n|<Leader>vo"] = map_cmd("<Plug>(ultest-output-show)"):with_silent(),
    ["n|<Leader>vs"] = map_cmd("<Plug>(ultest-summary-toggle)"):with_silent(),
    ["n|<Leader>va"] = map_cmd("<Plug>(ultest-attach)"):with_silent(),
    ["n|<Leader>vx"] = map_cmd("<Plug>(ultest-stop-file)"):with_silent(),

    ["n|<Leader>d"] = map_cr("lua require('neogen').generate()"):with_noremap():with_silent(),
    ["n|<Leader>dc"] = map_cr("lua require('neogen').generate({type = 'class'})"):with_noremap():with_silent(),
    ["n|<Leader>ds"] = map_cr("lua require('neogen').generate({type = 'type'})"):with_noremap():with_silent(),

    ["n|<Leader>b["] = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
    ["n|<Leader>b]"] = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),
    ["n|<leader>bg"] = map_cr("BufferLinePick"):with_noremap():with_silent(),
    ["n|<localleader>1"] = map_cr("BufferLineGoToBuffer 1 "):with_silent(),
    ["n|<localleader>2"] = map_cr("BufferLineGoToBuffer 2"):with_silent(),
    ["n|<localleader>3"] = map_cr("BufferLineGoToBuffer 3 "):with_silent(),
    ["n|<localleader>4"] = map_cr("BufferLineGoToBuffer 4 "):with_silent(),
    ["n|<localleader>5"] = map_cr("BufferLineGoToBuffer 5 "):with_silent(),
    ["n|<localleader>6"] = map_cr("BufferLineGoToBuffer 6 "):with_silent(),
    ["n|<localleader>7"] = map_cr("BufferLineGoToBuffer 7 "):with_silent(),
    ["n|<localleader>8"] = map_cr("BufferLineGoToBuffer 8 "):with_silent(),
    ["n|<localleader>9"] = map_cr("BufferLineGoToBuffer 9 "):with_silent(),
    ["n|<localleader>q"] = map_cr("BufferLinePickClose"):with_silent(),

    ["n|<leader>bh"] = map_cr("BDelete hidden"):with_silent():with_nowait():with_noremap(),
    ["n|<leader>bu"] = map_cr("BDelete! nameless"):with_silent():with_nowait():with_noremap(),
    ["n|<leader>bd"] = map_cr("BDelete! this"):with_silent():with_nowait():with_noremap(),
}
return plug_map
