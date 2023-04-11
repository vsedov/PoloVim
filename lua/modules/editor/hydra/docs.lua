local Hydra = require("hydra")
local utils = require("modules.editor.hydra.utils")
local make_core_table = utils.make_core_table

if table.unpack == nil then
    table.unpack = unpack
end

local config = {}

local bracket = { "d", "s", "c", "D" }
local exit = { nil, { exit = true, desc = "EXIT" } }

config.doc_binds = {
    color = "pink",
    body = "<leader>d",
    mode = { "n", "v", "x", "o" },
    ["<Esc>"] = { nil, { exit = true } },
    -- Neogen stuff
    d = {
        function()
            require("neogen").generate()
        end,
        { nowait = true, silent = true, desc = "Gen Doc", exit = true },
    },
    c = {
        function()
            require("neogen").generate({ type = "class" })
        end,
        { nowait = true, silent = true, desc = "Gen class", exit = true },
    },
    s = {
        function()
            require("neogen").generate({ type = "type" })
        end,
        { nowait = true, silent = true, desc = "Gen type", exit = false },
    },

    -- Reference Stuff
    i = {
        function()
            vim.cmd("RefCopy")
        end,
        { nowait = true, silent = true, desc = "refCopy", exit = true },
    },
    p = {

        function()
            vim.cmd("RefGo")
        end,
        { nowait = true, silent = true, desc = "RefGo", exit = true },
    },
    -- Documentation types ?
    D = {
        function()
            vim.cmd("DocsViewToggle")
        end,
        { nowait = true, silent = true, desc = "Live Docs", exit = true },
    },
}

local new_hydra = {
    hint = hints,
    name = "core",
    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        invoke_on_body = true,
        timeout = false,
    },
    heads = {},
}

require("modules.editor.hydra.utils").new_hydra(config, new_hydra)

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.doc_binds) do
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
    make_core_table(core_table, { "i", "p" })

    hint_table = {}
    string_val = "^ ^       Docs       ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
        else
            if container[v] then
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
            end
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
        -- end
    end
    return string_val
end

val = auto_hint_generate()
new_hydra.hint = val
Hydra(new_hydra)
