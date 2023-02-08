local Hydra = require("hydra")
local utils = require("modules.editor.hydra.utils")
local fn = vim.fn
local leader_key = ";<leader>"

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")

local function tmux_split(tmux, percentage)
    command = "tmux split-window -" .. tmux .. " -p " .. percentage
    fn.jobstart(command)
end
-- tmux_move_session("n")
-- tmux_move_session("p")
local function tmux_move_session(left_right)
    local command = "tmux select-window -" .. left_right
    fn.jobstart(command)
end

function switch_window(buf)
    local selected = actions_state.get_selected_entry()
    local cmd = "!tmux select-window " .. selected[1]
    vim.cmd(cmd)
    actions.close(buf)
end

local function tmux_fibonacci_split_auto(fib_amount, width)
    fib_amount = fib_amount or 3
    width = width or 100

    local function fib(n)
        if n == 0 then
            return 0
        end
        if n == 1 then
            return 1
        end
        return fib(n - 1) + fib(n - 2)
    end

    local fib_sequence = {}
    for i = 1, fib_amount do
        table.insert(fib_sequence, fib(i))
    end

    local sum = 0
    for i, v in ipairs(fib_sequence) do
        sum = sum + v
    end

    local function split(direction, percentage)
        tmux_split(direction, math.floor(width * (percentage / sum)))
    end

    local split_direction = "h"
    for i, v in ipairs(fib_sequence) do
        split(split_direction, v)
        split_direction = split_direction == "h" and "v" or "h"
    end
end

function tmux_session()
    local input = { "tmux", "list-windows" }
    local opts = {
        finder = finders.new_oneshot_job(input),
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(switch_window, map)
            map("i", "<CR>", enter)

            return true
        end,
    }
    local picker = pickers.new(opts)

    picker:find()
end

local bracket = { "s", "S" }
silent_binds = {

    L = { "tmux splitw -h", "[T]-> Right [Hor]" },
    H = { "tmux splitw -bh", "[T]-> Left [Hori]" },
    U = { "tmux splitw -b", "[T]-> Up [Vert]" },
    D = { "tmux splitw", "[T]-> Down [Vert]" },

    l = { "tmux splitw -dh", "[T]-> Right [Det+Hor]" },
    h = { "tmux splitw -bdh", "[T]-> Left [Det+Hor]" },
    d = { "tmux splitw -d", "[T]-> Down [Det+Vert]" },
    u = { "tmux splitw -bd", "[T]-> Up [Det+Vert]" },
    k = { "tmux last-pane \\; kill-pane", "Tmux kill last pane" },
}

local exit = { nil, { exit = true, desc = "EXIT" } }
local config = {}
config.parenth_mode = {
    color = "red",
    body = leader_key,
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },
    s = {
        function()
            vim.ui.input({ prompt = "Enter Percentage", default = "40" }, function(percent)
                tmux_split("h", tonumber(percent))
            end)
        end,
        { nowait = true, exit = true, desc = "Open Vertical" },
    },
    S = {
        function()
            vim.ui.input({ prompt = "Enter Percentage", default = "40" }, function(percent)
                tmux_split("v", tonumber(percent))
            end)
        end,
        { nowait = true, exit = true, desc = "Open Horizontal" },
    },

    n = {
        function()
            tmux_move_session("n")
        end,
        { nowait = true, exit = true, desc = "Next Window" },
    },
    N = {
        function()
            tmux_move_session("p")
        end,
        { nowait = true, exit = true, desc = "Previous Window" },
    },

    f = {
        function()
            vim.ui.input({ prompt = "Enter Amount", default = "3" }, function(amount)
                vim.ui.input({ prompt = "Enter Width", default = "100" }, function(width)
                    tmux_fibonacci_split_auto(tonumber(amount), tonumber(width))
                end)
            end)
        end,
        { nowait = true, exit = true, desc = "Fibonacci Split" },
    },

    t = {
        function()
            tmux_session()
        end,
        { nowait = true, exit = true, desc = "Switch Session" },
    },

    ["<cr>"] = {
        function()
            vim.ui.input({ prompt = "Enter Name", default = "" }, function(name)
                local command = "tmux rename-window " .. name
                fn.jobstart(command)
            end)
        end,
        { nowait = true, exit = true, desc = "Rename " },
    },
}
for x, y in pairs(silent_binds) do
    config.parenth_mode[x] = {
        function()
            fn.jobstart(y[1])
        end,
        { nowait = true, exit = true, desc = y[2] },
    }
end

local new_hydra = require("modules.editor.hydra.utils").new_hydra(config, {
    name = "TMUX",
    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        timeout = false,
        invoke_on_body = true,
    },
    heads = {},
})

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

    utils.make_core_table(core_table, bracket)
    utils.make_core_table(core_table, { "n", "N" })
    utils.make_core_table(core_table, { "f", "k", "t", "<cr>" })
    utils.make_core_table(core_table, { "l", "h", "u", "d" })
    utils.make_core_table(core_table, { "L", "H", "U", "D" })

    hint_table = {}
    string_val = "^ ^           TMUX            ^ ^\n\n"
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
if vim.fn.getenv("TMUX") ~= vim.NIL then
    Hydra(new_hydra)
end
