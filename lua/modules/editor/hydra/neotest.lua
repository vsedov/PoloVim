local leader = "<leader>u"
local hydra = require("hydra")

local bracket = { "<cr>", "s", "o" }

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

local function test_method()
    if vim.bo.filetype == "python" then
        require("dap-python").test_method()
    end
end
local function test_class()
    if vim.bo.filetype == "python" then
        require("dap-python").test_class()
    end
end
local function debug_selection()
    if vim.bo.filetype == "python" then
        require("dap-python").debug_selection()
    end
end

local config = {}

local exit = { nil, { exit = true, desc = "EXIT" } }

config.parenth_mode = {
    color = "pink",
    body = leader,
    ["<ESC>"] = { nil, { exit = true } },
    ["<cr>"] = {
        function()
            vim.cmd([[TestCurrent]])
        end,
        { nowait = true, exit = false, desc = "Test Current" },
    },

    s = {
        function()
            vim.cmd([[TestSummary]])
        end,
        { nowait = false, exit = false, desc = "Test Sum" },
    },
    o = {
        function()
            vim.cmd([[TestOutput]])
        end,
        { nowait = false, exit = false, desc = "Test Output" },
    },
    d = {
        function()
            vim.cmd([[TestStrat dap]])
        end,
        { nowait = false, exit = false, desc = "Test dap" },
    },
    D = {
        function()
            vim.cmd([[TestStrat integrated]])
        end,
        { nowait = false, exit = false, desc = "Test integrated" },
    },

    S = {
        function()
            vim.cmd([[TestStop]])
        end,
        { nowait = false, exit = false, desc = "Test Stop" },
    },
    a = {
        function()
            vim.cmd([[TestAttach]])
        end,
        { nowait = false, exit = false, desc = "Test Attach" },
    },
    n = {
        function()
            vim.cmd([[TestNearest]])
        end,
        { nowait = false, exit = true, desc = "TestNearest" },
    },
    f = {
        function()
            vim.cmd([[TestFile]])
        end,
        { nowait = false, exit = true, desc = "TestFile" },
    },
    l = {
        function()
            vim.cmd([[TestLast]])
        end,
        { nowait = false, exit = true, desc = "TestLast" },
    },
    v = {
        function()
            vim.cmd([[TestVisit]])
        end,
        { nowait = false, exit = true, desc = "TestVisit" },
    },

    w = {
        function()
            test_method()
        end,
        { nowait = false, exit = true, desc = "TestMethod" },
    },

    W = {
        function()
            test_class()
        end,
        { nowait = false, exit = true, desc = "TestClass" },
    },
    [";"] = {
        function()
            debug_selection()
        end,
        { nowait = false, exit = true, desc = "Selection" },
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
    make_core_table(core_table, { "d", "D", "S", "a" })
    make_core_table(core_table, { "n", "f", "l", "v" })
    make_core_table(core_table, { "w", "W", ";" })
    hint_table = {}
    string_val = "^ ^     Neo Test   ^ ^\n\n"
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
