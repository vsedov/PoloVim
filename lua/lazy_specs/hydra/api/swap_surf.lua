local leader = ";s"
local config = {
    Swap = {
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },

        k = {
            function()
                require("nvim-treesitter.textobjects.swap").swap_next("@parameter.inner")
            end,

            { nowait = true, desc = "TS Swap →", exit = true },
        },
        j = {
            function()
                require("nvim-treesitter.textobjects.swap").swap_previous("@parameter.inner")
            end,
            { nowait = true, desc = "TS Swap ←", exit = true },
        },
        s = {
            function()
                vim.cmd([[ISwap]])
            end,

            { nowait = true, desc = "Iswap", exit = true },
        },
        S = {
            function()
                vim.cmd([[ISwapWith]])
            end,

            { nowait = true, desc = "IswapWith", exit = false },
        },

        w = {
            function()
                vim.cmd([[STSJumpToTop]])
            end,
            { nowait = true, desc = "Surf Jump Top", exit = false },
        },
        N = {
            function()
                vim.cmd([[STSSelectMasterNode]])
            end,

            { nowait = true, desc = "Surf Master Node", exit = false },
        },
        n = {
            function()
                vim.cmd([[STSSelectCurrentNode]])
            end,

            { nowait = true, desc = "Surf Curent Node", exit = false },
        },

        J = {
            function()
                vim.cmd([[STSSelectNextSiblingNode]])
            end,

            { nowait = true, desc = "Surf [N] Sibling", exit = false },
        },
        K = {
            function()
                vim.cmd([[STSSelectPrevSiblingNode]])
            end,

            { nowait = true, desc = "Surf [P] Sibling", exit = false },
        },
        H = {
            function()
                vim.cmd([[STSSelectParentNode]])
            end,

            { nowait = true, desc = "Surf Parent", exit = false },
        },
        L = {
            function()
                vim.cmd([[STSSelectChildNode]])
            end,

            { nowait = true, desc = "Surf Child", exit = false },
        },
        v = {
            function()
                vim.cmd([[STSSwapNextVisual]])
            end,

            { nowait = true, desc = "Surf [N] Swap", exit = false },
        },
        V = {
            function()
                vim.cmd([[STSSwapPrevVisual]])
            end,

            { nowait = true, desc = "Surf [P] Swap", exit = false },
        },
    },
}

return {
    config,
    "Swap",
    {
        { "N", "n", "v", "V" },
        { "w", "H", "J", "K", "L" },
    },
    { "s", "S", "k", "j" },
    6,
    3,
    1,
}
