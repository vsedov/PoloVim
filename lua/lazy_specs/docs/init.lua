local conf = require("modules.documentation.config")

return {

    {
        "neogen",
        opt = true,
        after = conf.neogen,
    },
    {
        "refgo.nvim",
        opt = true,
        cmd = { "RefCopy", "RefGo" },
    },

    {
        "nvim-docs-view",
        opt = true,
        cmd = { "DocsViewToggle" },
        after = conf.nvim_doc_help,
    },

    {
        "vim-devdocs",
        cmd = { "DD" },
        opt = true,
    },

    {
        "updoc.nvim",
        opt = true,
        after = function()
            require("updoc").setup()
        end,
    },

    {
        "browse.nvim",
        opt = true,
        dependencies = { "nvim-telescope/telescope.nvim" },
        after = conf.browse,
    },
    {
        "wtf.nvim",
        opts = {
            -- Default AI popup type
            popup_type = "popup",
            -- An alternative way to set your OpenAI api key
            openai_api_key = os.getenv("OPENAI_API_KEY"),
            -- ChatGPT Model
            openai_model_id = "gpt-4",
            additional_instructions = "Start the reply with 'Hello There' Talk like a programming version of obiwan kenobi",
            -- Default search engine, can be overridden by passing an option to WtfSeatch
            default_search_engine = "google", -- "google" | "duck_duck_go" | "stack_overflow" | "github",
        },
        cmd = {
            "Wtf",
            "WtfSearch",
        },
        after = function(_, opts)
            require("wtf").setup(opts)

            vim.g["wtf_hooks"] = {
                request_started = function()
                    vim.cmd("hi StatusLine ctermbg=NONE ctermfg=yellow")
                end,
                request_finished = vim.schedule_wrap(function()
                    vim.cmd("hi StatusLine ctermbg=NONE ctermfg=NONE")
                end),
            }
        end,
    },
}
