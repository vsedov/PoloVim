local config = {}

function config.chatgpt()
    require("chatgpt").setup({
        max_line_length = 1000000,
        openai_params = {
            model = "gpt-4",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 6000,
            temperature = 1,
            top_p = 1,
            n = 1,
        },
        keymaps = {
            close = { "<C-c>" },
            -- submit = "<C-s>",
            yank_last = "<C-y>",
            yank_last_code = "<C-k>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            toggle_settings = "<C-o>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",

            -- in the Sessions pane
            select_session = "<Space>",
            rename_session = "r",
            delete_session = "d",
        },
    })
end

function config.neoai()
    require("neoai").setup({
        -- Below are the default options, feel free to override what you would like changed
        ui = {
            output_popup_text = "NeoAI",
            input_popup_text = "Prompt",
            width = 30, -- As percentage eg. 30%
            output_popup_height = 80, -- As percentage eg. 80%
        },
        model = "gpt-4",
        register_output = {
            ["g"] = function(output)
                return output
            end,
            ["c"] = require("neoai.utils").extract_code_snippets,
        },
        inject = {
            cutoff_width = 100,
        },
        prompts = {
            context_prompt = function(context)
                return "Hi ChatGPT, I'd like to provide some context for future "
                    .. "messages. Here is the code/text that I want to refer "
                    .. "to in our upcoming conversations:\n\n"
                    .. context
            end,
        },
        -- open_api_key_env = os.getenv("OPENAI_API_KEY"),
        shortcuts = {
            {
                key = "<leader>as",
                use_context = true,
                prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
                modes = { "v" },
                strip_function = nil,
            },
            {
                key = "<leader>ag",
                use_context = false,
                prompt = function()
                    return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
                end,
                modes = { "n" },
                strip_function = nil,
            },
        },
    })
end

function config.codegpt()
    require("codegpt.config")

    vim.g["codegpt_openai_api_key"] = os.getenv("OPENAI_API_KEY")
    vim.g["codegpt_chat_completions_url"] = "https://api.openai.com/v1/chat/completions"
    vim.g["codegpt_openai_api_provider"] = "OpenAI" -- or Azure
    vim.g["codegpt_clear_visual_selection"] = true
    vim.g["codegpt_ui_commands"] = {
        quit = "q", -- key to quit the popup
        use_as_output = "<c-o>", -- key to use the popup content as output and replace the original lines
        use_as_input = "<c-a>", -- key to use the popup content as input for a new API request
    }

    vim.g["codegpt_commands"] = {
        ["tests"] = {
            language_instructions = {
                python = "Use the pytest framework.",
            },
        },
        ["doc"] = {
            language_instructions = {
                python = "Use the numpy style docstrings Generate in Detail.",
            },
            max_tokens = 6000,
        },
        ["code_edit"] = {
            system_message_template = "You are {{language}} developer.",
            user_message_template = "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nEdit the above code. {{language_instructions}}",
            callback_type = "code_popup",
        },
        ["modernize"] = {
            user_message_template = "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nModernize the above code. Use current best practices. Only return the code snippet and comments. {{language_instructions}}",
            language_instructions = {
                cpp = "Use modern C++ syntax. Use auto where possible. Do not import std. Use trailing return type. Use the c++11, c++14, c++17, and c++20 standards where applicable.",
                python = "Use Best pythonic practices where possible, refactor this code",
            },
        },
    }
end
function config.backseat()
    require("backseat").setup({
        openai_api_key = os.getenv("OPENAI_API_KEY"),
        openai_model_id = "gpt-4", --gpt-4
        additional_instruction = "Respond Like tech from the bad batch", -- (GPT-3 will probably deny this request, but GPT-4 complies)
        split_threshold = 200,
    })
end

function config.tabnine_cmp()
    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({
        max_lines = 1000,
        max_num_results = 10,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = lambda.style.icons.misc.ellipsis,
        ignored_file_types = {
            norg = true,
        },
        show_prediction_strength = true,
    })
end

function config.tabnine()
    require("tabnine").setup({
        disable_auto_comment = true,
        accept_keymap = "<C-l>",
        dismiss_keymap = "<C-e>",
        debounce_ms = 100,
        suggestion_color = { gui = "#808080", cterm = 244 },
        execlude_filetypes = { "TelescopePrompt" },
    })
end
function config.codium()
    vim.keymap.set("i", "<C-l>", vim.fn["codeium#Accept"], { expr = true })
    vim.keymap.set("i", "<c-.>", function()
        return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true })
    vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true })
    vim.keymap.set("i", "<c-e>", vim.fn["codeium#Clear"], { expr = true })
end

function config.sell_your_soul()
    vim.g.copilot_enabled = lambda.config.ai.sell_your_soul
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    local excluded_filetypes = { "norg", "nofile", "prompt" }
    local copilot_filetypes = {}
    for _, ft in pairs(excluded_filetypes) do
        copilot_filetypes[ft] = false
    end
    vim.g["copilot_filetypes"] = copilot_filetypes
end
return config
