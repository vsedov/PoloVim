local config = {}

function config.chatgpt()
    require("chatgpt").setup({
        max_line_length = 1000000,
        openai_params = {
            model = "text-davinci-003",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 2000,
            temperature = 1,
            top_p = 1,
            n = 1,
        },
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
        debounce_ms = 800,
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
