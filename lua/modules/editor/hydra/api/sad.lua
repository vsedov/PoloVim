local leader = "L"
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local config = {
    Sad = {
        color = "pink",
        body = leader,
        mode = { "n", "x", "v" },
        ["<ESC>"] = { nil, { exit = true } },
        L = {
            function()
                require("substitute").operator()
            end,
            { nowait = true, desc = "Operator Sub", exit = true },
        },

        l = {
            function()
                require("substitute").line()
            end,
            { nowait = true, desc = "Operator line", exit = true },
        },
        ----------------------------------------------------------
        -- local core = { "o", "g", "<cr>" }

        K = {
            function()
                require("substitute").eol()
            end,
            { nowait = true, desc = "Operator eol", exit = true },
        },

        k = {
            function()
                require("substitute.exchange").operator()
            end,
            { nowait = true, desc = "Exchange Sub", exit = true },
        },

        ----------------------------------------------------------
        s = {
            function()
                require("ssr").open()
            end,

            { nowait = true, desc = "SSR Rep", exit = true },
        },
        S = {
            function()
                vim.cmd([[Sad]])
            end,

            { nowait = true, desc = "Sad SSR", exit = true },
        },

        -----------------------------------------------------------
        o = {
            cmd("Spectre"),
            { nowait = true, silent = true, desc = "Open" },
        },
        g = {
            cmd("SpectreToggleLine"),
            { nowait = true, silent = true, desc = "Toggle line" },
        },
        ["<CR>"] = {
            cmd("SpectreSelectEntry"),
            { nowait = true, silent = true, desc = "Select entry" },
        },
        q = {
            cmd("SpectreSendToQF"),
            { nowait = true, silent = true, desc = "Send to quickfix" },
        },
        n = {
            cmd("SpectreReplaceCommand"),
            { nowait = true, silent = true, desc = "Replace command" },
        },
        r = {
            cmd("SpectreRunCurrentReplace"),
            { nowait = true, silent = true, desc = "Run current replace" },
        },
        R = {
            cmd("SpectreRunReplace"),
            { nowait = true, silent = true, desc = "Run replace" },
        },
        I = {
            cmd("SpectreIgnoreCase"),
            { nowait = true, silent = true, desc = "Toggle ignore case" },
        },

        H = {
            cmd("SpectreHidden"),
            { nowait = true, silent = true, desc = "Toggle hidden" },
        },
        U = {
            cmd("SpectreToggleLiveUpdate"),
            { nowait = true, silent = true, desc = "Toggle live update" },
        },
        v = {
            cmd("SpectreChangeView"),
            { nowait = true, silent = true, desc = "Change view" },
        },
        [";"] = {
            cmd("SpectreResumeLastSearch"),
            { nowait = true, silent = true, desc = "Resume last search" },
        },
        p = {
            cmd("SpectreShowOptions"),
            { nowait = true, silent = true, desc = "Show option" },
        },
        --
        -----------------------------

        w = {
            ":S /" .. vim.fn.expand("<cword>") .. "//g<Left><Left>",

            { nowait = true, desc = "Rep All", exit = true },
        },
        W = {
            [[:%S /<C-R><C-W>//gI<left><left><left>]],

            { nowait = true, desc = "Rep Word[C]", exit = true },
        },

        E = {
            [[:S ///g<Left><Left><Left>]],

            { nowait = true, desc = "Rep Word", exit = false },
        },
        m = {
            function()
                vim.cmd("MurenToggle")
            end,
            { desc = "Toggle UI", exit = true },
        },
        M = {
            function()
                vim.cmd("MurenOpen")
            end,
            { desc = "Open UI", exit = true },
        },
        c = {
            function()
                vim.cmd("MurenClose")
            end,
            { desc = "Close UI", exit = true },
        },

        F = {
            function()
                vim.cmd("MurenFresh")
            end,
            { desc = "Open Fresh UI", exit = true },
        },
        u = {
            function()
                vim.cmd("MurenUnique")
            end,
            { desc = "Open Unique UI", exit = true },
        },
    },
}

local bracket = { "s", "W", "w", "S", "E" }
local Muren = { "m", "M", "c", "F", "u" }
local eol = { "L", "l", "K", "k" }
local spectre = { "o", "g", "<CR>", "q", "n", "r", "R", "I", "H", "U", "v", ";", "p" }

return {
    config,
    "Sad",
    { Muren, spectre, eol },
    bracket,
    6,
    3,
}
