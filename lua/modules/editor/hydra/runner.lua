local hydra = require("hydra")
local utils = require("modules.editor.hydra.utils")

local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local match = lambda.lib.match
local when = lambda.lib.when

local config = {}
local run_or_test = function(debug)
    local ft = vim.bo.filetype
    if ft == "lua" then
        return ":RunCode<CR>"
    else
        local m = vim.fn.mode()
        if m == "n" or m == "i" then
            cmd("Lab code run")
        else
            require("sniprun").run("v")
        end
    end
end

local bracket = { "<cr>", "w", "s", "r", "f" }
config.runner = {
    color = "red",
    body = ";r",
    ["<ESC>"] = { nil, { exit = true } },
    w = { cmd("OverseerToggle"), { desc = "Overseer Toggle", exit = true } },
    s = { cmd("OverseerRun"), { desc = "Overseer Run", exit = true } },
    d = { cmd("OverseerQuickAction"), { desc = "Overseer Quick AcAction", exit = true } },
    t = { cmd("OverseerTaskAction"), { desc = "OverseerTaskAction", exit = true } },
    b = { cmd("OverseerBuild"), { desc = "OverseerBuild", exit = true } },
    l = { cmd("OverseerLoadBundle"), { desc = "OverSeer Load", exit = true } },
    ["<cr>"] = {
        function()
            local overseer = require("overseer")
            overseer.run_template({
                name = "Run " .. vim.bo.filetype:gsub("^%l", string.upper) .. " file (" .. vim.fn.expand("%:t") .. ")",
            }, function(task)
                task = task or "Poetry run file"
                if task then
                    overseer.run_action(task, "open float")
                end
            end)
        end,
        { exit = true, desc = "Overseer Fast Run" },
    },

    r = { cmd("RunCode"), { exit = true, desc = "RunCode" } },
    f = {
        function()
            run_or_test()
        end,
        { exit = true, desc = "Run Code/Test" },
    },
    i = { cmd("Lab code run"), { exit = true, desc = "Lab Run" } },
    o = { cmd("Lab code stop"), { exit = false, desc = "Lab Stop" } },
    p = { cmd("Lab code panel"), { exit = false, desc = "Lab Panel" } },

    s = {
        function()
            if vim.fn.mode() == "n" then
                vim.cmd.SnipRun()
            else
                vim.cmd([['<,'>SnipRun]])
            end
        end,
        { exit = true, desc = "SnipRun" },
    },
}

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.runner) do
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
    utils.make_core_table(core_table, { "d", "t", "b", "l" })
    utils.make_core_table(core_table, { "s", "i", "o", "p" })

    hint_table = {}
    string_val = "^ ^          Runner       ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
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
        name = "Runner",
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {},
        mode = { "n", "v", "x", "o" },
    })

    val = auto_hint_generate()
    print(val)
    new_hydra.hint = val
    hydra(new_hydra)
end, 100)
