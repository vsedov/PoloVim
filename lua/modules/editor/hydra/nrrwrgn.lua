local utils = require("modules.editor.hydra.utils")
local hydra = require("hydra")
local config = {}
local exit = { nil, { exit = true, desc = "EXIT" } }

local bracket = { "<cr>", "w", "W", "m", "M" }
local options = {
    NR = ": Open the selected region in a new narrowed window",
    NW = ": Open the current visual window in a new narrowed window",
    WR = ": (In the narrowed window) write the changes back to the original buffer.",
    NRV = ": Open the narrowed window for the region that was last visually selected.",
    NUD = ": (In a unified diff) open the selected diff in 2 Narrowed windows",
    NRP = ": Mark a region for a Multi narrowed window",
    NRM = ": Create a new Multi narrowed window (after :NRP) - experimental!",
    NRS = ": Enable Syncing the buffer content back (default on)",
    NRN = ": Disable Syncing the buffer content back",
    NRL = ": Reselect the last selected region and open it again in a narrowed window",
}

config.browse = {
    color = "red",
    body = ";e",
    ["<ESC>"] = { nil, { exit = true } },
    ["<cr>"] = {
        function()
            vim.ui.select(vim.tbl_keys(options), {
                prompt = "Select an option: ",
                format_item = function(entry, _)
                    return string.format("%s: %s", entry, options[entry])
                end,
            }, function(selected)
                if selected == nil then
                    return
                end
                vim.cmd(selected)
            end)
        end,
        { nowait = true, silent = true, desc = "Narrow[N] Window", exit = true },
    },
    W = {
        function()
            vim.cmd([[NR]])
        end,
        { nowait = true, silent = true, desc = "Narrow[N] Window", exit = true },
    },

    w = {
        function()
            vim.cmd([[NW]])
        end,
        { nowait = true, silent = true, desc = "Narrow[V] Window", exit = true },
    },

    [";"] = {
        function()
            vim.cmd([[NRV]])
        end,
        { nowait = true, silent = true, desc = "Narrow[V]Win Last", exit = true },
    },

    u = {
        function()
            vim.cmd([[NUD]])
        end,
        { nowait = true, silent = true, desc = "Unique Diff", exit = false },
    },

    m = {
        function()
            vim.cmd([[NRP]])
        end,
        { nowait = true, silent = true, desc = "Mark region", exit = false },
    },

    M = {
        function()
            vim.cmd([[NRM]])
        end,
        { nowait = true, silent = true, desc = "[M]Win After :NRP", exit = false },
    },

    S = {
        function()
            vim.cmd([[NRS]])
        end,
        { nowait = true, silent = true, desc = "Sync Back to Buffer", exit = false },
    },

    s = {
        function()
            vim.cmd([[WR]])
        end,
        { nowait = true, silent = true, desc = "In Window Save", exit = false },
    },
    d = {
        function()
            vim.cmd([[NRN]])
        end,
        { nowait = true, silent = true, desc = "Disable Sync", exit = false },
    },

    l = {
        function()
            vim.cmd([[NRL]])
        end,
        { nowait = true, silent = true, desc = "Reselect Last Area", exit = false },
    },
}

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.browse) do
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
    utils.make_core_table(core_table, { ";", "l" })
    utils.make_core_table(core_table, { "s", "S", "d", "u" })

    hint_table = {}
    string_val = "^ ^     Nrrwrgn   ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
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
        name = "Nrrwrgn",
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
    new_hydra.hint = val
    hydra(new_hydra)
end, 100)
