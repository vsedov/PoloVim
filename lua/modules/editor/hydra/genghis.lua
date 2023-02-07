local leader = ";\\"
local bracket = { "c", "C", "<cr>" }
local hydra = require("hydra")

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

local config = {}
local exit = { nil, { exit = true, desc = "EXIT" } }

config.genghis = {
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

local new_hydra = require("modules.editor.hydra.utils").new_hydra(config, {
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
})

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.genghis) do
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
