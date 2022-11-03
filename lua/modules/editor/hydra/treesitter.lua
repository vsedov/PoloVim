local Hydra = require("hydra")
local ts_move = require("nvim-treesitter.textobjects.move")

local Hydra = require("hydra")
local ts_move = require("nvim-treesitter.textobjects.move")
local ts_select = require("nvim-treesitter.textobjects.select")

local hydra = require("hydra")

local mx = function(feedkeys)
    return function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, true, true), "n", true)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feedkeys, true, false, true), "v", false)
    end
end

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

local config = {}

local exit = { nil, { exit = true, desc = "EXIT" } }
-- TODO: make a toggler for cursorhold events, so we can show peek
local function toggle(lhs, on_enter, on_exit)
    return {
        color = "pink",
        body = lhs,
        [lhs] = exit,
        on_exit = on_exit,
        on_enter = on_enter,
    }
end

config.parenth_mode = {
    color = "pink",
    body = "H",
    mode = { "n", "v", "x", "o" },
    ["H"] = { nil, { exit = true } },
    ["<ESC>"] = { nil, { exit = true } },
    j = {
        function()
            ts_move.goto_next_start({ "@function.outer", "@class.outer" })
        end,
        { nowait = true, desc = "Move [N] ←" },
    },
    h = {
        function()
            ts_move.goto_next_end({ "@function.outer", "@class.outer" })
        end,
        { nowait = true, desc = "Move [N] →" },
    },
    k = {
        function()
            ts_move.goto_previous_start({ "@function.outer", "@class.outer" })
        end,
        { nowait = true, desc = "Move [P] ←" },
    },
    l = {
        function()
            ts_move.goto_previous_start({ "@function.outer", "@class.outer" })
        end,
        { nowait = true, desc = "Move [P] →" },
    },
   ["{"] ={ mx("ac"), { nowait = true, desc = "Cls  [ac]" } }, -- ts: all class
   ["}"] ={ mx("ic"), { nowait = true, desc = "Cls  [ic]" } }, -- ts: inner class


   ["]"] ={ mx("af"), { nowait = true, desc = "Func [af]" } }, -- ts: all function
   ["["] ={ mx("if"), { nowait = true, desc = "Func [if]" } }, -- ts: inner function

   ["a"] ={ mx("aC"), { nowait = true, desc = "Cond [aC]" } }, -- ts: all conditional
   ["i"] ={ mx("iC"), { nowait = true, desc = "Cond [iC]" } }, -- ts: inner conditional
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
    name = "core",
    config = {
        hint = {
            position = "middle-right",
        },
        timeout = 4000,
        invoke_on_body = true,
        timeout = false,
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

    bracket = { "h", "j","k","l" }
    -- Single characters - non Capital to Capital then to double characters then brackets
    single = {}
    for _, v in pairs(sorted) do
        if string.len(v) == 1 and not vim.tbl_contains(bracket, v) then
            table.insert(single, v)
        end
    end
    table.sort(single)
    douible = {}
    for _, v in pairs(sorted) do
        if string.len(v) == 1 and not vim.tbl_contains(bracket, v) then
            table.insert(douible, v)
        end
    end
    table.sort(douible)

    core_table = {}

    -- make_core_table(core_table, single)
    make_core_table(core_table, bracket)

    make_core_table(core_table, douible)

    hint_table = {}
    string_val = "^ ^   Tree Sitter   ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

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
    -- print(string_val)
    return string_val
end

val = auto_hint_generate()
new_hydra.hint = val
hydra(new_hydra)
