local utils = require("modules.editor.hydra.utils")
local hydra = require("hydra")
local config = {}
local exit = { nil, { exit = true, desc = "EXIT" } }

local bracket = { "n", "N", "r", "d", "R", "T" }
config.attempt = {
    color = "red",
    body = ";A",

    ["<ESC>"] = { nil, { exit = true } },
    n = { require("attempt").new_select, { desc = "New Attempt", nowait = true, silent = true, exit = true } },
    N = { require("attempt").new_input_ext, { desc = "New Attempt", nowait = true, silent = true, exit = true } },

    r = { require("attempt").run, { desc = "Run Attempt", nowait = true, silent = true } },
    d = { require("attempt").delete_buf, { desc = "Delete Attempt", nowait = true, silent = true } },
    R = { require("attempt").rename_buf, { desc = "Rename Attempt", nowait = true, silent = true } },
    T = {
        function()
            vim.cmd([[Telescope attempt]])
        end,
        { desc = "Telescope Attempt", nowait = true, silent = true },
    },
}

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.attempt) do
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

    hint_table = {}
    string_val = "^ ^ ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
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
        name = "Attempt",
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {},
        mode = { "n" },
    })

    val = auto_hint_generate()
    new_hydra.hint = val
    hydra(new_hydra)
end, 100)
