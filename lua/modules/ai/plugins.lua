local ai = require("core.pack").package
local conf = require("modules.ai.config")
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
    build = "bash ./install.sh",
    config = conf.tabnine,
})

ai({
    "Exafunction/codeium.vim",
    lazy = true,
    cond = (lambda.config.ai.codeium.use_codeium and lambda.config.ai.codeium.use_codium_insert),
    event = "BufEnter",
    init = function()
        vim.g.codeium_disable_bindings = 1
        vim.g.codeium_enabled = lambda.config.ai.use_codium_insert
    end,
    config = function()
        vim.keymap.set("i", "<C-]>", vim.fn["codeium#Accept"], { expr = true })
        vim.keymap.set("i", "<c-;>", function()
            return vim.fn["codeium#CycleCompletions"](1)
        end, { expr = true })
        vim.keymap.set("i", "<c-,>", function()
            return vim.fn["codeium#CycleCompletions"](-1)
        end, { expr = true })
        vim.keymap.set("i", "<c-e>", vim.fn["codeium#Clear"], { expr = true })
    end,
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
    cmd = "Copilot",
    lazy = true,
    -- cond = lambda.config.ai.sell_your_soul,
    init = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ""
        local excluded_filetypes = { "norg", "nofile", "prompt" }
        local copilot_filetypes = {}
        for _, ft in pairs(excluded_filetypes) do
            copilot_filetypes[ft] = false
        end
        vim.g["copilot_filetypes"] = copilot_filetypes
    end,
})
