local tmux = require("core.pack").package

tmux({
    "wincent/terminus",
    cond = vim.fn.getenv("TMUX") ~= vim.NIL,
    event = "VeryLazy",
})

tmux({
    "aserowy/tmux.nvim",
    lazy = true,
    cond = vim.fn.getenv("TMUX") ~= vim.NIL,
    event = "BufWinEnter",
    config = function()
        require("tmux").setup({})
    end,
})
