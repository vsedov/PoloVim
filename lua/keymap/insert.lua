local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

local plug_map = {
    ["i|jb"] = map_cmd("()<esc>i"):with_silent(),
    ["i|jn"] = map_cmd("[]<esc>i"):with_silent(),
    ["i|jm"] = map_cmd("{}<esc>i"):with_silent(),
    ["i|<C-;>"] = map_cmd([[<esc>:call search("[)\\]}>,`'\"]", 'eW')<CR>]]):with_silent(),
}

return plug_map
