local tmux = require("core.pack").package

tmux({
    "wincent/terminus",
    cond = vim.fn.getenv("TMUX") ~= vim.NIL and false,
    event = "VeryLazy",
})

tmux({
    "aserowy/tmux.nvim",
    lazy = true,
    cond = vim.fn.getenv("TMUX") ~= vim.NIL and false,
    event = "BufWinEnter",
    config = function()
        require("tmux").setup({})
    end,
})
