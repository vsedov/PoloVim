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
        event = "BufEnter",
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
                ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
                provider = "claude", -- Recommend using Claude
                vendors = {
                    perplexity = {
                        endpoint = "https://api.perplexity.ai/chat/completions",
                        model = "llama-3.1-sonar-large-128k-online",
                        api_key_name = "PERPLEXITY_API_KEY",
                        parse_curl_args = function(opts, code_opts)
                            return {
                                url = opts.endpoint,
                                headers = {
                                    ["Accept"] = "application/json",
                                    ["Content-Type"] = "application/json",
                                    ["Authorization"] = "Bearer " .. opts.api_key,
                                },
                                body = {
                                    model = opts.model,
                                    messages = { -- you can make your own message, but this is very advanced
                                        { role = "system", content = code_opts.system_prompt },
                                        {
                                            role = "user",
                                            content = require("avante.providers.openai").get_user_message(code_opts),
                                        },
                                    },
                                    temperature = 0,
                                    max_tokens = 8192,
                                    stream = true, -- this will be set by default.
                                },
                            }
                        end,
                        -- The below function is used if the vendors has specific SSE spec that is not claude or openai.
                        parse_response_data = function(data_stream, event_state, opts)
                            require("avante.providers").openai.parse_response(data_stream, event_state, opts)
                        end,
                    },
                },
                behaviour = {
                    auto_suggestions = true, -- Experimental stage
                    auto_set_highlight_group = true,
                    auto_set_keymaps = true,
                    auto_apply_diff_after_generation = true,
                    support_paste_from_clipboard = true,
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
                    width = 45, -- default % based on available width
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
            local opt2 = {
                file_types = { "markdown", "Avante" },
            }
            require("render-markdown").setup(opt2)
            require("avante").setup(opts)

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
