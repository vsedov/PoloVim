local tc = require("nvim-treeclimber")
local leader = "\\<cr>"
local hydra = require("hydra")

local bracket = { "H", "J", "K", "L", "w" }
local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

local config = {}

local exit = { nil, { exit = true, desc = "EXIT" } }

config.parenth_mode = {
    color = "pink",
    body = leader,
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },

    H = {
        function()
            tc.select_backward()
        end,
        { nowait = true, desc = "TC Back" },
    },
    J = {
        function()
            tc.select_shrink()
        end,
        { nowait = true, desc = "TC Shrink" },
    },
    K = {
        function()
            tc.select_expand()
        end,
        { nowait = true, desc = "TC Expand" },
    },
    L = {
        function()
            tc.select_forward()
        end,
        { nowait = true, desc = "TC >" },
    },

    f = {
        function()
            tc.show_control_flow()
        end,
        { nowait = true, desc = "TC Flow " },
    },
    c = {
        function()
            tc.select_current_node()
        end,
        { nowait = true, desc = "TC [C] Node" },
    },

    e = {
        function()
            tc.select_forward_end()
        end,
        { nowait = true, desc = "TC [E] > Node" },
    },

    --
    s = {
        function()
            tc.select_siblings_backward()
        end,
        { nowait = true, desc = "TC [S] < Node" },
    },
    S = {
        function()
            tc.select_siblings_forward()
        end,
        { nowait = true, desc = "TC [S] > Node" },
    },

    ["["] = {
        function()
            tc.select_grow_forward()
        end,
        { nowait = true, desc = "TC Grow >" },
    },
    ["]"] = {
        function()
            tc.select_grow_backward()
        end,
        { nowait = true, desc = "TC Grow <" },
    },
    w = {
        function()
            tc.select_top_level()
        end,
        { nowait = true, desc = "TC Top Level" },
    },
}

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
-- Create a Auto Hinting Table same as above but with auto generated

local new_hydra = {
    name = "TS",
    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        timeout = false,
        invoke_on_body = true,
    },
    heads = {},
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

--
local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.parenth_mode) do
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

    make_core_table(core_table, bracket)
    make_core_table(core_table, { "s", "S", "[", "]" })
    make_core_table(core_table, { "c", "f", "e" })

    hint_table = {}
    string_val = "^ ^  Tree Climber    ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
        else
            hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
        -- end
    end
    return string_val
end

val = auto_hint_generate()
new_hydra.hint = val
hydra(new_hydra)
