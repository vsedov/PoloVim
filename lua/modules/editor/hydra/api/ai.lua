local leader = "<leader>A"
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
            -- if item contains Prompt then use vim.ui.input
        elseif commands_table[item]:find("Prompt") then
            vim.ui.input(commands_table[item], function(prompt)
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
        ["<ESC>"] = { nil, { exit = true, desc = "exit" } },

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
            { exit = true, desc = "NeoAI Toggle" },
        },
        e = {
            function()
                vim.cmd([[NeoAIContext]])
            end,
            { exit = true, desc = "NeoAI Context" },
        },
        d = {
            function()
                vim.cmd([[NeoAIContextOpen]])
            end,
            { exit = true, desc = "NeoAI Context Open" },
        },
        i = {
            function()
                --  TODO: (vsedov) (21:29:08 - 22/06/23): arguments required
                vim.ui.input("NeoAI Inject: ", function(prompt)
                    vim.cmd("NeoAIInject " .. prompt)
                end)
            end,
            { exit = true, desc = "NeoAI Inject" },
        },
        I = {
            function()
                vim.ui.input("NeoAI Inject Code: ", function(prompt)
                    vim.cmd("NeoAIInjectCode " .. prompt)
                end)
            end,
            { exit = true, desc = "NeoAI Inject Code" },
        },
        S = {
            function()
                vim.ui.input("NeoAI Inject Context: ", function(prompt)
                    vim.cmd("NeoAIInjectContext " .. prompt)
                end)
            end,
            { exit = true, desc = "NeoAI Inject Context" },
        },
        s = {
            function()
                vim.ui.input("NeoAI Inject Context Code: ", function(prompt)
                    vim.cmd("NeoAIInjectContextCode " .. prompt)
                end)
            end,
            { exit = true, desc = "NeoAI Inject Context Code" },
        },
        X = {
            function()
                vim.cmd([[NeoAIContextClose]])
            end,
            { exit = true, desc = "NeoAI Inject ContextClose" },
        },
        x = {
            function()
                vim.cmd([[NeoAIClose]])
            end,
            { exit = true, desc = "NeoAI Close" },
        },

        g = {
            function()
                vim.cmd([[NeoAIShortcut gitcommit]])
            end,
            { exit = true, desc = "NeoAI Shortcut gitcommit" },
        },
        w = {
            function()
                vim.cmd([[NeoAIShortcut textify]])
            end,
            { exit = true, desc = "NeoAI Shortcut textify" },
        },

        --  ╭────────────────────────────────────────────────────────────────────╮
        --  │         CHATGPT Plugin                                             │
        --  ╰────────────────────────────────────────────────────────────────────╯
        G = {
            function()
                vim.cmd([[ChatGPT]])
            end,
            { exit = true, desc = "Chat with GPT-3" },
        },
        A = {
            function()
                vim.cmd([[ChatGPTActAs]])
            end,
            { exit = true, desc = "Chat with run as" },
        },
        R = {
            function()
                vim.cmd([[ChatGPTRun]])
            end,
            { exit = true, desc = "Chat with run as" },
        },
        E = {
            function()
                vim.cmd([[ChatGPTEditWithInstructions]])
            end,
            { exit = true, desc = "Chatgpt edit instructions" },
        },
        C = {
            function()
                vim.cmd([[ChatGPTCompleteCode]])
            end,
            { exit = true, desc = "Chat  Complete code" },
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
            { exit = true, desc = "AI" },
        },
        ["-"] = {
            function()
                local ask = vim.fn.input("Ask: ")
                vim.cmd("AI " .. ask)
            end,
            { exit = true, desc = "AI" },
        },
    },
}
local brackets = { "<cr>", "o", "e", "d", "i", "I", "S", "s", "X", "x" }
local inner = { { "g", "w" }, { "G", "A", "R", "E", "C" }, { ";", "-" } }
return {
    config,
    "AI",
    inner,
    brackets,
    6,
    3,
}
