local leader = "J"
local utils = require("modules.lsp.lsp.utils")
local mx = function(feedkeys, type)
    local type = type or "m"
    return function()
        if type == "v" then
            vim.api.nvim_feedkeys(vim.keycode("v", true, true, true), "n", true)
        end

        vim.api.nvim_feedkeys(vim.keycode(feedkeys, true, false, true), type, false)
    end
end
local bracket = { "J", "j", "k" }

local config = {
    Lsp = {
        color = "pink",
        body = leader,
        mode = { "n", "v" },

        ["<ESC>"] = { nil, { exit = true } },
        ["J"] = { mx("g;"), { nowait = true, desc = "Core g Key ", exit = true } }, -- ts: inner conditional

        j = {
            function()
                vim.diagnostic.goto_prev()
            end,
            { exit = false, nowait = true, desc = "Diag [G] Prev" },
        },

        k = {
            function()
                vim.diagnostic.goto_next()
            end,
            { nowait = true, exit = false, desc = "Diag [G] Next" },
        },
        d = {
            function()
                vim.cmd([[Glance definitions]])
            end,
            { nowait = true, exit = true, desc = "Glance Def" },
        },
        D = {
            function()
                vim.cmd([[Glance type_definitions]])
            end,
            { nowait = true, exit = true, desc = "Glance TDef" },
        },
        r = {
            function()
                vim.cmd([[Glance references]])
            end,
            { nowait = true, exit = true, desc = "Glance Ref" },
        },

        i = {
            function()
                vim.cmd([[Glance implementations]])
            end,
            { nowait = true, exit = true, desc = "Glance Imp" },
        },
        t = {
            function()
                vim.cmd([[TroubleToggle]])
            end,
            { nowait = true, exit = true, desc = "TroubleToggle" },
        },

        l = {
            utils.format_range_operator,
            { nowait = true, exit = true, desc = "Range Diagnostics", mode = { "v" } },
        },
    },
}

return {
    config,
    "Lsp",
    { { "d", "D", "r", "i", "t", "l" } },
    bracket,
    6,
    3,
}
