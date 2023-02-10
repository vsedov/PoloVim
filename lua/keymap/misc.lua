local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu

local plug_map = {

    ["n|<F1>"] = map_cu("UndotreeToggle", "Undo Tree"):with_noremap():with_silent(),
    ["n|<leader>1"] = map_cu("MruRepos", "MruRepos"):with_noremap():with_silent(),
    ["n|<leader>2"] = map_cu("Mru", "Mru"):with_noremap():with_silent(),
    ["n|<leader>3"] = map_cu("Mfu", "Mfu"):with_noremap():with_silent(),

    ["n|<leader>tn"] = map_cu("tabedit", "tabedit"):with_noremap():with_silent(),
    ["n|<leader>tc"] = map_cu("tabclose", "tabclose"):with_noremap():with_silent(),
    ["n|<leader>to"] = map_cu("tabonly", "tabonly"):with_noremap():with_silent(),

    ["n|]t"] = map_cu("tabprev", "tabprev"):with_noremap():with_silent(),
    ["n|[t"] = map_cu("tabnext", "tabnext"):with_noremap():with_silent(),
}
return plug_map
