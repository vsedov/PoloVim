local utils = require("modules.editor.hydra.utils")
local leader = "<CR>"
local hydra = require("hydra")
local bracket = { "<CR>", "W", "w", "t", "a", ";", "<leader>" }
local input_prompt = "enter the command: cmd >"
local terminal_prompt = "Enter a terminal Number "
local default_terminal = "1"

local cache = {
    command = "ls -a",
    tmux = {
        selected_plane = "",
    },
}
vim.g.goto_harpoon = false

local function plane()
    local data = vim.fn.system("tmux list-panes")
    local lines = vim.split(data, "\n")
    local container = {}

    for _, line in ipairs(lines) do
        local output, output_2 = line:match("^(%d+):.*(%%%d+)")
        if output ~= nil and output_2 ~= nil and output ~= "1" then
            table.insert(container, output .. " : " .. output_2)
        end
    end

    local unicode = { "Σ", "Φ", "Ψ", "λ", "Ω" }
    for i, symbol in ipairs(unicode) do
        table.insert(container, symbol .. " : " .. i)
    end

    return container
end

local function tmux_goto(term)
    if vim.fn.getenv("TMUX") ~= vim.NIL then
        require("harpoon-tmux").gotoTerminal(term)
    else
        require("harpoon.term").gotoTerminal(term)
    end
end

local function terminal_send(term, cmd)
    local module
    local goto_func = "gotoTerminal"
    if vim.fn.getenv("TMUX") ~= vim.NIL then
        module = string.find(term, "%%") and "harpoon.tmux" or "harpoon-tmux"
        if not string.find(term, "%%") then
            term = tonumber(term)
        end
    else
        module = "harpoon.term"
    end

    require(module).sendCommand(term, cmd)
    if vim.g.goto_harpoon == true then
        vim.defer_fn(function()
            require(module)[goto_func](term)
        end, string.find(module, "tmux") and 500 or 1000)
    end
end
local function handle_tmux()
    local data = plane()
    local selected_plane = cache.tmux.selected_plane
    if selected_plane == "" then
        local filtered = vim.tbl_filter(function(item)
            return string.find(item, "%%")
        end, data)
        selected_plane = #filtered > 0 and vim.split(filtered[1], " : ")[2] or vim.split(data[1], " : ")[2]
    end
    cache.tmux.selected_plane = selected_plane
    table.insert(data, "0: cache : " .. selected_plane)
    table.sort(data, function(a, b)
        return a:lower() < b:lower()
    end)
    vim.ui.select(data, { prompt = "Select a Plane " }, function(selected_item)
        local selected_plane = selected_item == "cache" and cache.tmux.selected_plane
            or vim.split(selected_item, " : ")[2]
        cache.tmux.selected_plane = string.find(selected_plane, "%%") and selected_plane or tonumber(selected_plane)
        cache.command = string.find(cache.command, "%D") and cache.command or tonumber(cache.command)
        terminal_send(cache.tmux.selected_plane, cache.command)
    end)
end

local function handle_non_tmux()
    vim.ui.input({ prompt = terminal_prompt, default = default_terminal }, function(terminal_number)
        if not string.find(terminal_number, "%D") then
            local term = tonumber(terminal_number)
            terminal_send(term, cache.command)
        end
    end)
end

local function handle_command_input(command)
    cache.command = command ~= "" and command or cache.command

    if vim.fn.getenv("TMUX") ~= vim.NIL then
        handle_tmux()
    else
        handle_non_tmux()
    end
end

local config = {}

local exit = { nil, { exit = true, desc = "EXIT" } }

config.parenth_mode = {
    color = "red",
    body = leader,
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },
    s = {
        function()
            vim.ui.input({ prompt = input_prompt }, handle_command_input)
        end,
        { nowait = true, exit = true, desc = "Terminal GotoSend" },
    },
    S = {
        function()
            vim.ui.input({ prompt = "enter the terminal: term >" }, function(value2)
                tmux_goto(tonumber(value2))
            end)
        end,
        { nowait = true, exit = true, desc = "Terminal Goto" },
    },

    ["<CR>"] = {
        function()
            lambda.clever_tcd()
            require("harpoon.ui").toggle_quick_menu()
        end,

        { nowait = true, exit = true, desc = "Quick Menu" },
    },
    w = {
        function()
            vim.g.goto_harpoon = not vim.g.goto_harpoon
            vim.notify("Goto Harpoon " .. tostring(vim.g.goto_harpoon))
        end,
        { nowait = true, exit = true, desc = "Toggle Goto" },
    },
    t = {
        function()
            require("harpoon.mark").toggle_file()
        end,
        { nowait = true, exit = true, desc = "Toggle File" },
    },

    [";"] = {
        function()
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
            lambda.clever_tcd()
            require("harpoon.cmd-ui").toggle_quick_menu()
        end,
        { nowait = true, exit = true, desc = "Quick ui Menu" },
    },

    W = {
        function()
            vim.ui.input({ prompt = "Harpoon > ", default = "1" }, function(index)
                if index == nil or index == "" then
                    return
                end

                require("harpoon.ui").nav_file(tonumber(index))
            end)
        end,
        { nowait = true, desc = "Jump File", exit = true },
    },
}

local new_hydra = require("modules.editor.hydra.utils").new_hydra(config, {
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

    num = utils.create_table_normal({}, sorted, 1, { "s", "S" }, bracket)
    harpoon = utils.create_table_normal({}, sorted, 1, { "n", "N" }, bracket)

    core_table = {}

    utils.make_core_table(core_table, bracket)
    utils.make_core_table(core_table, num)
    utils.make_core_table(core_table, harpoon)

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
