local leader = "<leader>S"
local internal = {}
local leaders = {}
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local config = {
    Tabnine = {
        color = "red",
        mode = { "x", "n", "v" },
        body = leader,

        ["<ESC>"] = { nil, { exit = true } },
    },
}

-- a = {
--     function()
--         require("tabnine.chat").open()
--     end,
--     { desc = "TN: Chat", nowait = true, silent = true, exit = true },
-- },
-- s = { cmd("TabnineStatus"), { desc = "TN: Status", nowait = true, silent = true, exit = true } },
-- w = { cmd("TabnineHubUrl"), { desc = "TN: Hub", nowait = true, silent = true, exit = true } },
-- ["<leader>"] = { cmd("TabnineToggle"), { desc = "TN: Toggle", nowait = true, silent = true } },

if lambda.config.ai.sell_your_soul and not lambda.config.ai.tabnine.use_tabnine then
    new_data = {
        --     { "<leader>ccc", ":CopilotChat ", desc = "CopilotChat - Prompt" },
        --     { "<leader>cce", ":CopilotChatExplain ", desc = "CopilotChat - Explain code" },
        --     { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
        --     { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
        --     { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
        s = {
            function()
                local input = vim.fn.input("Ask Copilot: ")
                if input ~= "" then
                    vim.cmd("CopilotChat " .. input)
                end
            end,
            { desc = "Prompt", mode = { "n", "v", "x" } },
        },
        E = { cmd("CopilotChatExplain"), { desc = "Explain code", mode = { "n", "v", "x" } } },
        T = { cmd("CopilotChatTests"), { desc = "Generate tests", mode = { "n", "v", "x" } } },
        R = { cmd("CopilotChatReview"), { desc = "Review code", mode = { "n", "v", "x" } } },
        r = { cmd("CopilotChatRefactor"), { desc = " Refactor code", mode = { "n", "v", "x" } } },
    }
    internal = { "T", "R", "r" }
    leaders = { "s", "E" }

    for k, v in pairs(new_data) do
        config.Tabnine[k] = v
    end
end

-- keys = {
-- },

return {
    config,
    "Tabnine",
    { internal },
    leaders,
    6,
    3,
}
