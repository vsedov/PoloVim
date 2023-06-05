local ai = require("core.pack").package
local conf = require("modules.ai.config")

local ai_conf = lambda.config.ai

ai({
    "jackMort/ChatGPT.nvim",
    lazy = true,
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
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
    lazy = true,
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
        { "<leader>as", desc = "summarize text", mode = "v" },
        { "<leader>ag", desc = "generate git message", mode = "n" },
    },
    config = conf.neoai,
})

ai({
    "mikesoylu/ai.vim",
    cmd = { "AI" },
    init = function()
        vim.g.ai_completions_model = "gpt-4"
        vim.g.ai_no_mappings = 1 -- disbale default mappings

        vim.keymap.set(
            { "v", "x" },
            "<localleader>w",
            ":AI fix grammar and spelling and replace slang and contractions with a formal academic writing style.<CR>",
            {
                silent = true,
            }
        )

        vim.keymap.set(
            { "v", "x" },
            "<localleader>aw",
            ":AI fix grammar and spelling and rewrite this how tech would write this from the bad batch the tv show.<CR>",
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
    cond = ai_conf.sell_your_soul,
    lazy = true,
    event = "VeryLazy",
    init = conf.sell_your_soul,
})
