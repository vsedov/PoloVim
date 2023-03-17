-- |:tNext|	:tN[ext]	jump to previous matching tag
-- |:tabNext|	:tabN[ext]	go to previous tab page
-- |:tabclose|	:tabc[lose]	close current tab page
-- |:tabdo|	:tabdo		execute command in each tab page
-- |:tabedit|	:tabe[dit]	edit a file in a new tab page
-- |:tabfind|	:tabf[ind]	find file in 'path', edit it in a new tab page
-- |:tabfirst|	:tabfir[st]	go to first tab page
-- |:tablast|	:tabl[ast]	go to last tab page
-- |:tabmove|	:tabm[ove]	move tab page to other position
-- |:tabnew|	:tabnew		edit a file in a new tab page
-- |:tabnext|	:tabn[ext]	go to next tab page
-- |:tabonly|	:tabo[nly]	close all tab pages except the current one
-- |:tabprevious|	:tabp[revious]	go to previous tab page
-- |:tabrewind|	:tabr[ewind]	go to first tab page
-- |:tabs|		:tabs		list the tab pages and what they contain
-- |:tab|		:tab		create new tab when opening new window

local utils = require("modules.editor.hydra.utils")
local leader = "<leader>B"

local hydra = require("hydra")
local config = {}

local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local bracket = { "<cr>", "<BS>", "z", "n", "N", "e" }
local exit = { nil, { exit = false, desc = "EXIT" } }
config.tab = {
    color = "red",
    body = leader,
    ["<ESC>"] = { nil, { exit = false, desc = "EXIT" } },
    n = {
        cmd("tabnext"),
        { nowait = true, exit = false, desc = "TabNext" },
    },
    ["<BS>"] = {
        cmd("tabc"),
        { nowait = true, exit = false, desc = "TabClose" },
    },
    N = {
        cmd("tabprevious"),
        { nowait = true, exit = false, desc = "TabPrev" },
    },
    z = {
        function()
            vim.cmd("Telescope zoxide list")
        end,

        { nowait = true, exit = false, desc = "Zoxide" },
    },
    d = {
        cmd("tabdo oil"),
        { nowait = true, exit = false, desc = "TabDo oil" },
    },
    e = {
        --  TODO: (vsedov) (03:49:50 - 10/03/23): Make this into an input option that lists the files
        cmd("tabe"),

        { nowait = true, exit = false, desc = "TabEdit" },
    },
    f = {
        cmd("tabf"),
        { nowait = true, exit = false, desc = "TabFind" },
    },
    F = {
        cmd("tabF"),
        { nowait = true, exit = false, desc = "TabFindPrev" },
    },
    ["1"] = {
        cmd("tabfir"),
        { nowait = true, exit = false, desc = "TabFirst" },
    },
    ["$"] = {
        cmd("tabl"),
        { nowait = true, exit = false, desc = "TabLast" },
    },
    m = {
        cmd("tabm"),
        { nowait = true, exit = false, desc = "TabMove" },
    },

    r = {
        cmd("tabr"),
        { nowait = true, exit = false, desc = "TabRewind" },
    },
    s = {
        cmd("tabs"),
        { nowait = true, exit = false, desc = "TabList" },
    },
    ["<cr>"] = {
        cmd("tabnew"),
        { nowait = true, exit = false, desc = "TabNew" },
    },
}

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.tab) do
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
    utils.make_core_table(core_table, { "d", "f", "F", "1", "$" })

    utils.make_core_table(core_table, { "m", "r", "s" })

    hint_table = {}
    string_val = "^ ^       Tabs      ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
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
        name = "Browser",
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

    val = auto_hint_generate()
    new_hydra.hint = val
    hydra(new_hydra)
end, 100)
