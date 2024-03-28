local visual_mode = require("modules.editor.hydra.hydra_utils").run_visual_or_normal
local api = vim.api
local leader = ";p"
local config = {
    Python = {
        color = "pink",
        body = leader,
        mode = { "n", "x", "v" },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        e = {
            "<CMD>MoltenEvaluateOperator<CR>",
            { desc = "Evaluate Operator" },
        },
        l = {
            "<CMD>MoltenEvaluateLine<CR>",
            { desc = "Evaluate Line" },
        },
        r = {
            "<CMD>MoltenReevaluateCell<CR>",
            { desc = "Re-evaluate cell" },
        },
        d = {
            "<CMD>MoltenDelete<CR>",
            { desc = "Delete cell" },
        },
        s = {
            "<CMD>MoltenEnterOutput<CR>",
            { desc = "Show/enter output window" },
        },

        h = {
            "<CMD>MoltenHideOutput<CR>",
            { desc = "Hide output window" },
        },
        ["n"] = {
            "<CMD>MoltenNext<CR>",
            { desc = "Goto next cell" },
        },
        ["N"] = {
            "<CMD>MoltenPrev<CR>",
            { desc = "Goto prev cell" },
        },
        ["<cr>"] = {
            ":<C-u>MoltenEvaluateVisual<CR>",
            { desc = "Evaluate visual selection", mode = "v" },
        },
    },
}

return {
    config,
    "Python",
    { { "n", "N" } },
    { "<cr>", "e", "l", "d", "r", "s", "h" },
    6,
    3,
    1,
}
