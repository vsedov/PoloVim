---@diagnostic disable: redefined-local
local leader = "<leader>a"
-- config = function()
--     -- nnoremap <space>ss <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>
--     vim.keymap.set(
--         "n",
--         "<leader>ss",
--         "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<cr>",
--         { desc = "Cody Fuzzy results" }
--     )
--     -- Toggle cody chat
--     vim.keymap.set("n", "<leader>sw", function()
--         require("sg.cody.commands").toggle()
--     end, { desc = "Cody Commands" })
--
--     vim.keymap.set("n", "<leader>cn", function()
--         local name = vim.fn.input("chat name: ")
--         require("sg.cody.commands").chat(name)
--     end, { desc = "Cody Commands" })
--     vim.keymap.set("v", "<leader>A", ":CodyContext<CR>", { desc = "Cody Context" })
--     vim.keymap.set("v", "<space>w", ":CodyExplain<CR>", { desc = "Cody Explain" })
--     vim.keymap.set("n", "<space>ss", function()
--         require("sg.extensions.telescope").fuzzy_search_results()
--     end, { desc = "Sg Extension tele" })
-- end,

local config = {
    AI = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x" },
        ["<ESC>"] = { nil, { nowait = true, exit = true, desc = "exit" } },

        --  ╭────────────────────────────────────────────────────────────────────╮
        --  │         CHATGPT Plugin                                             │
        --  ╰────────────────────────────────────────────────────────────────────╯
        j = {
            function()
                vim.cmd([[ChatGPT]])
            end,
            { nowait = true, exit = true, desc = "Chat with GPT-4" },
        },
        a = {
            function()
                vim.cmd([[ChatGPTActAs]])
            end,
            { nowait = true, exit = true, desc = "Chat with Act as" },
        },
        r = {
            function()
                local options = {
                    "fix_bugs",
                    "keywords",
                    "add_tests",
                    "docstring",
                    "summarize",
                    "translate",
                    "explain_code",
                    "roxygen_edit",
                    "complete_code",
                    "optimize_code",
                    "grammar_correction",
                    "code_readability_analysis",
                }
                vim.ui.select(options, {
                    prompt = "Chat with run as:",
                }, function(inner_item)
                    vim.cmd([[ChatGPTRun ]] .. inner_item)
                end)
            end,
            { nowait = true, exit = true, desc = "Chat with run as" },
        },
        k = {
            function()
                vim.cmd([[ChatGPTEditWithInstructions]])
            end,
            { nowait = true, exit = true, desc = "Chatgpt edit instructions" },
        },
        l = {
            function()
                vim.cmd([[ChatGPTCompleteCode]])
            end,
            { nowait = true, exit = true, desc = "Chat  Complete code" },
        },
        B = {
            function()
                vim.cmd([[Backseat]])
            end,
            { nowait = true, exit = true, desc = "Backseat" },
        },
        b = {
            function()
                vim.ui.input({ prompt = "Enter Backseat ask: " }, function(question)
                    vim.cmd([[BackseatAsk ]] .. question)
                end)
            end,
            { nowait = true, exit = true, desc = "Backseat Ask" },
        },
        L = {
            function()
                vim.cmd([[BackseatClear]])
            end,
            { nowait = true, exit = true, desc = "Backseat Clear" },
        },

        --  ╭────────────────────────────────────────────────────────────────────╮
        --  │         Other AI PLugins                                           │
        --  ╰────────────────────────────────────────────────────────────────────╯
        [";"] = {
            function()
                vim.cmd(
                    [[AI fix grammar and spelling and replace slang and contractions with a formal academic writing style.]]
                )
            end,
            { nowait = true, exit = true, desc = "AI: Fix grammar " },
        },
        ["-"] = {
            function()
                local ask = vim.fn.input("Ask: ")
                vim.cmd("AI " .. ask)
            end,
            { nowait = true, exit = true, desc = "AI: Ask - writes in buffer" },
        },
        ["<cr>"] = {
            function()
                vim.cmd("REPLStart aichat")()
            end,
            { nowait = true, desc = "Start an Aichat REPL", exit = true },
        },
        s = {
            function()
                vim.cmd("REPLSendMotion aichat")()
            end,
            { nowait = true, desc = "Send current line to Aichat", exit = false },
        },

        f = {
            function()
                vim.cmd("REPLFocus aichat")()
            end,
            { nowait = true, desc = "Focus on Aichat REPL", exit = true },
        },
        h = {
            function()
                vim.cmd("REPLHide aichat")()
            end,
            { nowait = true, desc = "Hide Aichat REPL", exit = true },
        },
        C = {
            function()
                vim.cmd("REPLClose aichat")()
            end,
            { nowait = true, desc = "Quit Aichat", exit = true },
        },
        c = {
            function()
                vim.cmd("REPLCleanup")()
            end,

            { nowait = true, desc = "Clear aichat REPLs.", exit = true },
        },
        -- keys = {
        --     { "<leader>ccc", ":CopilotChat ", desc = "CopilotChat - Prompt" },
        --     { "<leader>cce", ":CopilotChatExplain ", desc = "CopilotChat - Explain code" },
        --     { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
        --     { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
        --     { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
        -- },
        K = {
            function()
                local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
                local modes = { "v", "V", "x" }
                if vim.tbl_contains(modes, mode) then
                    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
                    vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode
                    vim.cmd("'<,'>CopilotChatVisual Explain this code")
                else
                    vim.cmd("CopilotChat")
                end
            end,
            { nowait = true, exit = true, desc = "Cody Explain" },
        },
    },
}

local brackets = { "j", "k", "l", "a", "r" }

-- { "<cr>", "O", "o", "e", "i", "I", "w", "W", "x", "X" }

local inner = {
    { "<cr>", "s", "f", "h", "C", "c" },
    { "B", "b", "L" },
    { ";", "-" },
}

return {
    config,
    "AI",
    inner,
    brackets,
    6,
    3,
}
