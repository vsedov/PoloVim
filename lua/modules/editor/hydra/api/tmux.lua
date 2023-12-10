local fn = vim.fn
local leader_key = ";<tab>"

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")

local function tmux_split(tmux, percentage, external_command)
    if external_command ~= nil then
        external_command = external_command or "nvim ."
    end

    command = "tmux split-window -" .. tmux .. " -p " .. percentage
    if external_command ~= nil then
        command = command .. " '" .. external_command .. "'"
    end
    os.execute(command)
end
-- tmux_move_session("n")
-- tmux_move_session("p")
local function tmux_move_session(left_right)
    os.execute("tmux select-window -" .. left_right)
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
        tmux_split(direction, math.floor(width * (percentage / sum)), nil)
    end

    local split_direction = "h"
    for i, v in ipairs(fib_sequence) do
        split(split_direction, v)
        split_direction = split_direction == "h" and "v" or "h"
    end
end
local function new_pane()
    os.execute("tmux new-window ")
end

local function tmux_session()
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

local function auto_tmux_resize()
    local tmux_width = tonumber(fn.system("tmux display -p '#{window_width}'"))
    local tmux_height = tonumber(fn.system("tmux display -p '#{window_height}'"))
    local vim_width = vim.o.columns
    local vim_height = vim.o.lines

    local width_diff = math.abs(tmux_width - vim_width)
    local height_diff = math.abs(tmux_height - vim_height)

    if width_diff > 1 or height_diff > 1 then
        local cmd = "tmux resize-pane -t " .. vim.fn.expand("%:p") .. " -x " .. vim_width .. " -y " .. vim_height
        os.execute(cmd)
    end
end

local bracket = { "s", "S", "w" }
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
local config = {
    Tmux = {
        color = "red",
        body = leader_key,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        s = {
            function()
                vim.ui.input({ prompt = "Enter Percentage", default = "40" }, function(percent)
                    vim.ui.input({ prompt = "Enter Command", default = "nvim ." }, function(command)
                        if command == "" or command == "nil" then
                            command = nil
                        end

                        tmux_split("h", tonumber(percent), command)
                    end)
                end)
            end,
            { nowait = true, exit = true, desc = "Open Vertical" },
        },
        S = {
            function()
                vim.ui.input({ prompt = "Enter Percentage", default = "40" }, function(percent)
                    vim.ui.input({ prompt = "Enter Command", default = "nvim ." }, function(command)
                        if command == "" or command == "nil" then
                            command = nil
                        end

                        tmux_split("v", tonumber(percent), command)
                    end)
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
                    defaults = {
                        ["1"] = "40",
                        ["2"] = "80",
                        ["3"] = "100",
                        ["4"] = "160",
                    }
                    default = defaults[amount] or "100"
                    vim.ui.input({ prompt = "Enter Width", default = default }, function(width)
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
                    os.execute(command)
                end)
            end,
            { nowait = true, exit = true, desc = "Rename " },
        },

        w = {
            function()
                new_pane()
            end,
            { nowait = true, exit = true, desc = "New Pane" },
        },
        L = {

            function()
                fn.jobstart("tmux set-window-option automatic-rename on")
            end,
        },
    },
}
for x, y in pairs(silent_binds) do
    config.Tmux[x] = {
        function()
            os.execute(y[1])
        end,
        { nowait = true, exit = true, desc = y[2] },
    }
end
return {
    config,
    "Tmux",
    { { "n", "N" }, { "f", "k", "t", "<cr>" }, { "l", "h", "u", "d" }, { "L", "H", "U", "D" } },
    bracket,
    6,
    3,
}
