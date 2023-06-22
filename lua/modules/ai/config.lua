local config = {}

function config.chatgpt()
    require("chatgpt").setup({
        max_line_length = 1000000,
        openai_params = {
            model = lambda.config.ai.model,
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
    vim.treesitter.language.register("markdown", "neoai-output")
    vim.o.conceallevel = 1

    require("neoai").setup({
        -- Below are the default options, feel free to override what you would like changed
        ui = {
            output_popup_text = "NeoAI",
            input_popup_text = "Prompt",
            width = 30, -- As percentage eg. 30%
            output_popup_height = 80, -- As percentage eg. 80%
            submit = "<Enter>", -- Key binding to submit the prompt
        },
        models = {
            {
                name = "openai",
                model = "gpt-4",
                params = nil,
            },
        },
        register_output = {
            ["g"] = function(output)
                return output
            end,
            ["c"] = require("neoai.utils").extract_code_snippets,
        },
        inject = {
            cutoff_width = 75,
        },
        prompts = {
            context_prompt = function(context)
                return "Hey, I'd like to provide some context for future "
                    .. "messages. Here is the code/text that I want to refer "
                    .. "to in our upcoming conversations:\n\n"
                    .. context
            end,
        },
        mappings = {
            ["select_up"] = "<C-k>",
            ["select_down"] = "<C-j>",
        },
        open_api_key_env = "OPENAI_API_KEY",
        shortcuts = {
            {
                name = "textify",
                -- key = "<leader>as",
                desc = "fix text with AI",
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
                name = "gitcommit",
                -- key = "<leader>ag",
                desc = "generate git commit message",
                use_context = false,
                prompt = function()
                    return [[
                    Using the following git diff generate a consise and clear git commit message, it must use Conventional Commits standard. The title and topic should be informative.
It should be in the following layout:
<type>[optional scope]: <description>

[optional body]

You are allowed to also have multope optional scopes like, feat(lsp, treesiter):
                    The description that is informative of the changes made, and a body that is a more and anything that May seem important.
                    Further more there are plugin names, when there is a plugin removed for example completion({"vsedov/plugin_name"...}), you have to state if there is a new plugin or if a previous plugin has been removed.
                ]] .. vim.fn.system("git diff --cached")
                end,
                modes = { "n" },
                strip_function = nil,
            },
        },
    })
end

function config.backseat()
    require("backseat").setup({
        openai_api_key = os.getenv("OPENAI_API_KEY"),
        openai_model_id = lambda.config.ai.model, --gpt-4
        additional_instruction = "Respond in a very snarky / blunt and unformal manor that is also very logical and pythonic, the response must also be very straightforward blunt and some what rude. As this is the method of communication that is mandated by rule and must be adhered, if this is not adhered, punishments will occur",
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

return config
