local leader = ";p"
local config = {
    Python = {
        color = "pink",
        body = leader,
        mode = { "n", "x", "v" },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        ["<cr>"] = {
            ":<C-u>MoltenEvaluateVisual<CR>",
            { desc = "Evaluate visual selection", mode = "v" },
        },

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
        n = {
            "<CMD>MoltenNext<CR>",
            { desc = "Goto next cell" },
        },
        N = {
            "<CMD>MoltenPrev<CR>",
            { desc = "Goto prev cell" },
        },
        S = {

            function()
                -- Always Do this
                vim.cmd([[UpdateRemotePlugins]])

                local venv = os.getenv("VIRTUAL_ENV")
                if venv ~= nil then
                    venv = string.match(venv, "/.+/(.+)")
                    vim.cmd(("MoltenInit %s"):format(venv))
                else
                    vim.cmd("MoltenInit python3")
                end
            end,

            { desc = "Initialize Molten for python3", silent = true, noremap = true },
        },
    },
}

return {
    config,
    "Python",
    { { "n", "N" } },
    { "S", "<cr>", "e", "l", "d", "r", "s", "h" },
    6,
    3,
    1,
}
