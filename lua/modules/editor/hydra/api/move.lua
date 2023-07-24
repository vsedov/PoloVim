local config = {
    Multi = {
        color = "red",
        body = "<leader>m",
        mode = { "n", "v" },
        position = "bottom-right",
        m = {
            function()
                if vim.fn.mode() == "n" then
                    vim.cmd([[MCstart]])
                else
                    vim.cmd([[MCvisual]])
                end
            end,
            { exit = true, mode = { "n", "v" }, desc = "MC: Start" },
        },
        ["<cr>"] = {
            function()
                if vim.fn.mode() == "n" then
                    vim.cmd([[MCpattern]])
                else
                    vim.cmd([[MCvisualPattern]])
                end
            end,

            { exit = true, mode = { "n" }, desc = "MC: Pattern Match" },
        },
        w = {
            function()
                vim.cmd([[MCunderCursor]])
            end,

            { exit = true, mode = { "n" }, desc = "MC: Cursor Word" },
        },
        c = {
            function()
                vim.cmd([[MCclear]])
            end,

            { exit = true, mode = { "n" }, desc = "MC: Clear" },
        },
        H = {
            "<Plug>GoVSMLeft",
            { desc = "Move Left" },
        },

        J = {
            "<Plug>GoVSMDown",

            { desc = "Move Down" },
        },

        K = {
            "<Plug>GoVSMUp",
            { desc = "Move Up" },
        },
        L = {
            "<Plug>GoVSMRight",
            { desc = "Move Right" },
        },
        ["<c-h>"] = {
            "<Plug>GoVSDLeft",
            { desc = "Duplicate Left" },
        },
        ["<c-j>"] = {

            "<Plug>GoVSDDown",

            { desc = "Duplicate Down" },
        },
        ["<c-k>"] = {
            "<Plug>GoVSDUp",
            { desc = "Duplicate Up" },
        },
        ["<c-l>"] = {
            "<Plug>GoVSDRight",
            { desc = "Duplicate Right" },
        },
    },
}
return {
    config,
    "Multi",
    { { "H", "J", "K", "L" }, { "<c-h>", "<c-j>", "<c-k>", "<c-l>" } },

    { "w", "m", "<cr>", "c" },
}
