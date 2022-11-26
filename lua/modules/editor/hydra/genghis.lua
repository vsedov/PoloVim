local leader = ";\\"
local hydra = require("hydra")

local bracket = { "c", "C", "<cr>" }
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

    c = {
        function()
            vim.cmd([[GenghiscopyFilepath]])
        end,

        { nowait = false, exit = true, desc = "CopyFilepath" },
    },
    C = {
        function()
            vim.cmd([[GenghiscopyFilename]])
        end,
        { nowait = true, exit = true, desc = "CopyFilename" },
    },
    ["<cr>"] = {
        function()
            vim.cmd([[Genghischmodx]])
        end,
        { nowait = true, exit = true, desc = "Chmodx" },
    },
    r = {
        function()
            vim.cmd([[GenghisrenameFile]])
        end,
        { nowait = true, exit = true, desc = "RenameFile" },
    },
    d = {
        function()
            vim.cmd([[GenghisduplicateFile]])
        end,
        { nowait = true, exit = true, desc = "Duplicate" },
    },

    n = {
        function()
            vim.cmd([[GenghiscreateNewFile]])
        end,
        { nowait = true, exit = true, desc = "CreateNewFile" },
    },
    T = {
        function()
            vim.cmd([[Genghistrash]])
        end,
        { nowait = true, exit = true, desc = "Trash" },
    },

    m = {
        function()
            vim.cmd([[Genghismove]])
        end,
        { nowait = true, exit = false, desc = "Move" },
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
    name = "Genghis",
    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        timeout = false,
        invoke_on_body = true,
    },
    mode = { "n" },
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
    make_core_table(core_table, { "r", "d", "n", "m", "T" })

    hint_table = {}
    string_val = "^ ^    Genghis      ^ ^\n\n"
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
