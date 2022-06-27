local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {

    ["n|<F2>"] = map_cu("UndotreeToggle", "Undo Tree"):with_noremap():with_silent(),
    ["n|<Leader>om"] = map_cu("MarkdownPreview", "MarkDown preview"):with_noremap():with_silent(),
    ["n|<leader>sw"] = map_cu("ISwapWith", "Swap parameters"):with_noremap():with_silent(),
    ["n|<Leader>d"] = map_cr("lua require('neogen').generate()", "Neogen"):with_noremap():with_silent(),
    ["n|<Leader>dc"] = map_cr("lua require('neogen').generate({type = 'class'})", "Neogen Class")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>ds"] = map_cr("lua require('neogen').generate({type = 'type'})", "Neogen Type")
        :with_noremap()
        :with_silent(),
}
return plug_map
