local tc = require("nvim-treeclimber")

local leader = ";w"
local hydra = require("hydra")

local bracket = { "h", "j", "k", "l", "w" }
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
    ["<ESC>"] = { nil, { exit = true } },

    h = {
        function()
            tc.select_backward()
        end,

        { nowait = false, exit = true, desc = "TC Back" },
    },
    j = {
        function()
            tc.select_shrink()
        end,
        { nowait = true, desc = "TC Shrink" },
    },
    k = {
        function()
            tc.select_expand()
        end,
        { nowait = true, desc = "TC Expand" },
    },
    l = {
        function()
            tc.select_forward()
        end,
        { nowait = true, desc = "TC >" },
    },

    w = {
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
    W = {
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
    mode = { "n", "x", "o" },
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
    make_core_table(core_table, { "W", "c", "e" })
    make_core_table(core_table, { "s", "S", "[", "]" })

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

-- local binds = {
--   "indentation": {"ii", "ia", "aI", "iI"},
--   "value" : {"iv", "av"},
--   "key": {"ik", "ak"},
-- "number": {"in", "an"},
--   "diag": {"!"},
--   "NearEol": {"n"},
--   "Col" : {"!"},
--   "RestOfPara": {"r"},
--   "subword": {"is", "aS"}
-- }
