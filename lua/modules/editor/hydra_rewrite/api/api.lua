local Hydra = require("hydra")
local utils = require("modules.editor.hydra_rewrite.api.utils")
local M = {}

local opts = {}
local config = {}

function M.set_name_space(name_space)
    opts.name_space = name_space
end

function M.ignore_binds(data)
    opts.ignore = data
end

function M.set_config_table(data)
    config[opts.name_space] = data
end

--  TODO: (vsedov) (07:31:02 - 30/01/23): There is something wrong, here im not sure why this does
--  not work .
function M.define_mapping(new_hydra)
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
            -- P(mapping[lhs])
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
function M.auto_hint_generate(bind_tables, ignore)
    container = {}
    for x, y in pairs(config[opts.name_space]) do
        local mapping = x
        if type(y[1]) == "function" then
            for x, y in pairs(y[2]) do
                if x == "desc" then
                    container[mapping] = y
                end
            end
        end
    end
    sorted = {}
    for k, v in pairs(container) do
        table.insert(sorted, k)
    end
    table.sort(sorted)
    core_table = {}

    utils.make_core_table(core_table, opts.ignore)

    for x, y in pairs(bind_tables) do
        data = utils.create_table_normal({}, sorted, y[1], y[2], ignore)
        utils.make_core_table(core_table, data)
    end
    return core_table, container
end

function M.getn_hydra(bind_tables, new_hydra)
    hint_table = {}
    string_val = "^ ^      " .. opts.name_space .. "      ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
    core_table, container = M.auto_hint_generate(bind_tables, opts.ignore)

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
        else
            hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
    end

    new_hydra.hint = string_val
    vim.tbl_deep_extend("force", new_hydra, config)
    Hydra(new_hydra)
end

return M
