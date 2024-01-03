local config = {
    Multi = {
        color = "red",
        body = "<leader>m",
        mode = { "n", "v" },
        position = "bottom-right",

        -- "MCstart",
        -- "MCvisual",
        -- "MCpattern",
        -- "MCvisualPattern",
        -- "MCunderCursor",
        -- "MCclear",

        s = {
            "<cmd>MCstart<cr>",
            { desc = "Start" },
        },
        S = {
            "<cmd>MCvisual<cr>",
            { desc = "Start", mode = "v" },
        },
        ["<cr>"] = {
            function()
                local commands = {
                    "MCpattern",
                    "MCvisualPattern",
                    "MCunderCursor",
                    "MCclear",
                }

                -- vim.ui.select(commands, {
                --     prompt = "MultiMC Util",
                --     },
                --     on_select = function(selected)
                --         vim.cmd(selected)
                --     end)

                vim.ui.select(commands, {
                    prompt = "MultiMc Util",
                }, function(inner_item)
                    -- vim.cmd([[ChatGPTRun ]] .. inner_item)
                    vim.cmd(inner_item)
                end)
            end,
            { desc = "MultiMC Util", mode = { "v", "n", "x" }, exit = true, nowait = true },
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
    {
        { "H", "J", "K", "L" },
        { "<c-h>", "<c-j>", "<c-k>", "<c-l>" },
    },
    { "s", "S", "<cr>" },
}
