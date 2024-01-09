local config = {
    Multi = {
        color = "red",
        body = "<leader>m",
        mode = { "n", "v" },
        position = "bottom-right",

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
    {
        { "<c-h>", "<c-j>", "<c-k>", "<c-l>" },
    },
    { "H", "J", "K", "L" },
}
