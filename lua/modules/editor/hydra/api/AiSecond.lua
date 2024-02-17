local leader = ";a"
local visual_mode = require("modules.editor.hydra.hydra_utils").visual_mode
local IS_DEV = false
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

local copilot = {
    -- Code related commands
    { "e", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
    { "t", "<cmd>CopilotChatTests<cr>", desc = "Generate tests" },
    { "r", "<cmd>CopilotChatReview<cr>", desc = "Review code" },
    { "R", "<cmd>CopilotChatRefactor<cr>", desc = "Refactor code" },
    { "f", "<cmd>CopilotChatFixCode<cr>", desc = "Fix code" },
    { "b", "<cmd>CopilotChatBetterNamings<cr>", desc = "Better Name" },
    { "d", "<cmd>CopilotChatDocumentation<cr>", desc = "Add documentation for code" },
    -- Text related commands
    { "s", "<cmd>CopilotChatSummarize<cr>", desc = "Summarize text" },
    { "S", "<cmd>CopilotChatSpelling<cr>", desc = "Correct spelling" },
    { "w", "<cmd>CopilotChatWording<cr>", desc = "Improve wording" },
    { "c", "<cmd>CopilotChatConcise<cr>", desc = "Make text concise" },
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
    { "D", "<cmd>CopilotChatDebugInfo<cr>", desc = "Debug Info" },
}
local copilot_vis = {
    {
        "v",
        ":CopilotChatVisual",
        mode = "x",
        desc = "Open in vertical split",
    },
    {
        "x",
        "CopilotChatInPlace<cr>",
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
        mode = "n",
        desc = "AI Assistant",
    },

    {
        "d",
        function()
            local line = vim.fn.getline(".")
            local start = vim.fn.col(".")
            local finish = vim.fn.col("$")
            local text = line:sub(start, finish)
            vim.fn.setreg('"', text)
            vim.cmd([[CodyTask 'Write document for current context']])
        end,
        mode = "n",
        desc = "Generate Document with AI",
    },

    {
        "c",
        ':CodyTask ""<Left>',
        mode = "n",
        desc = "Let AI Write Code",
    },

    {
        "a",
        ":CodyTaskAccept<CR>",
        mode = "n",
        desc = "Confirm AI work",
    },

    {
        "s",
        function()
            require("sg.extensions.telescope").fuzzy_search_results()
        end,
        mode = "n",
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
        a = {
            function() end,
            { nowait = true, silent = true, desc = "Cody", exit = true },
        },
        w = {
            function() end,
            { nowait = true, silent = true, desc = "Copilot", exit = true },
        },
        A = {
            function()
                local esc = vim.api.nvim_replace_termcodes("<space>a", true, true, true)
                vim.api.nvim_feedkeys(esc, "v", false)
            end,
            { nowait = true, silent = true, desc = "AI Hydra", exit = true },
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
    2,
}

local internal_copilot = {
    {
        Copilot = {
            color = "red",
            mode = { "n", "v", "x" },
            position = "bottom-right",
            ["<ESC>"] = { nil, { exit = true } },
        },
    },
    "Copilot",
    { copilot_visual_binds },
    copilot_normal_binds,
    6,
    4,
    2,
}

for _, v in ipairs(cody_normal) do
    if type(v[2]) == "string" then
        internal_config[1].Cody[v[1]] = {
            function()
                vim.cmd(v[2])
            end,

            {
                mode = v.mode,
                desc = v.desc,
                exit = true,
            },
        }
    else
        internal_config[1].Cody[v[1]] = {
            function()
                v[2]()
            end,
            {
                mode = v.mode,
                desc = v.desc,
                exit = true,
            },
        }
    end
end
-- Visual mode
for _, v in ipairs(cody_visual) do
    internal_config[1].Cody[v[1]] = {
        function()
            visual_mode(v[2])
        end,
        {
            mode = v.mode,
            desc = v.desc,
            nowait = true,
            exit = true,
        },
    }
end

for _, v in ipairs(copilot) do
    internal_copilot[1].Copilot[v[1]] = {
        function()
            vim.cmd(v[2])
        end,
        {
            mode = v.mode,
            desc = v.desc,
            exit = true,
        },
    }
end

for _, v in ipairs(copilot_vis) do
    internal_copilot[1].Copilot[v[1]] = {
        function()
            vim.cmd(v[2])
        end,
        {
            mode = v.mode,
            desc = v.desc,
            exit = true,
        },
    }
end

return {
    config, --1
    "AI", --2
    { { "<ESC>" } }, -- keymaps, for keymap plugin --3
    { "a", "w", "A" }, --4
    6, --5
    3, --6
    1, --7
    { internal_config, internal_copilot }, --8
}
