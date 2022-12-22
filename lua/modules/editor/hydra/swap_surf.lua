local ts_move = require("nvim-treesitter.textobjects.move")
local leader = ";s"
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

local bracket = { "s", "S", "k", "j" }

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
    ["<ESC>"] = { nil, { exit = true } },

    k = {
        function()
            require("nvim-treesitter.textobjects.swap").swap_next("@parameter.inner")
        end,

        { nowait = true, desc = "TS Swap →", exit = true },
    },
    j = {
        function()
            require("nvim-treesitter.textobjects.swap").swap_previous("@parameter.inner")
        end,
        { nowait = true, desc = "TS Swap ←", exit = true },
    },
    s = {
        function()
            vim.cmd([[ISwap]])
        end,

        { nowait = true, desc = "Iswap", exit = true },
    },
    S = {
        function()
            vim.cmd([[ISwapWith]])
        end,

        { nowait = true, desc = "IswapWith", exit = false },
    },

    U = { mx("cU"), { nowait = true, desc = "Surf U", exit = true } }, -- ts: all class
    u = { mx("cu"), { nowait = true, desc = "Surf u", exit = true } }, -- ts: inner class
    D = { mx("cD"), { nowait = true, desc = "Surf D", exit = true } }, -- ts: all function
    d = { mx("cd"), { nowait = true, desc = "Surf d", exit = true } }, -- ts: all conditional

    w = {
        function()
            vim.cmd([[STSJumpToTop]])
        end,
        { nowait = true, desc = "Surf Jump Top", exit = false },
    },
    N = {
        function()
            vim.cmd([[STSSelectMasterNode]])
        end,

        { nowait = true, desc = "Surf Master Node", exit = false },
    },
    n = {
        function()
            vim.cmd([[STSSelectCurrentNode]])
        end,

        { nowait = true, desc = "Surf Curent Node", exit = false },
    },

    J = {
        function()
            vim.cmd([[STSSelectNextSiblingNode]])
        end,

        { nowait = true, desc = "Surf [N] Sibling", exit = false },
    },
    K = {
        function()
            vim.cmd([[STSSelectPrevSiblingNode]])
        end,

        { nowait = true, desc = "Surf [P] Sibling", exit = false },
    },
    H = {
        function()
            vim.cmd([[STSSelectParentNode]])
        end,

        { nowait = true, desc = "Surf Parent", exit = false },
    },
    L = {
        function()
            vim.cmd([[STSSelectChildNode]])
        end,

        { nowait = true, desc = "Surf Child", exit = false },
    },
    v = {
        function()
            vim.cmd([[STSSwapNextVisual]])
        end,

        { nowait = true, desc = "Surf [N] Swap", exit = false },
    },
    V = {
        function()
            vim.cmd([[STSSwapPrevVisual]])
        end,

        { nowait = true, desc = "Surf [P] Swap", exit = false },
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
    name = "Swap/Surf",
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

    surf = create_table_normal({}, sorted, 1, { "d", "D", "U", "u" })

    core_table = {}

    make_core_table(core_table, bracket)
    make_core_table(core_table, surf)
    make_core_table(core_table, { "N", "n", "v", "V" })
    make_core_table(core_table, { "w", "H", "J", "K", "L" })

    hint_table = {}
    string_val = "^ ^      SwapSurf       ^ ^\n\n"
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
