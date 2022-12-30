local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local leader_key = "m"
local hydra = require("hydra")

local bracket = { "<cr>", "m", "n", "N", "c" }

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

local function create_table_normal(var, sorted, string_len, start_val)
    start_val = start_val or nil
    var = {}
    for _, v in pairs(sorted) do
        if string.len(v) == string_len and not vim.tbl_contains(bracket, v) then
            if start_val ~= nil then
                if type(start_val) == "table" then
                    if vim.tbl_contains(start_val, v) then
                        table.insert(var, v)
                    end
                else
                    if starts(v, start_val) then
                        table.insert(var, v)
                    end
                end
            else
                table.insert(var, v)
            end
        end
    end
    table.sort(var, function(a, b)
        return a:lower() < b:lower()
    end)

    return var
end

local config = {}

local exit = { nil, { exit = true, desc = "EXIT" } }
config.parenth_mode = {
    color = "red",
    body = leader_key,
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },

    m = {
        function()
            require("easymark").toggle_mark()
        end,
        { nowait = true, exit = false, desc = "Toggle Mark" },
    },
    c = {
        function()
            require("easymark").clear_mark()
        end,
        { nowait = true, exit = true, desc = "Clear Mark" },
    },
    n = {
        function()
            require("easymark").next_mark()
        end,
        { nowait = true, exit = false, desc = "Next Mark" },
    },
    N = {
        function()
            require("easymark").prev_mark()
        end,
        { nowait = true, exit = false, desc = "Prev Mark" },
    },
    ["<cr>"] = {
        function()
            require("easymark").toggle_pane()
        end,
        { nowait = true, exit = true, desc = "Toggle Plane" },
    },

    a = {
        function()
            require("lazymark").mark()
        end,
        { nowait = true, exit = true, desc = "Single[M] Add" },
    },
    g = {
        function()
            require("lazymark").gotoMark()
        end,
        { nowait = true, exit = true, desc = "Single[M] Goto" },
    },
    r = {
        function()
            require("lazymark").redoMark()
        end,
        { nowait = true, exit = true, desc = "Single[M] Redo" },
    },
    u = {
        function()
            require("lazymark").undoMark()
        end,
        { nowait = true, exit = true, desc = "Single[M] Undo" },
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
    name = "Marks",
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

    easymark = create_table_normal({}, sorted, 1, { "a", "g", "r", "u" })

    core_table = {}

    make_core_table(core_table, bracket)
    make_core_table(core_table, easymark)

    hint_table = {}
    string_val = "^ ^      Marks       ^ ^\n\n"
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
