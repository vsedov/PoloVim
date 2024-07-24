local M = require("modules.editor.hydra.utils_rewrite")
local hydra = require("hydra")

local function make_hydra(data)
    if data[8] then
        local length = #data[8]
        for i = 1, length do
            local internal_hydra_function = make_hydra(data[8][i])
            local binds = data[1][data[2]]
            for k, v in pairs(binds) do
                if v[2] and v[2].desc == tostring(data[8][i][2]) then
                    v[1] = function()
                        internal_hydra_function:activate()
                    end
                end
            end
        end
    end

    local instance = M.new(data[1], data[2])
    local hyd = instance.new_hydra

    data[5] = data[5] or 6
    data[6] = data[6] or 3
    data[7] = data[7] or 2

    local hint = instance:auto_hint_generate(data[3], data[4], data[5], data[6], data[7])

    hyd.hint = hint
    return hydra(hyd)
end

return {
    make_hydra = make_hydra,
}
