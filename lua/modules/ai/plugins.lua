local ai = require("core.pack").package
local conf = require("modules.ai.config")
local ai_conf = lambda.config.ai

ai({
    "jackMort/ChatGPT.nvim",
    cmd = {
        "ChatGPT",
        "ChatGPTActAs",
        "ChatGPTEditWithInstructions",
        "ChatGPTRunCustomCodeAction",
        "ChatGPTRun",
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = conf.chatgpt,
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
-- <Tab> Cycle over windows.
-- <C-i> [Edit Window] use response as input.

ai({
    "github/copilot.vim",
    -- lazy = true,
    -- cmd = "Copilot",
    cond = ai_conf.sell_your_soul,
    -- event = "VeryLazy",

    init = conf.sell_your_soul,
})
