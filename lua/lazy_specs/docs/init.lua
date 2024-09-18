return {

    -- {
    --     "neogen",
    --     after = conf.neogen,
    -- },
    {
        "refgo.nvim",
        cmd = { "RefCopy", "RefGo" },
    },

    {
        "nvim-docs-view",
        opt = true,
        cmd = { "DocsViewToggle" },
        after = function()
            require("docs-view").setup({
                position = "bottom",
                height = 10,
            })
        end,
    },

    {
        "vim-devdocs",
        cmd = { "DD" },
        opt = true,
    },

    -- {
    --     "updoc.nvim",
    --     opt = true,
    --     after = function()
    --         require("updoc").setup()
    --     end,
    -- },

    {
        "browse.nvim",
        opt = true,
        dependencies = { "nvim-telescope/telescope.nvim" },
        after = function()
            local browse = require("browse")
            local bookmarks = {
                ["github"] = {
                    ["name"] = "search github from neovim",
                    ["code_search"] = "https://github.com/search?q=%s&type=code",
                    ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
                    ["issues_search"] = "https://github.com/search?q=%s&type=issues",
                    ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
                },
            }
            browse.setup({
                -- search provider you want to use
                provider = "google", -- duckduckgo, bing

                -- either pass it here or just pass the table to the functions
                -- see below for more
                bookmarks = bookmarks,
            })
        end,
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
