local leader = "<leader>a"
local visual_mode = require("modules.editor.hydra.hydra_utils").run_visual_or_normal
get_visual_selection_rows = function()
    local start_row = math.min(vim.fn.getpos("v")[2], vim.fn.getpos(".")[2])
    local end_row = math.max(vim.fn.getpos("v")[2], vim.fn.getpos(".")[2])
    return start_row, end_row + 1
end
--- Get all the changes in the git repository
---@param staged? boolean
---@return string
local function get_git_diff(staged)
    local cmd = staged and "git diff --staged" or "git diff"
    local handle = io.popen(cmd)
    if not handle then
        return ""
    end

    local result = handle:read("*a")
    handle:close()
    return result
end
local aiextra = {
    {
        AI = {
            color = "red",
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
            --     { "<leader>cct", "CopilotChatTests", desc = "CopilotChat - Generate tests" },
            --     { "<leader>ccr", "CopilotChatReview", desc = "CopilotChat - Review code" },
            --     { "<leader>ccR", "CopilotChatRefactor", desc = "CopilotChat - Refactor code" },
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
                { nowait = true, exit = true, desc = "CopilotChat " },
            },
        },
    },

    "AI",
    {
        { "<cr>", "s", "f", "h", "C", "c" },
        { "B", "b", "L" },
        { ";", "-" },
    },
    { "j", "k", "l", "a", "r" },
    6,
    3,
}

local copilot = {
    -- Code related commands
    { "e", "y:CopilotChatExplain<cr>", desc = "Explain code", inline = true },
    { "t", "y:CopilotChatTests<cr>", desc = "Generate tests", inline = true },
    { "r", "y:CopilotChatReview<cr>", desc = "Review code", inline = true },
    { "R", "y:CopilotChatRefactor<cr>", desc = "Refactor code", inline = true },
    { "f", "y:CopilotChatFixCode<cr>", desc = "Fix code", inline = true },
    { "b", "y:CopilotChatBetterNamings<cr>", desc = "Better Name", inline = true },
    { "d", "y:CopilotChatDocumentation<cr>", desc = "Add documentation for code", inline = true },
    -- Text related commands
    { "s", "y:CopilotChatSummarize<cr>", desc = "Summarize text", inline = true },
    { "S", "y:CopilotChatSpelling<cr>", desc = "Correct spelling", inline = true },
    { "w", "y:CopilotChatWording<cr>", desc = "Improve wording", inline = true },
    { "c", "y:CopilotChatConcise<cr>", desc = "Make text concise", inline = true },

    -- Chat with Copilot in visual mode

    -- Custom input for CopilotChat
    {
        "i",
        function()
            local input = vim.fn.input("Ask Copilot: ")
            if input ~= "" then
                vim.cmd("CopilotChat " .. input)
            end
        end,
        desc = "Ask input",
    },
    -- Generate commit message base on the git diff
    {
        "m",
        function()
            local diff = get_git_diff()
            if diff ~= "" then
                vim.fn.setreg('"', diff)
                vim.cmd("CopilotChat Write commit message for the change with commitizen convention.")
            end
        end,
        desc = "Generate commit message for all changes",
    },
    {
        "M",
        function()
            local diff = get_git_diff(true)
            if diff ~= "" then
                vim.fn.setreg('"', diff)
                vim.cmd("CopilotChat Write commit message for the change with commitizen convention.")
            end
        end,
        desc = "Generate commit message for staged changes",
    },
    -- Debug
    { "D", "CopilotChatDebugInfo", desc = "Debug Info" },
}
local copilot_vis = {
    {
        "v",
        -- "CopilotChatVisual",
        function()
            local input = vim.fn.input("Ask Copilot: ")
            return "CopilotChatVisual " .. input
        end,
        mode = "x",
        desc = "Open in vertical split",
    },
    {
        "x",
        "CopilotChatInPlace",
        mode = "x",
        desc = "Run in-place code",
    },
}
local copilot_normal_binds = { "e", "t", "r", "R", "f", "b", "d", "s", "S", "w", "c", "i", "m", "M", "D" }
local copilot_visual_binds = { "v", "x" }

local cody_normal = {
    {
        "i",
        ":CodyChat<CR>",
        mode = { "n", "v" },
        desc = "AI Assistant",
        inline = true,
    },

    {
        "d",
        function()
            local buf = vim.api.nvim_get_current_buf()
            local start_row, end_row = get_visual_selection_rows()

            vim.ui.input({ prompt = "Task/Ask: " }, function(input)
                if input == nil or input == "" then
                    return
                end
                require("sg.cody.commands").do_task(buf, start_row, end_row, input)
            end)
        end,
        mode = { "n", "v" },
        desc = "Generate Document with AI",
    },

    {
        "c",
        ':CodyTask ""<Left>',
        mode = { "n", "v" },
        desc = "Let AI Write Code",
    },

    {
        "a",
        ":CodyTaskAccept<CR>",
        mode = { "n", "v" },
        desc = "Confirm AI work",
    },

    {
        "s",
        function()
            require("sg.extensions.telescope").fuzzy_search_results()
        end,
        mode = { "n", "v" },
        desc = "AI Search",
    },
}

local cody_visual = {
    { "w", "CodyAsk chat selected code", mode = "v", desc = "Chat Selected Code" },

    {
        "D",
        "CodyTask 'Write document for current context",
        mode = "v",
        desc = "Generate Document with AI",
    },

    {
        "r",
        -- "y:CodyChat<CR>refactor following code:<CR><ESC>p<CR>",
        "CodyTask refactor following code",
        mode = "v",
        desc = "Refactoring V",
    },

    {
        "e",
        -- "y:CodyChat<CR>explain following code:<CR><ESC>p<CR>",
        "CodyAsk explain following code",
        mode = "v",
        desc = "Explanation V",
    },

    {
        "f",
        "CodyAsk find potential vulnerabilities from following code",
        mode = "v",
        desc = "Potential Vulnerabilities V",
    },

    {
        "t",
        "CodyTask rewrite following code more idiomatically",
        mode = "v",
        desc = "Idiomatic Rewrite V",
    },
}
local cody_normal_binds = { "i", "d", "c", "a", "s" }
local cody_visual_binds = { "w", "D", "r", "e", "f", "t" }

local config = {
    AI = {
        color = "red",
        body = leader,
        ["<ESC>"] = { nil, { exit = true } },
        mode = { "n", "v", "x" },
        ["<cr>"] = {
            function() end,
            { nowait = true, silent = true, desc = "Cody", exit = true },
        },
        w = {
            function() end,
            { nowait = true, silent = true, desc = "Copilot", exit = true },
        },
        a = {
            function() end,
            { nowait = true, silent = true, desc = "AI", exit = true },
        },
    },
}

local internal_config = {
    {
        Cody = {
            color = "red",
            mode = { "n", "v", "x" },
            position = "bottom-right",
            ["<ESC>"] = { nil, { exit = true } },
        },
    },
    "Cody",
    { cody_visual_binds },
    cody_normal_binds,
    6,
    4,
    3,
}

local internal_copilot = {
    {
        Copilot = {
            color = "red",
            mode = { "n", "v", "x" },
            position = "bottom-right",
            on_enter = function()
                vim.cmd([[silent UpdateRemotePlugins]])
            end,
            ["<ESC>"] = { nil, { exit = true } },
        },
    },
    "Copilot",
    { copilot_visual_binds },
    copilot_normal_binds,
    6,
    4,
    3,
}

local function assign_commands(name, conf, commands, visual)
    for _, v in ipairs(commands) do
        local cmd = v[2]

        local action = type(cmd) == "string" and function()
            vim.cmd(cmd)
        end or cmd
        if visual then
            action = function()
                visual_mode(cmd)
            end
        end
        if v.inline then
            action = cmd
        end
        conf[1][name][v[1]] = {
            action,
            {
                mode = v.mode,
                desc = v.desc,
                nowait = visual or nil,
                exit = true,
            },
        }
    end
end

assign_commands("Cody", internal_config, cody_normal)
assign_commands("Cody", internal_config, cody_visual, true)
assign_commands("Copilot", internal_copilot, copilot, false)
assign_commands("Copilot", internal_copilot, copilot_vis, true)

return {
    config, --1
    "AI", --2
    { { "<ESC>" } }, -- keymaps, for keymap plugin --3
    { "<cr>", "w", "a" }, --4
    6, --5
    3, --6
    1, --7
    { internal_config, internal_copilot, aiextra }, --8
}
