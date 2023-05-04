local utils = require("modules.editor.hydra.utils")
local hydra = require("hydra")
local config = {}
local exit = { nil, { exit = true, desc = "EXIT" } }

local bracket = { "H", "J", "K", "L" }
-- Executes '<Plug>GoNMLineLeft based commands

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
-- vim.cmd([[
-- nmap <S-h> <Plug>GoNSMLeft
-- nmap <S-j> <Plug>GoNSMDown
-- nmap <S-k> <Plug>GoNSMUp
-- nmap <S-l> <Plug>GoNSMRight
--
--
-- xmap <S-h> <Plug>GoVSMLeft
-- xmap <S-j> <Plug>GoVSMDown
-- xmap <S-k> <Plug>GoVSMUp
-- xmap <S-l> <Plug>GoVSMRight
--
-- nmap <C-h> <Plug>GoNSDLeft
-- nmap <C-j> <Plug>GoNSDDown
-- nmap <C-k> <Plug>GoNSDUp
-- nmap <C-l> <Plug>GoNSDRight
--
-- xmap <C-h> <Plug>GoVSDLeft
-- xmap <C-j> <Plug>GoVSDDown
-- xmap <C-k> <Plug>GoVSDUp
-- xmap <C-l> <Plug>GoVSDRight
-- ]])

local bindsN = function(mode)
    vim.notify(mode)
    return {
        H = { "<Plug>Go" .. mode .. "SMLeft", { desc = "Move Left" } },
        J = { "<Plug>Go" .. mode .. "SMDown", { desc = "Move Down" } },
        K = { "<Plug>Go" .. mode .. "SMUp", { desc = "Move Up" } },
        L = { "<Plug>Go" .. mode .. "SMRight", { desc = "Move Right" } },
        h = { "<Plug>Go" .. mode .. "SDLeft", { desc = "Duplicate Left" } },
        j = { "<Plug>Go" .. mode .. "SDDown", { desc = "Duplicate Down" } },
        k = { "<Plug>Go" .. mode .. "SDUp", { desc = "Duplicate Up" } },
        l = { "<Plug>Go" .. mode .. "SDRight", { desc = "Duplicate Right" } },
    }
end

config.move = {
    color = "red",
    body = "<leader><leader>m",
    ["<ESC>"] = { nil, { desc = "Exit", exit = true } },

    H = {
        function()
            local plug_command = bindsN(string.upper(vim.fn.mode()))["H"][1]
            return plug_command
        end,

        { desc = "Move Left" },
    },

    J = {
        function()
            mode = vim.api.nvim_get_mode().mode
            mode = string.upper(mode)
            print(mode)
            return bindsN(mode)["J"][1]
        end,
        { desc = "Move Down" },
    },

    K = {
        function()
            mode = vim.api.nvim_get_mode().mode
            mode = string.upper(mode)
            return bindsN(mode)["K"][1]
        end,
        { desc = "Move Up" },
    },
    L = {
        function()
            mode = vim.api.nvim_get_mode().mode
            mode = string.upper(mode)
            return bindsN(mode)["L"][1]
        end,
        { desc = "Move Right" },
    },
    ["<c-h>"] = {
        function()
            mode = vim.api.nvim_get_mode().mode
            mode = string.upper(mode)
            return bindsN(mode)["h"][1]
        end,
        { desc = "Duplicate Left" },
    },
    ["<c-j>"] = {
        function()
            mode = vim.api.nvim_get_mode().mode
            mode = string.upper(mode)
            return bindsN(mode)["j"][1]
        end,
        { desc = "Duplicate Down" },
    },
    ["<c-k>"] = {
        function()
            mode = vim.api.nvim_get_mode().mode
            mode = string.upper(mode)
            return bindsN(mode)["k"][1]
        end,
        { desc = "Duplicate Up" },
    },
    ["<c-l>"] = {
        function()
            mode = vim.api.nvim_get_mode().mode
            mode = string.upper(mode)
            return bindsN(mode)["l"][1]
        end,
        { desc = "Duplicate Right" },
    },
}

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.move) do
        if y[2] ~= nil then
            container[x] = y[2].desc
        end
    end

    sorted = {}
    for k, v in pairs(container) do
        table.insert(sorted, k)
    end
    table.sort(sorted)

    core_table = {}

    utils.make_core_table(core_table, bracket)
    utils.make_core_table(core_table, { "<c-h>", "<c-j>", "<c-k>", "<c-l>" })

    hint_table = {}
    string_val = "^ ^          Movement        ^ ^\n\n"
    string_val = string_val
        .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint
                .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
        else
            if container[v] then
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
            end
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
    end
    return string_val
end

vim.defer_fn(function()
    local new_hydra = require("modules.editor.hydra.utils").new_hydra(config, {
        name = "Movememt",
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {},
        mode = { "n", "x" },
    })

    val = auto_hint_generate()
    new_hydra.hint = val
    hydra(new_hydra)
end, 100)
