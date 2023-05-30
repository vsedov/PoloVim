local utils = require("modules.editor.hydra.utils")
local hydra = require("hydra")
local config = {}
local exit = { nil, { exit = true, desc = "EXIT" } }

config.move = {
    color = "red",
    body = "<leader>m",
    ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
    -- cmd = {
    --     "MurenToggle",
    --     "MurenOpen",
    --     "MurenClose",
    --     "MurenFresh",
    --     "MurenUnique",
    -- },

    m = {
        function()
            vim.cmd("MurenToggle")
        end,
        { desc = "Toggle UI" },
    },
    o = {
        function()
            vim.cmd("MurenOpen")
        end,
        { desc = "Open UI" },
    },
    c = {
        function()
            vim.cmd("MurenClose")
        end,
        { desc = "Close UI" },
    },

    f = {
        function()
            vim.cmd("MurenFresh")
        end,
        { desc = "Open Fresh UI" },
    },
    u = {
        function()
            vim.cmd("MurenUnique")
        end,
        { desc = "Open Unique UI" },
    },
}
local bracket = { "m", "o", "c", "f", "u" }

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

    hint_table = {}
    string_val = "^ ^    Muren       ^ ^\n\n"
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
        name = "Muren",
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
