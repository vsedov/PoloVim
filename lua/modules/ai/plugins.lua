local ai = require("core.pack").package

local conf = require("modules.ai.config")

local ai_conf = lambda.config.ai

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

ai({
    "jackMort/ChatGPT.nvim",
    lazy = true,
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = conf.chatgpt,
})

ai({
    "mikesoylu/ai.vim",
    cmd = { "AI" },
    init = function()
        vim.g.ai_completions_model = "gpt-4"
        vim.g.ai_no_mappings = 1 -- disbale default mappings
    end,
})

ai({
    "james1236/backseat.nvim",
    lazy = true,
    cmd = { "Backseat", "BackseatAsk", "BackseatClear", "BackseatClearLine" },
    config = conf.backseat,
})

ai({
    "codota/tabnine-nvim",
    lazy = true,
    cond = (ai_conf.tabnine.use_tabnine and ai_conf.tabnine.use_tabnine_insert),
    event = "BufWinEnter",
    build = "bash ./dl_binaries.sh",
    config = conf.tabnine,
})

ai({
    "Exafunction/codeium.vim",
    lazy = true,
    cond = (ai_conf.codeium.use_codeium and ai_conf.codeium.use_codium_insert),
    event = "BufWinEnter",
    init = function()
        vim.g.codeium_disable_bindings = 1
        vim.g.codeium_enabled = lambda.config.ai.use_codium_insert
    end,
    config = conf.codium,
})

ai({
    "jcdickinson/codeium.nvim",
    cond = (ai_conf.codeium.use_codeium and ai_conf.codeium.use_codeium_cmp),
    lazy = true,
    event = "BufWinEnter",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    config = true,
})

-- <C-c> to close chat window.
-- <C-u> scroll up chat window.
-- <C-d> scroll down chat window.
-- <C-y> to copy/yank last answer.
-- <C-o> Toggle settings window.
-- <C-n> Start new session.
-- <Tab> Cycle over windows.tr
-- <C-i> [Edit Window] use response as input.

ai({
    "zbirenbaum/copilot.lua",
    cond = ai_conf.sell_your_soul,
    event = "InsertEnter",
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
    },
})

--  TODO: (vsedov) (14:41:51 - 12/02/24): Create a hydra for this
--  Something like <leader>A -> C All binds ?
--  or perhaps <leader>cc Hydra could also work
ai({
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = {
        "CopilotChat",
        "CopilotChatExplain",
        "CopilotChatTests",
        "CopilotChatReview",
        "CopilotChatReview",
        "CopilotChatRefactor",
        "CopilotChatFixCode",
        "CopilotChatBetterNamings",
        "CopilotChatDocumentation",
        "CopilotChatSummarize",
        "CopilotChatSpelling",
        "CopilotChatWording",
        "CopilotChatConcise",
        "CopilotChatDebugInfo",
        "CopilotChatVisual",
        "CopilotChatInPlace",
    },

    build = ":UpdateRemotePlugins",

    opts = {
        show_help = "yes",
        prompts = prompts,
        debug = false, -- Set to true to see response from Github Copilot API. The log file will be in ~/.local/state/nvim/CopilotChat.nvim.log.
        disable_extra_info = "no", -- Disable extra information (e.g: system prompt, token count) in the response.
    },
})
ai({
    "sourcegraph/sg.nvim",
    cond = lambda.config.lsp.use_sg,
    event = "InsertEnter",
    branch = "update-cody-agent-03-12",
    build = "nvim -l build/init.lua",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },

    cmd = {
        "SourcegraphBuild",
        "SourcegraphDownloadBinaries",
        "SourcegraphInfo",
        "SourcegraphLink",
        "SourcegraphLogin",
        "SourcegraphSearch",
        "CodyDo",
        "CodyChat",
        "CodyToggle",
        "CodyTaskNext",
        "CodyTaskView",
        "CodyAsk",
        "CodyTask",
        "CodyRestart",
        "CodyTaskPrev",
        "CodyTaskAccept",
    },
    config = function()
        require("sg").setup({
            enable_cody = true,
            accept_tos = true,
            download_binaries = true,
            on_attach = true,
        })
    end,
})
ai({
    "David-Kunz/gen.nvim",
    cmd = "Gen",
    opts = {
        model = "deepseek-coder",
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true, -- Shows the Prompt submitted to Ollama.
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = true, -- Never closes the window automatically.
        init = function(options)
            pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
        end,
        -- Function to initialize Ollama
        command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
    },
    config = conf.gen,
})

-- <C-s> - Save the buffer and trigger a response from the generative AI service
-- <C-c> - Close the buffer
-- q - Cancel the stream from the API
-- gc - Clear the buffer's contents
-- ga - Add a codeblock
-- gs - Save the chat to disk
-- [ - Move to the next header
-- ] - Move to the previous header

ai({
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        {
            "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
        },
    },
    config = true,
    keys = {
        {
            "<c-]>",
            ":CodeCompanionActions<cr>",
            mode = { "n", "v" },
        },
        {
            ";a",
            ":CodeCompanionToggle<cr>",
            mode = { "n", "v" },
        },
    },
})
