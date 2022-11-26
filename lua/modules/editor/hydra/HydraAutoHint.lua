local Hydra = require("hydra")

local config = {}

function config.set_leader(leader)
    config.leader = leader
end

function config.set_top_level_binds(dict)
    config.bracket = dict
end

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

function config.create_table_normal(var, sorted, string_len, start_val)
    start_val = start_val or nil
    var = {}
    for _, v in pairs(sorted) do
        if string.len(v) == string_len and not vim.tbl_contains(config.bracket, v) then
            if start_val ~= nil then
                if type(start_val) == "table" then
                    if vim.tbl_contains(start_val, v) then
                        table.insert(var, v)
                    end
                else
                    if starts(v, start_val) then
                        table.insert(var, v)
                    end
                end
            else
                table.insert(var, v)
            end
        end
    end
    table.sort(var, function(a, b)
        return a:lower() < b:lower()
    end)

    return var
end

return config
