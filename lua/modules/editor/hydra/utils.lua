local M = {}

M.new_hydra = function(config, new_hydra)
    local mapping = {
        color = function(t, rhs)
            t.config.color = rhs
        end,
        body = function(t, rhs)
            t.body = rhs
        end,
        on_enter = function(t, rhs)
            t.config.on_enter = rhs
        end,
        on_exit = function(t, rhs)
            t.config.on_exit = rhs
        end,
        mode = function(t, rhs)
            t.config.mode = rhs
        end,
    }

    for name, spec in pairs(config) do
        for lhs, rhs in pairs(spec) do
            local action = mapping[lhs]
            if action == nil then
                new_hydra.heads[#new_hydra.heads + 1] = { lhs, table.unpack(rhs) }
            else
                action(new_hydra, rhs)
            end
        end
    end
    return new_hydra
end

M.make_core_table = function(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end
M.create_table_normal = function(var, sorted, string_len, start_val, bracket)
    start_val = start_val or nil
    var = {}
    for _, v in pairs(sorted) do
        if string.len(v) == string_len and not vim.tbl_contains(bracket, v) then
            if start_val ~= nil then
                if vim.tbl_contains(start_val, v) then
                    -- if starts(v, start_val) then
                    table.insert(var, v)
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

return M
