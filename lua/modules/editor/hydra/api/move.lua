local leader = "<leader><leader>m"

local bracket = { "H", "J", "K", "L" }
-- Executes '<Plug>GoNMLineLeft based commands

-- vim.cmd([[
-- nmap <S-h> <Plug>GoNSMLeft
-- nmap <S-j> <Plug>GoNSMDown
-- nmap <S-k> <Plug>GoNSMUp
-- nmap <S-l> <Plug>GoNSMRight
--
--
-- xmap <S-h> <Plug>GoVSMLeft
-- xmap <S-j> <Plug>GoVSMDown
-- xmap <S-k> <Plug>GoVSMUp
-- xmap <S-l> <Plug>GoVSMRight
--
-- nmap <C-h> <Plug>GoNSDLeft
-- nmap <C-j> <Plug>GoNSDDown
-- nmap <C-k> <Plug>GoNSDUp
-- nmap <C-l> <Plug>GoNSDRight
--
-- xmap <C-h> <Plug>GoVSDLeft
-- xmap <C-j> <Plug>GoVSDDown
-- xmap <C-k> <Plug>GoVSDUp
-- xmap <C-l> <Plug>GoVSDRight
-- ]])

local config = {
    Move = {
        color = "pink",
        body = leader,
        mode = { "n", "x" },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },

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
    "Move",
    { { "<c-h>", "<c-j>", "<c-k>", "<c-l>" } },
    bracket,
    6,
    3,
}
