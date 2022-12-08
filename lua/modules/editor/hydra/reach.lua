-- https://github.com/Reisen/vimless/blob/master/lua/plugins/hydra.lua
local cmd = vim.cmd
local Hydra = require("hydra")

local reach_options = {
    handle = "dynamic",
    show_current = true,
    sort = function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end,
}

-- Function to swap to the last buffer for this window.
local function swap_to_last_buffer()
    local last_buffer = vim.fn.bufnr("#")
    if last_buffer ~= -1 then
        vim.cmd("buffer " .. last_buffer)
    end
end

local leader = ";;"
local hydra = require("hydra")

local bracket = { "b", "l", "m", "t", "c" }

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

local config = {}

local exit = { nil, { exit = true, desc = "EXIT" } }
config.parenth_mode = {
    color = "red",
    body = leader,
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },

    b = {
        function()
            require("reach").buffers(reach_options)
        end,
        { nowait = true, exit = true, desc = "Reach Buffers" },
    },
    m = {
        function()
            cmd("ReachOpen marks")
        end,
        { nowait = true, exit = true, desc = "Reach Marks" },
    },
    t = {
        function()
            cmd("ReachOpen tabpages")
        end,
        { nowait = true, exit = true, desc = "Reach TabPage" },
    },
    c = {
        function()
            cmd("ReachOpen colorschemes")
        end,
        { nowait = true, exit = true, desc = "Reach Colour" },
    },
    l = {
        function()
            swap_to_last_buffer()
        end,
        { nowait = true, exit = true, desc = "Swap Last Buffer" },
    },

    L = {
        function()
            cmd("WorkspacesList")
        end,
        { nowait = true, exit = true, desc = "Workspace List" },
    },
    w = {
        function()
            cmd("WorkspacesOpen")
        end,
        { nowait = true, exit = true, desc = "Workspace Open" },
    },
    a = {
        function()
            cmd("WorkspacesAdd")
        end,
        { nowait = true, exit = true, desc = "Workspace Add" },
    },
    d = {
        function()
            cmd("WorkspacesRemove")
        end,
        { nowait = true, exit = true, desc = "Workspace Remove" },
    },
    r = {
        function()
            cmd("WorkspacesRename")
        end,
        { nowait = true, exit = true, desc = "Workspace Rename" },
    },
    n = {
        function()
            cmd("CybuNext")
        end,
        { nowait = true, exit = false, desc = "CybuNext" },
    },
    N = {
        function()
            cmd("CybuPrev")
        end,
        { nowait = true, exit = false, desc = "CybuPrev" },
    },
    ["]"] = {
        function()
            cmd("CybuLastusedPrev")
        end,
        { nowait = true, exit = false, desc = "CybuLastusedPrev" },
    },
    ["["] = {
        function()
            cmd("CybuLastusedNext")
        end,
        { nowait = true, exit = false, desc = "CybuLastusedNext" },
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
local new_hydra = {
    name = "Reach",
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

    core_table = {}

    make_core_table(core_table, bracket)
    make_core_table(core_table, { "w", "a", "d", "r", "L" })
    make_core_table(core_table, { "n", "N", "[", "]" })

    hint_table = {}
    string_val = "^ ^      Reach     ^ ^\n\n"
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
