local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu

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

    ["n|<f8>"] = map_cu("MruRepos", "MruRepos"):with_noremap():with_silent(),
    ["n|<f9>"] = map_cu("Mru", "Mru"):with_noremap():with_silent(),
    ["n|<f0>"] = map_cu("Mfu", "Mfu"):with_noremap():with_silent(),

    ["n|<leader>tn"] = map_cu("tabedit", "tabedit"):with_noremap():with_silent(),
    ["n|<leader>tc"] = map_cu("tabclose", "tabclose"):with_noremap():with_silent(),
    ["n|<leader>to"] = map_cu("tabonly", "tabonly"):with_noremap():with_silent(),
    ["n|<leader>tm"] = map_cu("tabmove", "tabmove"):with_noremap():with_silent(),

    ["n|]t"] = map_cu("tabprev", "tabprev"):with_noremap():with_silent(),
    ["n|[t"] = map_cu("tabnext", "tabnext"):with_noremap():with_silent(),
}
return plug_map
