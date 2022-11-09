local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu

local plug_map = {

    ["n|<F2>"] = map_cu("UndotreeToggle", "Undo Tree"):with_noremap():with_silent(),
    ["n|<f8>"] = map_cu("MruRepos", "MruRepos"):with_noremap():with_silent(),
    ["n|<f9>"] = map_cu("Mru", "Mru"):with_noremap():with_silent(),
    ["n|<f0>"] = map_cu("Mfu", "Mfu"):with_noremap():with_silent(),

    ["n|<leader>tn"] = map_cu("tabedit", "tabedit"):with_noremap():with_silent(),
    ["n|<leader>tc"] = map_cu("tabclose", "tabclose"):with_noremap():with_silent(),
    ["n|<leader>to"] = map_cu("tabonly", "tabonly"):with_noremap():with_silent(),
    ["n|<leader>tm"] = map_cu("tabmove", "tabmove"):with_noremap():with_silent(),

    ["n|]t"] = map_cu("tabprev", "tabprev"):with_noremap():with_silent(),
    ["n|[t"] = map_cu("tabnext", "tabnext"):with_noremap():with_silent(),

    ["n|;s"] = map_cu("ReachOpen buffers", "ReachOpen buffers"):with_noremap():with_silent(),
    ["n|M"] = map_cu("ReachOpen marks", "ReachOpen marks"):with_noremap():with_silent(),
    ["n|;S"] = map_cu("ReachOpen tabpages", "ReachOpen tabpages"):with_noremap():with_silent(),
    ["n|;C"] = map_cu("ReachOpen colorschemes", "ReachOpen colorschemes"):with_noremap():with_silent(),
}
return plug_map
