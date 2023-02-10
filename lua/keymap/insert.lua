local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

local plug_map = {
    ["i|jj"] = map_cmd("()<esc>i", "()"):with_silent(),
    ["i|jn"] = map_cmd("[]<esc>i", "[]"):with_silent(),
    ["i|jm"] = map_cmd("{}<esc>i", "{}"):with_silent(),
    ["i|<c-q>"] = map_cmd([[<esc>:call search("[)\\]}>,`'\"]", 'eW')<CR>]], "Jump Brackets"):with_silent(),
}
return plug_map
