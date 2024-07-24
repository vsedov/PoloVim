local conf = require("modules.documentation.config")
local docs = require("core.pack").package

docs({
    "danymat/neogen",
    lazy = true,
    dependencies = { "L3MON4D3/LuaSnip" },
    config = conf.neogen,
})
-- lua/modules/documentation/plugins.lua:5
docs({
    "prichrd/refgo.nvim",
    lazy = true,
    cmd = { "RefCopy", "RefGo" },
})

docs({
    "amrbashir/nvim-docs-view",
    lazy = true,
    cmd = { "DocsViewToggle" },
    config = conf.nvim_doc_help,
})

docs({
    "KabbAmine/zeavim.vim",
    lazy = true,
    cmd = {
        "Zeavim",
        "ZeavimV",
        "Docset",
    },
})

docs({
    "romainl/vim-devdocs",
    cmd = { "DD" },
    lazy = true,
})

docs({
    "loganswartz/updoc.nvim",
    lazy = true,
    config = true,
})

docs({
    "lalitmee/browse.nvim",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = conf.browse,
})
docs({
    "piersolenski/wtf.nvim",
    dependencies = {
        "dpayne/CodeGPT.nvim", -- Optional, if you want to use AI
    },
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
    config = function(_, opts)
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
})
