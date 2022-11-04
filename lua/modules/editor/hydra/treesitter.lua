local ts_move = require("nvim-treesitter.textobjects.move")
local leader = "\\<leader>"
local hydra = require("hydra")

local mx = function(feedkeys, type)
    local type = type or "m"
    return function()
        if type == "v" then
            print(feedkeys)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, true, true), "n", true)
        end
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feedkeys, true, false, true), type, false)
    end
end
local motion_type = {
    d = "Del",
    c = "Cut",
    y = "Yank",
}
local bracket = { "h", "j", "k", "l" }

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local function create_table_normal(var, sorted, string_len, start_val)
    start_val = start_val or nil
    var = {}
    for _, v in pairs(sorted) do
        if string.len(v) == string_len and not vim.tbl_contains(bracket, v) then
            if start_val ~= nil then
                if starts(v, start_val) then
                    table.insert(var, v)
                end
            else
                table.insert(var, v)
            end
        end
    end
    table.sort(var)
    return var
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
    body = leader,
    mode = { "n", "v", "x", "o" },
    [leader] = { nil, { exit = true } },
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
    ["c"] = { mx("ac", "v"), { nowait = true, desc = "Cls  [ac]" } }, -- ts: all class
    ["C"] = { mx("ic", "v"), { nowait = true, desc = "Cls  [ic]" } }, -- ts: inner class

    ["a"] = { mx("af", "v"), { nowait = true, desc = "Func [af]" } }, -- ts: all function
    ["i"] = { mx("if", "v"), { nowait = true, desc = "Func [if]" } }, -- ts: inner function

    ["A"] = { mx("aC", "v"), { nowait = true, desc = "Cond [aC]" } }, -- ts: all conditional
    ["I"] = { mx("iC", "v"), { nowait = true, desc = "Cond [iC]" } }, -- ts: inner conditional
}

for surround, motion in pairs({ c = "ac", C = "ic", a = "af", i = "if", A = "aC", I = "iC" }) do
    for doc, key in pairs({ d = "d", c = "c", y = "y" }) do
        local motiondoc = surround
        local mapping = table.concat({ doc, surround })
        config.parenth_mode[mapping] = {
            mx(table.concat({ key, motion })),
            { nowait = true, desc = motion_type[doc] .. " [" .. key .. motion .. "]", exit = true },
        }
    end
end

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

    single = create_table_normal({}, sorted, 1)

    delete = create_table_normal({}, sorted, 2, "d")
    change = create_table_normal({}, sorted, 2, "c")
    yank = create_table_normal({}, sorted, 2, "y")

    core_table = {}

    make_core_table(core_table, bracket)
    make_core_table(core_table, single)
    make_core_table(core_table, delete)
    make_core_table(core_table, change)
    make_core_table(core_table, yank)

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
