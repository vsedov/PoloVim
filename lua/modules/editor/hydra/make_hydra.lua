local M = require("modules.editor.hydra.utils_rewrite")
local hydra = require("hydra")

local function make_hydra(data)
    local instance = M.new(data[1], data[2])
    local hyd = instance.new_hydra
    data[5] = data[5] or 6
    data[6] = data[6] or 3
    data[7] = data[7] or 2
    local hint = instance:auto_hint_generate(data[3], data[4], data[5], data[6], data[7])
    hyd.hint = hint
    hydra(hyd)
end

return {
    make_hydra = make_hydra,
}
