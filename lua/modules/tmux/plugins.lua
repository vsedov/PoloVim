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
        local keymaps = {
            Up = function()
                require("tmux").resize_top()
            end,
            Left = function()
                require("tmux").resize_left()
            end,
            Right = function()
                require("tmux").resize_right()
            end,
            Down = function()
                require("tmux").resize_down()
            end,
        }
        for k, v in pairs(keymaps) do
            vim.keymap.set("n", "<A-" .. k .. ">", v, { noremap = true, silent = true })
        end
    end,
})
