---@diagnostic disable: redefined-local
local leader = "<leader>a"
local utils = require("modules.editor.hydra.repl_utils")
local run_cmd_with_count = utils.run_cmd_with_count

--  TODO: (vsedov) (21:07:52 - 22/06/23): Some of this in inject so you have to give a prompt, il
--  need to create a filter for those commands and then parse those through . for this i think this
--  works though : Will need to come back to this for sure. I just needed more binds to work with
local commands_table = {
    NeoAI = "Open NeoAI Side Bar",
    NeoAIToggle = "Toggle NeoAI window and send optional [prompt]",
    NeoAIOpen = "Open NeoAI window with optional [prompt]",
    NeoAIClose = "Close NeoAI window",
    NeoAIContext = "Toggle NeoAI with context and optional [prompt]",
    NeoAIContextOpen = "Open NeoAI with context and optional [prompt]",
    NeoAIContextClose = "Close NeoAI with context",
    NeoAIInject = "Inject AI response with [prompt] into buffer",
    NeoAIInjectCode = "Inject AI code response with [prompt]",
    NeoAIInjectContext = "Inject AI response with context and [prompt]",
    NeoAIInjectContextCode = "Inject AI code response with context and [prompt]",
    NeoAIShortcut = "Trigger NeoAI shortcut using its name",
}

local core_table = {}
for i, v in pairs(commands_table) do
    table.insert(core_table, i)
end

local neoai_commands = function()
    vim.ui.select(core_table, {
        prompt = "NeoAI Commands:",
        format_item = function(entry, _)
            return string.format("%s ->  %s", entry, commands_table[entry])
        end,
    }, function(item)
        if item == "NeoAIShortcut" then
            vim.ui.select({ "textify", "gitcommit" }, {
                prompt = "NeoAI Shortcuts:",
            }, function(inner_item)
                vim.cmd(item .. " " .. inner_item)
            end)
        elseif commands_table[item]:find("prompt") then
            vim.ui.input({ prompt = commands_table[item], default = "" }, function(prompt)
                vim.cmd(item .. " " .. prompt)
            end)
        else
            vim.cmd(item)
        end
    end)
end

local config = {
    AI = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x" },
        ["<ESC>"] = { nil, { nowait = true, exit = true, desc = "exit" } },

        --  ╭────────────────────────────────────────────────────────────────────╮
        --  │         NEOAI Plugin                                               │
        --  ╰────────────────────────────────────────────────────────────────────╯
        ["<cr>"] = {
            function()
                neoai_commands()
            end,
            { nowait = true, exit = true, desc = "NeoAI Commands" },
        },
        o = {
            function()
                vim.cmd([[NeoAIOpen]])
            end,
            { nowait = true, exit = true, desc = "NeoAI Toggle" },
        },
        e = {
            function()
                vim.cmd([[NeoAIContext]])
            end,
            { nowait = true, exit = true, desc = "NeoAI Context" },
        },
        O = {
            function()
                vim.cmd([[NeoAIContextOpen]])
            end,
            { nowait = true, exit = true, desc = "NeoAI Context Toggle" },
        },
        i = {
            function()
                vim.ui.input("NeoAI Inject: ", function(prompt)
                    vim.cmd("NeoAIInject " .. prompt)
                end)
            end,
            { nowait = true, exit = true, desc = "NeoAI Inject" },
        },
        I = {
            function()
                vim.ui.input("NeoAI Inject Code: ", function(prompt)
                    vim.cmd("NeoAIInjectCode " .. prompt)
                end)
            end,
            { nowait = true, exit = true, desc = "NeoAI Inject Code" },
        },
        w = {
            function()
                vim.ui.input("NeoAI Inject Context: ", function(prompt)
                    vim.cmd("NeoAIInjectContext " .. prompt)
                end)
            end,
            { nowait = true, exit = true, desc = "NeoAI Inject Context" },
        },
        W = {
            function()
                vim.ui.input("NeoAI Inject Context Code: ", function(prompt)
                    vim.cmd("NeoAIInjectContextCode " .. prompt)
                end)
            end,
            { nowait = true, exit = true, desc = "NeoAI Inject Context Code" },
        },
        X = {
            function()
                vim.cmd([[NeoAIContextClose]])
            end,
            { nowait = true, exit = true, desc = "NeoAI Inject ContextClose" },
        },
        x = {
            function()
                vim.cmd([[NeoAIClose]])
            end,
            { nowait = true, exit = true, desc = "NeoAI Close" },
        },

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
        S = {
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

local brackets = { "<cr>", "O", "o", "e", "i", "I", "w", "W", "x", "X" }
local inner = {
    { "g", "<leader>", "B", "b", "L" },
    { "j", "k", "l", "a", "r" },
    { "S", "s", "f", "h", "C", "c" },
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
