local utils = require("modules.editor.hydra.utils")
local hydra = require("hydra")
local config = {}

local lua_query = [[
        ;; query
        ((identifier) @cap)
        ("string_content" @cap)
        ((true) @cap)
        ((false) @cap)
    ]]
local python_query = [[
        ;; query
        ((identifier) @cap)
        ((string) @cap)
    ]]
local queries = {
    lua = lua_query,
    python = python_query,
}

local function select_node(direction, line_only)
    require("SelectEase").select_node({
        queries = queries,
        direction = direction,
        vertical_drill_jump = not line_only,
        current_line_only = line_only,
        fallback = function()
            require("SelectEase").select_node({ queries = queries, direction = direction })
        end,
    })
end

local function swap_nodes(direction, line_only)
    require("SelectEase").swap_nodes({
        queries = queries,
        direction = direction,
        vertical_drill_jump = not line_only,
        current_line_only = line_only,
    })
end

local bracket = { "h", "j", "k", "l" }

config.searcher = {
    color = "red",
    body = ";s",
    ["<Esc>"] = { nil, { exit = true, desc = "EXIT" } },

    k = {
        function()
            select_node("previous", false)
        end,
        { nowait = true, exit = false, desc = "Select[N]PrevGlob" },
    },

    j = {
        function()
            select_node("next", false)
        end,
        { nowait = true, exit = false, desc = "Select[N]NextGlob" },
    },

    h = {
        function()
            select_node("previous", true)
        end,
        { nowait = true, exit = false, desc = "Select[N]PrevLine" },
    },

    l = {
        function()
            select_node("next", true)
        end,
        { nowait = true, exit = false, desc = "Select[N]NextLine" },
    },

    J = {
        function()
            swap_nodes("previous", false)
        end,
        { nowait = true, exit = false, desc = "Swap[N]NextLine" },
    },

    K = {
        function()
            swap_nodes("next", false)
        end,
        { nowait = true, exit = false, desc = "Swap[N]NextLine" },
    },

    H = {
        function()
            swap_nodes("previous", true)
        end,
        { nowait = true, exit = false, desc = "Swap[N]NextLine" },
    },
    L = {
        function()
            swap_nodes("next", true)
        end,
        { nowait = true, exit = false, desc = "Swap[N]NextLine" },
    },
}
local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.searcher) do
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

    utils.make_core_table(core_table, bracket)
    utils.make_core_table(core_table, { "H", "J", "K", "L" })
    hint_table = {}
    string_val = "^ ^     Searcher    ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
        else
            if container[v] then
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
            end
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
    end
    return string_val
end

vim.defer_fn(function()
    local new_hydra = require("modules.editor.hydra.utils").new_hydra(config, {
        name = "SelectEase",
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {},
        mode = { "n", "v", "x", "o" },
    })

    val = auto_hint_generate()
    new_hydra.hint = val
    hydra(new_hydra)
end, 100)
