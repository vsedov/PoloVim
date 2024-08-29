local ai = require("core.pack").package
local conf = require("modules.ai.config")
local ai_conf = lambda.config.ai
local prompts = {
    -- Code related prompts
    Explain = "Please explain how the following code works.",
    Review = "Please review the following code and provide suggestions for improvement.",
    Tests = "Please explain how the selected code works, then generate unit tests for it.",
    Refactor = "Please refactor the following code to improve its clarity and readability.",
    FixCode = "Please fix the following code to make it work as intended.",
    BetterNamings = "Please provide better names for the following variables and functions.",
    Documentation = "Please provide documentation for the following code.",
    SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
    SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
    -- Text related prompts
    Summarize = "Please summarize the following text.",
    Spelling = "Please correct any grammar and spelling errors in the following text.",
    Wording = "Please improve the grammar and wording of the following text.",
    Concise = "Please rewrite the following text to make it more concise.",
}

return {

    {
        "ChatGPT.nvim",
        cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
        after = function()
            conf.chatgpt()
        end,
    },

    {
        "ai.vim",
        cmd = { "AI" },
        beforeAll = function()
            vim.g.ai_completions_model = "gpt-4"
            vim.g.ai_no_mappings = 1 -- disbale default mappings
        end,
    },

    -- <C-c> to close chat window.
    -- <C-u> scroll up chat window.
    -- <C-d> scroll down chat window.
    -- <C-y> to copy/yank last answer.
    -- <C-o> Toggle settings window.
    -- <C-n> Start new session.
    -- <Tab> Cycle over windows.tr
    -- <C-i> [Edit Window] use response as input.

    {
        "copilot.vim",
        enabled = ai_conf.sell_your_soul and not ai_conf.use_lua_copilot,
        event = "InsertEnter",
        after = function()
            vim.g.copilot_no_tab_map = true
        end,
    },

    {
        "copilot.lua",
        enabled = ai_conf.sell_your_soul and ai_conf.use_lua_copilot,
        event = "InsertEnter",
        after = function()
            opts = {
                panel = {
                    enabled = true,
                    auto_refresh = true,
                    keymap = { open = "<M-CR>" },
                    layout = { position = "right", ratio = 0.4 },
                },

                suggestion = {
                    auto_trigger = lambda.config.ai.copilot.autotrigger,
                    keymap = { accept = "<c-l>" },
                },

                filetypes = {
                    gitcommit = false,
                    NeogitCommitMessage = false,
                    DressingInput = false,
                    TelescopePrompt = false,
                    ["neo-tree-popup"] = false,
                    ["dap-repl"] = false,
                },
            }
            require("copilot").setup(opts)
        end,
    },
    {
        "sg.nvim",
        enabled = lambda.config.lsp.use_sg,
        event = "DeferredUIEnter",
        build = "nvim -l build/init.lua",
        cmd = {
            "SourcegraphBuild",
            "SourcegraphDownloadBinaries",
            "SourcegraphInfo",
            "SourcegraphLink",
            "SourcegraphLogin",
            "SourcegraphSearch",
            "CodyDo",
            "CodyChat",
            "CodyToggle",
            "CodyTaskNext",
            "CodyTaskView",
            "CodyAsk",
            "CodyTask",
            "CodyRestart",
            "CodyTaskPrev",
            "CodyTaskAccept",
        },
        after = function()
            require("sg").setup({
                enable_cody = true,
                accept_tos = true,
                download_binaries = true,
                on_attach = true,
            })
        end,
    },
    {
        "avante.nvim",
        event = "DeferredUIEnter",
        after = function()
            local opts = {
                ---@alias Provider "openai" | "claude" | "azure"
                provider = "openai", -- "claude" or "openai" or "azure"
                openai = {
                    endpoint = "https://api.openai.com",
                    model = "gpt-4o",
                    temperature = 0,
                    max_tokens = 10096,
                },
                azure = {
                    endpoint = "", -- example: "https://<your-resource-name>.openai.azure.com"
                    deployment = "", -- Azure deployment name (e.g., "gpt-4o", "my-gpt-4o-deployment")
                    api_version = "2024-06-01",
                    temperature = 0,
                    max_tokens = 4096,
                },
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-3-5-sonnet-20240620",
                    temperature = 0,
                    max_tokens = 4096,
                },
                highlights = {
                    ---@type AvanteConflictHighlights
                    diff = {
                        current = "DiffText",
                        incoming = "DiffAdd",
                    },
                },
                mappings = {
                    ask = ";aa",
                    edit = ";ae",
                    refresh = ";ar",
                    --- @class AvanteConflictMappings
                    diff = {
                        ours = "co",
                        theirs = "ct",
                        none = "c0",
                        both = "cb",
                        next = "]x",
                        prev = "[x",
                    },
                    jump = {
                        next = "]]",
                        prev = "[[",
                    },
                },
                windows = {
                    wrap_line = true,
                    width = 30, -- default % based on available width
                },
                --- @class AvanteConflictUserConfig
                diff = {
                    debug = false,
                    autojump = true,
                    ---@type string | fun(): any
                    list_opener = "copen",
                },
            }
            require("avante").setup(opts)
        end,
    },
}
