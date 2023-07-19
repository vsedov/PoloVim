local leader = "H"
local utils = require("modules.lsp.lsp.utils")

local lsp_lens_active = false
local bracket = { "j", "k", "w" }

local config = {
    Lsp = {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },

        ["<ESC>"] = { nil, { exit = true } },
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

        w = {
            function()
                vim.cmd([[LspLensToggle]])
                lsp_lens_active = not lsp_lens_active
                vim.notify("LspLense = " .. tostring(lsp_lens_active))
            end,
            { nowait = true, exit = true, desc = "LspLensToggle" },
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
