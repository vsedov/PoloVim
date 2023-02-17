local Hydra = require("hydra")
-- local cmd = require("hydra.keymap-util").cmd
if table.unpack == nil then
    table.unpack = unpack
end

local config = {}

local bracket = { "d", "s", "c" }
local exit = { nil, { exit = true, desc = "EXIT" } }

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

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
    z = {
        function()
            vim.cmd("Zeavim")
        end,
        { nowait = true, silent = true, desc = "Zeal", exit = true },
    },
    k = {
        function()
            vim.cmd("DD")
        end,
        { nowait = true, silent = true, desc = "DevDoc Search", exit = true },
    },

    l = {
        function()
            require("updoc").lookup()
        end,

        { nowait = true, silent = true, desc = "UpDoc Lookup", exit = true },
    },
    j = {
        function()
            vim.defer_fn(function()
                require("updoc").search()
            end, 100)
        end,
        { nowait = true, silent = true, desc = "UpDoc Search", exit = true },
    },

    o = {
        function()
            require("updoc").show_hover_links()
        end,

        { nowait = true, silent = true, desc = "UpDoc Links", exit = true },
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
    make_core_table(core_table, { "D", "z" })
    make_core_table(core_table, { "i", "p" })
    make_core_table(core_table, { "k", "l", "j", "o" })

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
