local leader_key = "<leader>B"
local config = {
    Tab = {
        color = "blue",
        body = leader_key,
        mode = { "n" },
        n = {
            function()
                vim.cmd("tabnew")
            end,
            { desc = "New tab", exit = true },
        },
        c = {
            function()
                vim.cmd("tabclose")
            end,
            { desc = "Close tab", exit = true },
        },
        C = {
            function()
                vim.ui.input({ prompt = "Close tab:", default = "1" }, function(idx)
                    idx = idx and tonumber(idx)
                    if idx then
                        vim.cmd("tabclose " .. idx)
                    end
                end)
            end,
            { desc = "Close tab", exit = true },
        },
        l = {
            function()
                vim.cmd("tabnext")
            end,
            { desc = "Next tab", exit = false },
        },
        h = {
            function()
                vim.cmd("tabprev")
            end,
            { desc = "Previous tab", exit = false },
        },
        f = {
            function()
                vim.cmd("tabfirst")
            end,
            { desc = "First tab", exit = false },
        },
        L = {
            function()
                vim.cmd("tablast")
            end,
            { desc = "Last tab", exit = false },
        },
        m = {
            function()
                vim.ui.input({ prompt = "Move tab to:" }, function(idx)
                    idx = idx and tonumber(idx)
                    if idx then
                        vim.cmd("tabmove " .. idx)
                    end
                end)
            end,
            { desc = "Move tab", exit = true },
        },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
    },
}

return {
    config,
    "Tab",
    {
        { "f", "L", "m" },
    },
    { "n", "C", "c", "l", "h" },
    6,
    3,
}
