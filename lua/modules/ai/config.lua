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

function config.backseat()
    require("backseat").setup({
        openai_api_key = os.getenv("OPENAI_API_KEY"),
        openai_model_id = lambda.config.ai.model, --gpt-4
        additional_instruction = "Respond in a very snarky / blunt and unformal manor that is also very logical and pythonic, the response must also be very straightforward blunt and some what rude. As this is the method of communication that is mandated by rule and must be adhered: Ensure that you are providing useful information.",
    })
end

-- NOTE: (vsedov) (08:27:38 - 31/07/23): This is nice, until its not.  Hence i do not think its viable. As it also causes heavy lag ive noticed.
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

-- NOTE: (vsedov) (08:27:24 - 31/07/23): I do not think you can refactor this into cmp directly using <c-l>

function config.tabnine()
    require("tabnine").setup({
        disable_auto_comment = true,
        accept_keymap = "<C-;>",
        dismiss_keymap = "<C-e>",
        suggestion_color = { gui = "#808080", cterm = 244 },
        execlude_filetypes = { "TelescopePrompt" },
    })
end

--  TODO: (vsedov) (08:27:17 - 31/07/23): refactor this into cmp
function config.codium()
    vim.keymap.set("i", "<c-.>", function()
        return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true })
    vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true })
    vim.keymap.set("i", "<c-e>", vim.fn["codeium#Clear"], { expr = true })
end
function config.gen(_, opts)
    require("gen").setup(opts)
    require("gen").prompts["Elaborate_Text"] = {
        prompt = "Elaborate the following text:\n$text",
        replace = true,
    }
    require("gen").prompts["Fix_Code"] = {
        prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
        replace = true,
        extract = "```$filetype\n(.-)```",
    }
    require("gen").prompts["DevOps me!"] = {
        prompt = "You are a senior devops engineer, acting as an assistant. You offer help with cloud technologies like: Terraform, AWS, kubernetes, python. You answer with code examples when possible. $input:\n$text",
        replace = true,
    }

    local icn = {
        Chat = "", --     
        Test = "", --    
        Regex = "", --   
        Comment = "", --  
        Code = "", --   
        Text = "", --   
        Items = "", --    
        Swap = "", -- 
        Keep = "", --  
        into = "", --  
    }

    require("gen").prompts = {
        [icn.Chat .. " Ask about given context " .. icn.Keep] = {
            prompt = "Regarding the following text, $input:\n$text",
            model = "mistral",
        },
        [icn.Chat .. " Chat about anything " .. icn.Keep] = {
            prompt = "$input",
            model = "mistral",
        },
        [icn.Regex .. " Regex create " .. icn.Swap] = {
            prompt = "Create a regular expression for $filetype language that matches the following pattern:\n```$filetype\n$text\n```",
            replace = true,
            no_auto_close = false,
            extract = "```$filetype\n(.-)```",
            model = "deepseek-coder",
        },
        [icn.Regex .. " Regex explain " .. icn.Keep] = {
            prompt = "Explain the following regular expression:\n```$filetype\n$text\n```",
            extract = "```$filetype\n(.-)```",
            model = "deepseek-coder",
        },
        [icn.Comment .. " Code " .. icn.into .. " JSDoc " .. icn.Keep] = {
            prompt = "Write JSDoc comments for the following $filetype code:\n```$filetype\n$text\n```",
            model = "deepseek-coder",
        },
        [icn.Comment .. " JSDoc " .. icn.into .. " Code " .. icn.Keep] = {
            prompt = "Read the following comment and create the $filetype code below it:\n```$filetype\n$text\n```",
            extract = "```$filetype\n(.-)```",
            model = "deepseek-coder",
        },
        [icn.Test .. " Unit Test add missing (React/Jest) " .. icn.Keep] = {
            prompt = "Read the following $filetype code that includes some unit tests inside the 'describe' function. We are using Jest with React testing library, and the main component is reused by the tests via the customRender function. Detect if we have any missing unit tests and create them.\n```$filetype\n$text\n```",
            extract = "```$filetype\n(.-)```",
            model = "deepseek-coder",
        },
        [icn.Code .. " Code suggestions " .. icn.Keep] = {
            prompt = "Review the following $filetype code and make concise suggestions:\n```$filetype\n$text\n```",
            model = "deepseek-coder",
        },
        [icn.Code .. " Explain code " .. icn.Keep] = {
            prompt = "Explain the following $filetype code in a very concise way:\n```$filetype\n$text\n```",
            model = "deepseek-coder",
        },
        [icn.Code .. " Fix code " .. icn.Swap] = {
            prompt = "Fix the following $filetype code:\n```$filetype\n$text\n```",
            replace = true,
            no_auto_close = false,
            extract = "```$filetype\n(.-)```",
            model = "deepseek-coder",
        },
        [icn.Items .. " Text " .. icn.into .. " List of items " .. icn.Swap] = {
            prompt = "Convert the following text, except for the code blocks, into a markdown list of items without additional quotes around it:\n$text",
            replace = true,
            no_auto_close = false,
            model = "mistral",
        },
        [icn.Items .. " List of items " .. icn.into .. " Text " .. icn.Swap] = {
            prompt = "Convert the following list of items into a block of text, without additional quotes around it. Modify the resulting text if needed to use better wording.\n$text",
            replace = true,
            no_auto_close = false,
            model = "mistral",
        },
        [icn.Text .. " Fix Grammar / Syntax in text " .. icn.Swap] = {
            prompt = "Fix the grammar and syntax in the following text, except for the code blocks, and without additional quotes around it:\n$text",
            replace = true,
            no_auto_close = false,
            model = "mistral",
        },
        [icn.Text .. " Reword text " .. icn.Swap] = {
            prompt = "Modify the following text, except for the code blocks, to use better wording, and without additional quotes around it:\n$text",
            replace = true,
            no_auto_close = false,
            model = "mistral",
        },
        [icn.Text .. " Simplify text " .. icn.Swap] = {
            prompt = "Modify the following text, except for the code blocks, to make it as simple and concise as possible and without additional quotes around it:\n$text",
            replace = true,
            no_auto_close = false,
            model = "mistral",
        },
        [icn.Text .. " Summarize text " .. icn.Keep] = {
            prompt = "Summarize the following text, except for the code blocks, without additional quotes around it:\n$text",
            model = "mistral",
        },
    }
end

return config
