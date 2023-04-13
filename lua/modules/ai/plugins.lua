local ai = require("core.pack").package
local conf = require("modules.ai.config")
local ai_conf = lambda.config.ai

ai({
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = conf.chatgpt,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
})
--
ai({
    "Bryley/neoai.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    cmd = {
        "NeoAI",
        "NeoAIOpen",
        "NeoAIClose",
        "NeoAIToggle",
        "NeoAIContext",
        "NeoAIContextOpen",
        "NeoAIContextClose",
        "NeoAIInject",
        "NeoAIInjectCode",
        "NeoAIInjectContext",
        "NeoAIInjectContextCode",
    },
    keys = {
        { "<leader>as", desc = "summarize text" },
        { "<leader>ag", desc = "generate git message" },
    },
    config = conf.neoai,
})
ai({
    "dpayne/CodeGPT.nvim",
    event = "VeryLazy",
    cmd = { "Chat" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    config = conf.codegpt,
})

ai({
    "mikesoylu/ai.vim",
    event = "VeryLazy",
    cmd = { "AI" },
    init = function()
        vim.g.ai_completions_model = "gpt-4"

        vim.keymap.set(
            { "v", "x" },
            "<leader>w",
            ":AI fix grammar and spelling and replace slang and contractions with a formal academic writing style.<CR>",
            {
                silent = true,
            }
        )

        vim.keymap.set(
            { "v", "x" },
            "<leader>aw",
            ":AI fix grammar and spelling and rewrite this how tech would write this from the bad batch the tv show.<CR>",
            {
                silent = true,
            }
        )
    end,
})

ai({
    "meinside/openai.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
        require("openai").setup({
            models = {
                completeChat = "gpt-4",
                editCode = "code-davinci-edit-001",
                editText = "text-davinci-edit-001",
                moderation = "text-moderation-latest",
            },
            timeout = 60 * 1000,
        })
        vim.keymap.set(
            { "v", "x" },
            "<leader>aW",
            ":OpenaiEditText fix grammar and spelling and replace slang and contractions with a formal academic writing style.<CR>",
            {
                silent = true,
            }
        )
    end,
})

ai({
    "james1236/backseat.nvim",
    lazy = true,
    cmd = { "Backseat", "BackseatAsk", "BackseatClear", "BackseatClearLine" },
    config = conf.backseat,
})

ai({
    "tzachar/cmp-tabnine",
    lazy = true,
    cond = (ai_conf.tabnine.use_tabnine and ai_conf.tabnine.use_tabnine_cmp),
    event = "VeryLazy",
    build = "bash ./install.sh",
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    config = conf.tabnine_cmp,
})

ai({
    "codota/tabnine-nvim",
    lazy = true,
    cond = (ai_conf.tabnine.use_tabnine and ai_conf.tabnine.use_tabnine_insert),
    event = "VeryLazy",
    build = "bash ./dl_binaries.sh",
    config = conf.tabnine,
})

ai({
    "Exafunction/codeium.vim",
    lazy = true,
    cond = (ai_conf.codeium.use_codeium and ai_conf.codeium.use_codium_insert),
    event = "VeryLazy",
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
    event = "VeryLazy",
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
    "github/copilot.vim",
    lazy = true,
    cond = ai_conf.sell_your_soul,
    event = "VeryLazy",
    init = conf.sell_your_soul,
})
