local tmux = require("core.pack").package

tmux({
    "aserowy/tmux.nvim",
    cond = vim.fn.getenv("TMUX") ~= vim.NIL,
    config = true,
})
