local hydra = require("hydra")
local leader = "<CR>"
local bracket = { "<CR>", "W", "w", "a", ";", "<leader>" }

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
local function tmux_goto(term)
    if vim.fn.getenv("TMUX") ~= vim.NIL then
        require("harpoon.tmux").gotoTerminal(term)
    else
        require("harpoon.term").gotoTerminal(term)
    end
end

local function plane()
    data = vim.fn.system("tmux list-panes")
    data = vim.split(data, "\n")
    container = {}
    for _, v in ipairs(data) do
        output, output_2 = v:match("^(%d+):.*(%%%d+)")
        if output ~= nil or output_2 ~= nil then
            container[output] = output_2
        end
    end
    container["1"] = nil
    if #container >= 0 then
        term = container
    end
    return term
end

local function terminal_send(term, cmd)
    if not (cmd == "" or cmd:find("%D")) then
        vim.notify("Using UI Command Leaders")
        cmd = tonumber(cmd)
    end
    if vim.fn.getenv("TMUX") ~= vim.NIL then
        require("harpoon.tmux").sendCommand(term, cmd)
    else
        local use_split = vim.fn.input("VSplit : yes or no > ")
        if use_split then
            local harpooned = vim.api.nvim_get_current_line()
            local pwd = vim.fn.getcwd() .. "/"
            vim.cmd("vsplit | edit " .. pwd .. harpooned)
        end

        require("harpoon.term").sendCommand(term, cmd)
    end
    tmux_goto(term)
end

local config = {}

local exit = { nil, { exit = true, desc = "EXIT" } }
config.parenth_mode = {
    color = "red",
    body = leader,
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },
    ["["] = {
        function()
            vim.ui.input({ prompt = "enter the command: cmd >" }, function(value)
                vim.ui.input({ prompt = "Do you want to use a Plane or Number >", default = "1" }, function(value2)
                    if not (value2:find("%D")) then
                        term = tonumber(value2)
                    else
                        term = vim.ui.select(plane(), { prompt = "Select a Plane " }, function(choice)
                            choice = choice or 1
                            return choice
                        end)
                    end
                    terminal_send(term, value)
                end)
            end)
        end,
        { nowait = true, exit = true, desc = "Terminal GotoSend" },
    },
    ["]"] = {
        function()
            vim.ui.input({ prompt = "enter the terminal: term >" }, function(value2)
                tmux_goto(tonumber(value2))
            end)
        end,
        { nowait = true, exit = true, desc = "Terminal Goto" },
    },

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

    ["W"] = {
        function()
            local index = vim.fn.input("Harpoon > ")
            if index == nil or index == "" then
                return
            end
            require("harpoon.ui").nav_file(tonumber(index))
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

    num = create_table_normal({}, sorted, 1, { "[", "]" })
    harpoon = create_table_normal({}, sorted, 1, { "n", "N" })

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
