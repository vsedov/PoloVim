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
        require("tmux").setup({
            copy_sync = { enable = false },
            navigation = {
                cycle_navigation = false,
                enable_default_keybindings = false,
                persist_zoom = false,
            },
        })

        keymaps = {
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

-- Always load this
tmux({
    "numToStr/Navigator.nvim",
    event = "VeryLazy",
    config = function()
        require("Navigator").setup({
            auto_save = "all",
        })
        for k, value in pairs({ Left = "h", Down = "j", Up = "k", Right = "l", Previous = "=" }) do
            vim.keymap.set({ "n", "t" }, "<c-" .. value .. ">", function()
                vim.cmd("Navigator" .. k)
            end, { noremap = true, silent = true })
        end
    end,
})
