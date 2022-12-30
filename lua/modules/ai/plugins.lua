local ai = require("core.pack").package
local conf = require("modules.ai.config")

ai({
    "github/copilot.vim",
    cmd = "Copilot",
    lazy = true,
    init = function()
        --[[ vim.opt.completeopt = "menuone,noselect" ]]
        vim.g.copilot_enabled = lambda.config.sell_your_soul
        -- Have copilot play nice with nvim-cmp.
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
-- https://github.com/f/awesome-chatgpt-prompts

-- <C-c> to close chat window.
-- <C-u> scroll up chat window.
-- <C-d> scroll down chat window.
-- <C-y> to copy/yank last answer.
ai({
    "jackMort/ChatGPT.nvim",
    cmd = {
        "ChatGPT",
        "ChatGPTActAs",
    },
    config = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
})
