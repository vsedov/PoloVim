local leader = ";l"

local lsp_lens_active = false
local bracket = { "J", "K", "w" }

local config = {
    Lsp = {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        J = {
            function()
                vim.diagnostic.goto_prev()
            end,
            { exit = false, nowait = true, desc = "Diag [G] Prev" },
        },

        K = {
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
        r = {
            function()
                vim.cmd([[Glance references]])
            end,
            { nowait = true, exit = true, desc = "Glance Ref" },
        },
        D = {
            function()
                vim.cmd([[Glance type_definitions]])
            end,
            { nowait = true, exit = true, desc = "Glance TDef" },
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

        s = {
            function()
                require("goto-preview").goto_preview_definition({
                    focus_on_open = false,
                    dismiss_on_move = true,
                })
            end,
            { nowait = true, exit = true, desc = "[G] Def" },
        },
        S = {
            function()
                require("goto-preview").goto_preview_references({
                    focus_on_open = false,
                    dismiss_on_move = true,
                })
            end,
            { nowait = true, exit = true, desc = "[G] Ref" },
        },
        I = {
            function()
                require("goto-preview").goto_preview_implementation({
                    focus_on_open = false,
                    dismiss_on_move = true,
                })
            end,
            { nowait = true, exit = true, desc = "[G] Imp" },
        },
        c = {
            function()
                require("goto-preview").close_all_win()
            end,
            { nowait = true, exit = true, desc = "[G] Close" },
        },
        w = {
            function()
                vim.cmd([[LspLensToggle]])
                lsp_lens_active = not lsp_lens_active
                vim.notify("LspLense = " .. tostring(lsp_lens_active))
            end,
            { nowait = true, exit = true, desc = "LspLensToggle" },
        },
    },
}

return {
    config,
    "Lsp",
    { { "d", "D", "r", "i", "t" }, { "s", "S", "I", "c" } },
    bracket,
    6,
    3,
}
