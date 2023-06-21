local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

local plug_map = {
    -- ["i|ll"] = map_cmd("()<esc>i", "()"):with_silent(),
    -- ["i|lj"] = map_cmd("[]<esc>i", "[]"):with_silent(),
    -- ["i|lm"] = map_cmd("{}<esc>i", "{}"):with_silent(),
    --
    ["i|<c-q>"] = map_cmd([[<esc>:call search("[)\\]}>,`'\"]", 'eW')<CR>]], "Jump Brackets"):with_silent(),
    ["i|<c-BS>"] = map_cmd("<esc>cvb", "Jump Brackets"):with_silent(),
    ["i|<c-s>"] = map_cmd("<esc><c-s>", "Leap god mode"):with_silent(),
}
return plug_map
