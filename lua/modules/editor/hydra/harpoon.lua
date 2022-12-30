local hydra = require("hydra")
local leader = "<CR>"
local bracket = { "<CR>", "w", "a", ";", "<leader>" }

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
                if vim.tbl_contains(start_val, v) then
                    -- if starts(v, start_val) then
                    table.insert(var, v)
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
    body = leader,
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },

    ["<CR>"] = {
        function()
            require("harpoon.ui").toggle_quick_menu()
        end,
        { nowait = true, exit = true, desc = "Quick Menu" },
    },
    w = {
        function()
            require("harpoon.mark").toggle_file()
        end,
        { nowait = true, exit = true, desc = "Toggle File" },
    },
    [";"] = {
        function()
            require("telescope").load_extension("harpoon")
            vim.cmd("Telescope harpoon marks")
        end,
        { nowait = true, exit = true, desc = "Harpoon Tele" },
    },

    a = {
        function()
            require("harpoon.mark").add_file()
        end,
        { nowait = true, exit = true, desc = "Add File" },
    },
    n = {
        function()
            require("harpoon.ui").nav_next()
        end,
        { nowait = true, exit = false, desc = "Next File" },
    },
    N = {
        function()
            require("harpoon.ui").nav_prev()
        end,
        { nowait = true, exit = false, desc = "Prev File" },
    },

    ["<leader>"] = {
        function()
            require("harpoon.cmd-ui").toggle_quick_menu()
        end,
        { nowait = true, exit = true, desc = "Quick ui Menu" },
    },

    ["1"] = {
        function()
            require("harpoon.ui").nav_file(1)
        end,
        { nowait = true, desc = "Jump File 1", exit = true },
    },
    ["2"] = {
        function()
            require("harpoon.ui").nav_file(2)
        end,
        { nowait = true, desc = "Jump File 2", exit = true },
    },
    ["3"] = {
        function()
            require("harpoon.ui").nav_file(3)
        end,
        { nowait = true, desc = "Jump File 3", exit = true },
    },
    ["4"] = {
        function()
            require("harpoon.ui").nav_file(4)
        end,
        { nowait = true, desc = "Jump File 4", exit = true },
    },
    ["5"] = {
        function()
            require("harpoon.ui").nav_file(5)
        end,
        { nowait = true, desc = "Jump File 5", exit = true },
    },

    ["6"] = {
        function()
            require("harpoon.ui").nav_file(6)
        end,
        { nowait = true, desc = "Jump File 6", exit = true },
    },

    ["7"] = {
        function()
            require("harpoon.ui").nav_file(7)
        end,
        { nowait = true, desc = "Jump File 7", exit = true },
    },

    ["8"] = {
        function()
            require("harpoon.ui").nav_file(8)
        end,
        { nowait = true, desc = "Jump File 8", exit = true },
    },

    ["9"] = {
        function()
            require("harpoon.ui").nav_file(9)
        end,
        { nowait = true, desc = "Jump File 9", exit = true },
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
    name = "Harpoon",
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

    num = create_table_normal({}, sorted, 1, { "1", "2", "3", "4", "5", "6", "7", "8", "9" })
    harpoon = create_table_normal({}, sorted, 1, { "n", "N" })
    portal = create_table_normal({}, sorted, 1, { "[", "]" })

    core_table = {}

    make_core_table(core_table, bracket)
    make_core_table(core_table, harpoon)
    make_core_table(core_table, num)

    hint_table = {}
    string_val = "^ ^         Harpoon         ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
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
