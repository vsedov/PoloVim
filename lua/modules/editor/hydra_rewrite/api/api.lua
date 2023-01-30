local Hydra = require("hydra")
local utils = require("modules.editor.hydra_rewrite.api.utils")

local opts = {}
local config = {}

function config.set_name_space(name_space)
    opts.name_space = name_space
end

function config.ignore_binds(data)
    opts.ignore = data
end

function config.set_config_table(data)
    config[opts.name_space] = data
    vim.tbl_extend("keep", config[opts.name_space], { nil, { exit = true, desc = "EXIT" } })
end

function config.define_mapping(new_hydra)
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

    config.new_hydra = new_hydra
end
function config.auto_hint_generate(bind_tables, ignore)
    container = {}
    opts.name_space = "default"
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
    for x, y in pairs(bind_tables) do
        data = utils.create_table_normal({}, sorted, y[1], y[2], ignore)
        utils.make_core_table(core_table, data)
    end
    return core_table
end

function config.generate_hint_table(bind_tables, ignore)
    hint_table = {}
    string_val = "^ ^      " .. opts.name_space .. "      ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
    core_table = config.auto_hint_generate(bind_tables, ignore)
    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
        else
            hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
        -- end
    end

    config.new_hydra.hint = string_val
    Hydra(config.new_hydra)
end

-- Meta tables for hydra

-- config.set_name_space("default")
-- config.set_config_table({
--     color = "pink",
--     mode = { "n", "v", "x", "o" },
--     L = {
--         function()
--             require("substitute").operator()
--         end,
--         { nowait = true, desc = "Operator Sub", exit = true },
--     },
--
--     l = {
--         function()
--             require("substitute").line()
--         end,
--         { nowait = true, desc = "Operator line", exit = true },
--     },
--
--     k = {
--         function()
--             require("substitute").line()
--         end,
--         { nowait = true, desc = "Operator line", exit = true },
--     },
--     K = {
--         function()
--             require("substitute").line()
--         end,
--         { nowait = true, desc = "Operator line", exit = true },
--     },
--     a = {
--         function()
--             require("substitute").line()
--         end,
--         { nowait = true, desc = "Operator line", exit = true },
--     },
-- })
-- auto_hint_generate({
--     { 1, { "L", "l", "k", "K" } },
--     { 2, { "a" } },
-- })
--
-- return config
