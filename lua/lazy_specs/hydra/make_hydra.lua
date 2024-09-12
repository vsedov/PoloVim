local M = require("lazy_specs.hydra.utils_rewrite")
local hydra = require("hydra")

local function debug_print(...)
    print(string.format(...))
end

M.process_nested_hydras = function(data, parent_config)
    if not data[8] then
        return
    end

    for i, nested_data in ipairs(data[8]) do
        debug_print("Processing nested hydra %d: %s", i, nested_data[2])

        local internal_hydra_function = M.make_hydra(nested_data)
        local binds = parent_config[data[2]]

        for k, v in pairs(binds) do
            if v[2] and v[2].desc == tostring(nested_data[2]) then
                v[1] = function()
                    internal_hydra_function:activate()
                end
            end
        end
    end
end

M.create_hydra_instance = function(config, name, hint_parts, brackets, padding, cal_v2, columns)
    local instance = M.new(config, name)
    local hyd = instance.new_hydra

    padding = padding or 6
    cal_v2 = cal_v2 or 3
    columns = columns or 2

    local hint = instance:auto_hint_generate(hint_parts, brackets, padding, cal_v2, columns)
    hyd.hint = hint

    return hydra(hyd)
end

M.make_hydra = function(data)
    debug_print("Starting make_hydra for: %s", data[2] or "unnamed hydra")

    if type(data) ~= "table" then
        error("Data must be a table")
    end

    local config, name = data[1], data[2]
    if type(config) ~= "table" or type(name) ~= "string" then
        error("Invalid config or name")
    end

    M.process_nested_hydras(data, config)

    return M.create_hydra_instance(data[1], data[2], data[3], data[4], data[5], data[6], data[7])
end

return M
