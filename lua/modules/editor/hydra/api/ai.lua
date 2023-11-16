---@diagnostic disable: redefined-local
local leader = "<leader>a"
local run_cmd_with_count = require("modules.editor.hydra.repl_utils").run_cmd_with_count

local config = {
    AI = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x" },
        ["<ESC>"] = { nil, { nowait = true, exit = true, desc = "exit" } },

        g = {
            function()
                vim.cmd([[NeoAIShortcut gitcommit]])
            end,
            { nowait = true, exit = true, desc = "NeoAI Shortcut gitcommit" },
        },
        ["<leader>"] = {
            "<C-v>:NeoAIShortcut textify<cr>",
            { nowait = true, exit = true, desc = "NeoAI Shortcut textify" },
        },

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
            run_cmd_with_count("REPLStart aichat"),
            { nowait = true, desc = "Start an Aichat REPL", exit = true },
        },
        s = {
            run_cmd_with_count("REPLSendMotion aichat"),
            { nowait = true, desc = "Send current line to Aichat", exit = false },
        },

        f = {
            run_cmd_with_count("REPLFocus aichat"),
            { nowait = true, desc = "Focus on Aichat REPL", exit = true },
        },
        h = {
            run_cmd_with_count("REPLHide aichat"),
            { nowait = true, desc = "Hide Aichat REPL", exit = true },
        },
        C = {
            run_cmd_with_count("REPLClose aichat"),
            { nowait = true, desc = "Quit Aichat", exit = true },
        },
        c = {
            run_cmd_with_count("REPLCleanup"),

            { nowait = true, desc = "Clear aichat REPLs.", exit = true },
        },
    },
}

local brackets = { "j", "k", "l", "a", "r" }

-- { "<cr>", "O", "o", "e", "i", "I", "w", "W", "x", "X" }

local inner = {
    { "<cr>", "s", "f", "h", "C", "c" },
    { "g", "<leader>", "B", "b", "L" },
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
