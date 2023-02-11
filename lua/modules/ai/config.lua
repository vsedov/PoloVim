local config = {}
function config.tabnine()
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

return config
