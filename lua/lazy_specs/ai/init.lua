ai_conf = lambda.config.ai
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
        keys = {
            {
                "<leader>ip",
                function()
                    return vim.bo.filetype == "AvanteInput" and require("avante.clipboard").paste_image()
                        or require("img-clip").paste_image()
                end,
                desc = "clip: paste image",
            },
        },
        after = function()
            rocks.safe_force_packadd({ "nvim-web-devicons", "plenary.nvim", "render-markdown.nvim" })

            local opts = {
                ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
                provider = "claude", -- Recommend using Claude
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-3-5-sonnet-20240620",
                    temperature = 0,
                    max_tokens = 10096,
                },
                mappings = {
                    diff = {
                        ours = "co",
                        theirs = "ct",
                        all_theirs = "ca",
                        both = "cb",
                        cursor = "cc",
                        next = "]x",
                        prev = "[x",
                    },
                    jump = {
                        next = "]]",
                        prev = "[[",
                    },
                    submit = {
                        normal = "<CR>",
                        insert = "<C-s>",
                    },
                },
                hints = { enabled = true },
                windows = {
                    wrap = true, -- similar to vim.o.wrap
                    width = 40, -- default % based on available width
                    sidebar_header = {
                        align = "center", -- left, center, right for title
                        rounded = true,
                    },
                },
                highlights = {
                    diff = {
                        current = "DiffText",
                        incoming = "DiffAdd",
                    },
                },
                diff = {
                    autojump = true,
                    list_opener = "copen",
                },
            }
            opts = {
                file_types = { "markdown", "Avante" },
            }
            require("render-markdown").setup(opts)
            require("avante").setup(opts)

            lambda.augroup("Avante", {
                {
                    event = { "FileType" },
                    pattern = "*Avante",
                    command = function()
                        vim.cmd([[Neominimap off]])
                    end,
                },
            })
        end,
    },
}
