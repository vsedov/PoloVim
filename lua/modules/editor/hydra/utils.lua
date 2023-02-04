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

return M
