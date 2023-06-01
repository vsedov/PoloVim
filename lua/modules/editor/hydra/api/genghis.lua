local leader = ";\\"

local exit = { nil, { exit = true, desc = "EXIT" } }

local config = {
    Genghis = {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },

        c = {
            function()
                vim.cmd([[GenghiscopyFilepath]])
            end,

            { nowait = false, exit = true, desc = "CopyFilepath" },
        },
        C = {
            function()
                vim.cmd([[GenghiscopyFilename]])
            end,
            { nowait = true, exit = true, desc = "CopyFilename" },
        },
        ["<cr>"] = {
            function()
                vim.cmd([[Genghischmodx]])
            end,
            { nowait = true, exit = true, desc = "Chmodx" },
        },
        r = {
            function()
                vim.cmd([[GenghisrenameFile]])
            end,
            { nowait = true, exit = true, desc = "RenameFile" },
        },
        d = {
            function()
                vim.cmd([[GenghisduplicateFile]])
            end,
            { nowait = true, exit = true, desc = "Duplicate" },
        },

        n = {
            function()
                vim.cmd([[GenghiscreateNewFile]])
            end,
            { nowait = true, exit = true, desc = "CreateNewFile" },
        },
        T = {
            function()
                vim.cmd([[Genghistrash]])
            end,
            { nowait = true, exit = true, desc = "Trash" },
        },

        m = {
            function()
                vim.cmd([[Genghismove]])
            end,
            { nowait = true, exit = false, desc = "Move" },
        },
    },
}
return {
    config,
    "Genghis",
    { { "r", "d", "n", "m", "T" } },
    { "c", "C", "<cr>" },
    6,
    3,
}
