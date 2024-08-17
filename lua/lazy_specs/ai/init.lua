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
        after = conf.chatgpt,
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

    --  TODO: (vsedov) (14:41:51 - 12/02/24): Create a hydra for this
    --  Something like <leader>A -> C All binds ?
    --  or perhaps <leader>cc Hydra could also work
    {
        "CopilotChat.nvim",
        opt = true,
        after = function()
            opts = {
                show_help = "yes",
                debug = false, -- Set to true to see response from Github Copilot API. The log file will be in ~/.local/state/nvim/CopilotChat.nvim.log.
                disable_extra_info = "no", -- Disable extra information (e.g: system prompt, token count) in the response.
                allow_insecure = false,
                prompts = prompts,
            }
            require("copilotchat").setup(opts)
        end,
        cmd = {
            "CopilotChat",
            "CopilotChatOpen",
            "CopilotChatClose",
            "CopilotChatToggle",
            "CopilotChatReset",
            "CopilotChatSave",
            "CopilotChatLoad",
            "CopilotChatDebugInfo",
            "CopilotChatExplain",
            "CopilotChatReview",
            "CopilotChatFix",
            "CopilotChatOptimize",
            "CopilotChatDocs",
            "CopilotChatTests",

            "CopilotChatFixDiagnostic",
            "CopilotChatCommit",
            "CopilotChatCommitStaged",
        },
        keys = {

            -- Quick chat with Copilot
            {
                "<leader>ccq",
                function()
                    local input = vim.fn.input("Quick Chat: ")
                    if input ~= "" then
                        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
                    end
                end,
                desc = "CopilotChat - Quick chat",
            },
            -- lazy.nvim keys

            -- Show help actions with telescope
            {
                "<leader>cch",
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.help_actions())
                end,
                desc = "CopilotChat - Help actions",
            },
            -- Show prompts actions with telescope
            {
                "<leader>ccp",
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
                end,
                desc = "CopilotChat - Prompt actions",
            },
        },
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

    -- <C-s> - Save the buffer and trigger a response from the generative AI service
    -- <C-c> - Close the buffer
    -- q - Cancel the stream from the API
    -- gc - Clear the buffer's contents
    -- ga - Add a codeblock
    -- gs - Save the chat to disk
    -- [ - Move to the next header
    -- ] - Move to the previous header

    {
        "codecompanion.nvim",
        after = function()
            require("codecompanion").setup({
                adapters = {
                    anthropic = require("codecompanion.adapters").use("anthropic", {
                        env = {
                            -- api_key = "ANTHROPIC_API_KEY_1",
                            api_key = os.getenv("CLAUDE"),
                        },
                        schema = {
                            model = {
                                default = "claude-3-sonnet-20240229",
                            },
                        },
                    }),
                },
                strategies = {
                    chat = "anthropic",
                    inline = "anthropic",
                    tool = "anthropic",
                },
            })
        end,
        keys = {
            {
                ";aa",
                ":CodeCompanionActions<cr>",
                mode = { "n", "v" },
            },
            {
                ";at",
                ":CodeCompanionToggle<cr>",
                mode = { "n", "v" },
            },
            {
                "ga",
                ":CodeCompanionAdd<cr>",
                mode = "v",
            },

            {
                ";ac",
                ":CodeCompanion",
                mode = "c",
            },
            {
                ";acb",
                ":CodeCompanionWithBuffers",
                mode = "c",
            },
        },
    },
}
