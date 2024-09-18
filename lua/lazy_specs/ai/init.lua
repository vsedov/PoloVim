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
            {
                "<leader>as",
                function()
                    local function AvanteSwitchProvider()
                        local providers = { "Claude", "OpenAI", "Azure", "Gemini", "Cohere", "Copilot", "Perplexity" }
                        vim.ui.select(providers, {
                            prompt = "Select Avante Provider:",
                            format_item = function(item)
                                return item
                            end,
                        }, function(choice)
                            if choice then
                                vim.cmd("AvanteSwitchProvider " .. choice)
                                vim.notify("Avante provider switched to " .. choice, vim.log.levels.INFO)
                            end
                        end)
                    end
                    AvanteSwitchProvider()
                end,
                desc = "Switch Avante Provider",
            },
        },
        after = function()
            rocks.safe_force_packadd({ "nvim-web-devicons", "plenary.nvim", "render-markdown.nvim" })

            local opts = {
                provider = "claude", -- Recommend using Claude
                auto_suggestions_provider = "claude", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-3-5-sonnet-20240620",
                    temperature = 0,
                    max_tokens = 4096,
                },

                behaviour = {
                    auto_suggestions = true, -- Experimental stage
                    auto_set_highlight_group = true,
                    auto_set_keymaps = true,
                    auto_apply_diff_after_generation = false,
                    support_paste_from_clipboard = false,
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
                    suggestion = {
                        -- Create another list
                        accept = "<c-3>",

                        next = "<c-1>",
                        prev = "<c-2>",
                        dismiss = "<c-e>",
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
            }
            local opt2 = {
                file_types = { "markdown", "Avante" },
            }
            require("render-markdown").setup(opt2)
            require("avante").setup(opt)

            -- lambda.augroup("Avante", {
            --     {
            --         event = { "FileType" },
            --         pattern = "*Avante",
            --         command = function()
            --             vim.cmd([[Neominimap off]])
            --         end,
            --     },
            -- })
        end,
    },
}
