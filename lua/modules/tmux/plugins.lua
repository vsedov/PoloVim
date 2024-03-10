local tmux = require("core.pack").package

tmux({
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    cond = vim.fn.getenv("TMUX") ~= vim.NIL,
    config = true,
})
