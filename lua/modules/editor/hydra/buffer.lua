local Hydra = require("hydra")
local leader_key = "<leader>b"
local cmd = require("hydra.keymap-util").cmd

local bracket = { "l", "h", "tl", "th", "]", "[", "<leader>", "-", "+", "b" }
local function buffer_move()
    vim.ui.input({ prompt = "Move buffer to:" }, function(idx)
        idx = idx and tonumber(idx)
        if idx then
            require("three").move_buffer(idx)
        end
    end)
end

local function make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end

vim.api.nvim_create_user_command("ProjectDelete", function()
    require("three").remove_project()
end, {})

local exit = { nil, { exit = true, desc = "EXIT" } }
local config = {}
config.buffer = {
    color = "red",
    body = leader_key,
    mode = { "n" },

    b = {
        function()
            vim.cmd("Telescope buffers")
        end,
        { desc = "Buffers" },
    },
    l = {
        function()
            cmd("BufferLineCycleNext")
        end,

        { desc = "Next Buffers", exit = false },
    },
    h = {
        function()
            vim.cmd("BufferLineCyclePrev")
        end,

        { desc = "Prev Buffers", exit = false },
    },

    tl = {
        function()
            require("three").next()
        end,

        { desc = "[G]oto next [B]uffer", exit = false },
    },
    th = {
        function()
            require("three").prev()
        end,

        { desc = "[G]oto Prev [B]uffer", exit = false },
    },

    ["["] = {
        function()
            require("three").next_tab()
        end,
        { desc = "[G]oto next [T]ab", exit = false },
    },
    ["]"] = {
        function()
            require("three").prev_tab()
        end,
        { desc = "[G]oto prev [T]ab", exit = false },
    },
    --
    ["<leader>"] = {
        function()
            vim.ui.input({ prompt = "enter the buffer you want to jump to" }, function(value)
                require("three").wrap(require("three").jump_to, value)
            end)
        end,
        { desc = "Jump to buffer" },
    },
    ["-"] = {
        function()
            require("three").next()
        end,
        { desc = "Jump to last buffer", exit = false },
    },
    ["+"] = {
        function()
            require("three").prev()
        end,
        { desc = "Jump to last buffer", exit = false },
    },

    q = {
        function()
            require("three").smart_close()
        end,
        { desc = "[C]lose window or buffer" },
    },
    Q = {
        function()
            require("three").close_buffer()
        end,
        { desc = "[B]uffer [C]lose" },
    },
    M = {
        function()
            require("three").hide_buffer()
        end,
        { desc = "[B]uffer [H]ide" },
    },
    m = {
        function()
            buffer_move()
        end,
        { desc = "[B]uffer [M]ove" },
    },

    n = {
        function()
            vim.cmd("$tabnew<CR>")
        end,
        { desc = "Tab New", exit = false },
    },
    C = {
        function()
            vim.cmd("$tabclose<cr>")
        end,
        { desc = "Tab close" },
    },
    [">"] = {
        function()
            vim.cmd("+tabmove<CR>")
        end,
        { desc = "TabNext", exit = false },
    },
    ["<"] = {
        function()
            vim.cmd("-tabmove<CR>")
        end,
        { desc = "TabPrev", exit = false },
    },

    P = {
        function()
            require("three").open_project()
        end,
        { desc = "Three Project", exit = true },
    },

    c = {
        function()
            vim.cmd("BufferLinePick")
        end,
        { desc = "Pin buffer" },
    },
    H = {
        function()
            vim.cmd("BufferLineMoveNext")
        end,
        { desc = "Move Next", exit = false },
    },
    L = {
        function()
            vim.cmd("BufferLineMovePrev")
        end,
        { desc = "Move Prev", exit = false },
    },
    D = {
        function()
            vim.cmd("BufferLinePickClose")
        end,
        { desc = "Close Buf", exit = false },
    },
    p = {
        function()
            vim.cmd("BufferLineTogglePin")
        end,
        { desc = "Pin Buf" },
    },

    ["1"] = {
        function()
            vim.cmd("BufferLineSortByTabs")
        end,
        { desc = "Sort Tabs" },
    },
    ["2"] = {
        function()
            vim.cmd("BufferLineSortByDirectory")
        end,
        { desc = "Sort Dir" },
        -- { desc = "Sort dir", exit = true },
    },
    ["3"] = {
        function()
            vim.cmd("BufferLineSortByRelativeDirectory")
        end,
        { desc = "Sort RDir" },
    },

    d = {
        function()
            vim.cmd("Bwipeout")
        end,
        { desc = "delete buffer" },
    },
    N = {
        function()
            vim.cmd("BufKillNameless")
        end,
        { desc = "BufKillNameless" },
    },
    ["<CR>"] = {
        function()
            vim.cmd("BufKillHidden")
        end,
        { desc = "BufKillHidden" },
    },
    A = {
        function()
            vim.cmd("BufWipe")
        end,
        { desc = "Wipe" },
    },
    o = {
        function()
            vim.cmd("BufKillThis")
        end,
        { desc = "Killthis" },
    },
}
local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.buffer) do
        local mapping = x
        if type(y[1]) == "function" then
            for x, y in pairs(y[2]) do
                container[mapping] = y
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
    make_core_table(core_table, { "q", "Q", "M", "m" })
    make_core_table(core_table, { "n", "C", ">", "<", "P" })
    make_core_table(core_table, { "p", "c", "H", "L" })
    make_core_table(core_table, { "<cr>", "D", "d", "N", "A", "o" })
    make_core_table(core_table, { "1", "2", "3" })

    hint_table = {}
    string_val = "^ ^          Buffers         ^ ^\n\n"
    string_val = string_val
        .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
    --
    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ ^ ^\n"
        else
            if container[v] then
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
            else
                hint = "^ ^ _" .. v .. "_: " .. " ^ ^\n"
            end
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
    end
    return string_val
end

val = auto_hint_generate()

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
new_hydra.hint = val
Hydra(new_hydra)
