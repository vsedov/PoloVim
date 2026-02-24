local leader = "\\w"
local Molten = {
    Molten = {
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

local core = {
    Molten,
    "Molten",
    { { "n", "N" } },
    { "S", "<cr>", "e", "l", "d", "r", "s", "h" },
    6,
    3,
    1,
}
local config = {
    Python = {
        body = leader,
        ["<ESC>"] = { nil, { exit = true } },
        mode = { "n", "v", "x" },
        -- "PythonCopyReferenceDotted",
        -- "PythonCopyReferencePytest",
        -- "PythonCopyReferenceImport",

        -- ["<cr>"] = {
        --     function()
        --
        --     end,
        --     { nowait = true, silent = true, desc = "Cody", exit = true },
        -- },

        D = {
            function()
                vim.cmd("PythonCopyReferenceDotted")
            end,
            { nowait = true, silent = true, desc = "Reference Dot" },
        },
        p = {
            function()
                vim.cmd("PythonCopyReferencePytest")
            end,
            { nowait = true, silent = true, desc = "Reference Pytest" },
        },
        P = {
            function()
                vim.cmd("PythonCopyReferenceImport")
            end,
            { nowait = true, silent = true, desc = "Reference Import" },
        },

        w = {
            function()
                if vim.fn.expand("%:e") == "py" then
                    os.execute("auto-walrus " .. vim.fn.expand("%:p"))
                end
            end,
            { nowait = true, silent = true, desc = "Auto Walrus" },
        },
        m = {
            function() end,
            { nowait = true, silent = true, desc = "Molten", exit = true },
        },
    },
}

return {
    config, --1
    "Python", --2
    { { "m", "<ESC>" } }, -- keymaps, for keymap plugin --3
    { "w", "D", "P", "p" }, --4
    6, --5
    3, --6
    1, --7
    { core }, --8
}
