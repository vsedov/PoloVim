local ai = require("core.pack").package
local conf = require("modules.ai.config")

ai({
    "github/copilot.vim",
    cmd = "Copilot",
    lazy = true,
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

-- <C-c> to close chat window.
-- <C-u> scroll up chat window.
-- <C-d> scroll down chat window.
-- <C-y> to copy/yank last answer.
-- <C-o> Toggle settings window.
-- <C-n> Start new session.
-- <Tab> Cycle over windows.
-- <C-i> [Edit Window] use response as input.
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
    ft = { "python", "lua" },
    config = conf.tabnine,
})

ai({
    "jcdickinson/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    config = true,
})
