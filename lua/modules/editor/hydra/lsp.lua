local leader = ";l"
local hydra = require("hydra")

local bracket = { "J", "K" }

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
    J = {
        function()
            vim.diagnostic.goto_prev()
        end,
        { exit = false, nowait = true, desc = "Diag [G] Prev" },
    },

    K = {
        function()
            vim.diagnostic.goto_next()
        end,
        { nowait = true, exit = false, desc = "Diag [G] Next" },
    },
    d = {
        function()
            vim.cmd([[Glance definitions]])
        end,
        { nowait = true, exit = true, desc = "Glance Def" },
    },
    r = {
        function()
            vim.cmd([[Glance references]])
        end,
        { nowait = true, exit = true, desc = "Glance Ref" },
    },
    D = {
        function()
            vim.cmd([[Glance type_definitions]])
        end,
        { nowait = true, exit = true, desc = "Glance TDef" },
    },

    i = {
        function()
            vim.cmd([[Glance implementations]])
        end,
        { nowait = true, exit = true, desc = "Glance Imp" },
    },
    t = {
        function()
            vim.cmd([[TroubleToggle]])
        end,
        { nowait = true, exit = true, desc = "TroubleToggle" },
    },

    s = {
        function()
            require("goto-preview").goto_preview_definition()
        end,
        { nowait = true, exit = true, desc = "[G] Def" },
    },
    S = {
        function()
            require("goto-preview").goto_preview_references()
        end,
        { nowait = true, exit = true, desc = "[G] Ref" },
    },
    I = {
        function()
            require("goto-preview").goto_preview_implementation()
        end,
        { nowait = true, exit = true, desc = "[G] Imp" },
    },
    c = {
        function()
            require("goto-preview").close_all_win()
        end,
        { nowait = true, exit = true, desc = "[G] Close" },
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
    name = "Test",
    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        timeout = false,
        invoke_on_body = true,
    },
    mode = { "n", "v", "x", "o" },

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
    make_core_table(core_table, { "d", "D", "r", "i", "t" })
    make_core_table(core_table, { "s", "S", "I", "c" })

    hint_table = {}
    string_val = "^ ^     LSP    ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
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
