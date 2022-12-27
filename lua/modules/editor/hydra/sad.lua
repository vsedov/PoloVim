local ts_move = require("nvim-treesitter.textobjects.move")
local leader = "L"
local hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

local mx = function(feedkeys, type)
    local type = type or "m"
    return function()
        if type == "v" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, true, true), "n", true)
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feedkeys, true, false, true), type, false)
    end
end

local bracket = { "s", "W", "w", "S", "E" }

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
    color = "pink",
    body = leader,
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },

    L = {
        function()
            require("substitute").operator()
        end,
        { nowait = true, desc = "Operator Sub", exit = true },
    },

    l = {
        function()
            require("substitute").line()
        end,
        { nowait = true, desc = "Operator line", exit = true },
    },
    ----------------------------------------------------------

    o = {
        function()
            require("substitute").eol()
        end,
        { nowait = true, desc = "Operator eol", exit = true },
    },
    ----------------------------------------------------------

    K = {
        function()
            require("substitute.range").operator({ motion1 = "iW" })
        end,
        { nowait = true, desc = "range Sub", exit = true },
    },

    k = {
        function()
            require("substitute.range").word()
        end,
        { nowait = true, desc = "range word", exit = true },
    },

    a = {
        function()
            require("substitute.range").operator({ motion1 = "iw", motion2 = "ap" })
        end,
        { nowait = true, desc = "range word", exit = true },
    },

    ----------------------------------------------------------
    Q = {
        function()
            require("substitute.exchange").operator()
        end,
        { nowait = true, desc = "Exchange Sub", exit = true },
    },

    q = {
        function()
            require("substitute.exchange").word()
        end,
        { nowait = true, desc = "Exchange Sub", exit = true },
    },

    C = {
        function()
            require("substitute.exchange").cancel()
        end,
        { desc = "Exchange Sub", nowait = true, exit = true },
    },

    ----------------------------------------------------------
    s = {
        function()
            require("ssr").open()
        end,

        { nowait = true, desc = "SSR Rep", exit = true },
    },
    S = {
        function()
            vim.cmd([[Sad]])
        end,

        { nowait = true, desc = "Sad SSR", exit = true },
    },

    -----------------------------------------------------------
    Xo = {
        function()
            require("spectre").open()
        end,

        { nowait = true, desc = "Spectre Open", exit = true },
    },
    Xv = {
        function()
            require("spectre").open_visual({ select_word = true })
        end,

        { nowait = true, desc = "Specre Word", exit = true },
    },
    Xc = {
        function()
            require("spectre").open_visual()
        end,

        { nowait = true, desc = "Spectre V", exit = true },
    },
    Xf = {
        function()
            require("spectre").open_file_search()
        end,
        { nowait = true, desc = "Spectre FS", exit = true },
    },

    -----------------------------
    w = {
        mx("<leader><leader>Sc"),
        { nowait = true, desc = "Rep All", exit = true },
    },

    E = {
        mx("<leader><leader>Sr"),
        { nowait = true, desc = "Rep Word", exit = false },
    },

    W = {
        mx("<leader><leader>Sl"),
        { nowait = true, desc = "Rep Word[C]", exit = true },
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
    name = "SAD",
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

    core = create_table_normal({}, sorted, 2, nil)
    sub = create_table_normal({}, sorted, 1, { "Q", "q", "C" })
    range = create_table_normal({}, sorted, 1, { "k", "K", "a" })
    eol = create_table_normal({}, sorted, 1, { "L", "l", "o" })

    core_table = {}

    make_core_table(core_table, bracket)
    make_core_table(core_table, range)
    make_core_table(core_table, eol)
    make_core_table(core_table, sub)

    make_core_table(core_table, core)

    hint_table = {}
    string_val = "^ ^      SAD      ^ ^\n\n"
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
    return string_val
end

val = auto_hint_generate()
new_hydra.hint = val
hydra(new_hydra)
