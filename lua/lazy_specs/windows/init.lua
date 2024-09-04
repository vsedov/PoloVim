local conf = require("modules.windows.config")

return {
    {
        "vim-maximizer",
        cmd = "MaximizerToggle",
    },

    {
        "winshift.nvim",
        cmd = "WinShift",
        after = conf.winshift,
    },
    {
        "wrapping.nvim",
        ft = { "tex", "norg", "latex", "text" },
    },
    {
        "bufresize.nvim",
        opt = true,
        after = function()
            local opts = { noremap = true, silent = true }
            require("bufresize").setup({
                register = {
                    keys = {
                        { "n", "<C-w><", "<C-w><", opts },
                        { "n", "<C-w>>", "<C-w>>", opts },
                        { "n", "<C-w>+", "<C-w>+", opts },
                        { "n", "<C-w>-", "<C-w>-", opts },
                        { "n", "<C-w>_", "<C-w>_", opts },
                        { "n", "<C-w>=", "<C-w>=", opts },
                        { "n", "<C-w>|", "<C-w>|", opts },
                        { "", "<LeftRelease>", "<LeftRelease>", opts },
                        { "i", "<LeftRelease>", "<LeftRelease><C-o>", opts },
                    },
                    trigger_events = { "BufWinEnter", "WinEnter" },
                },
                resize = {
                    keys = {},
                    trigger_events = { "VimResized" },
                    increment = false,
                },
            })
        end,
    },

    {
        "smart-splits.nvim",
        event = "BufEnter",
        after = function()
            require("smart-splits").setup({
                resize_mode = {
                    hooks = {
                        on_leave = require("bufresize").register,
                    },
                },
                mux = "kitty",
                extensions = {
                    -- default settings shown below:
                    smart_splits = {
                        directions = { "h", "j", "k", "l" },
                        mods = {
                            -- for moving cursor between windows
                            move = "<C>",
                            -- for resizing windows
                            resize = "<M>",
                            -- for swapping window buffers
                            swap = true, -- false disables creating a binding
                        },
                    },
                },
            })
            local keys = {
                {
                    "<A-h>",
                    function()
                        require("smart-splits").resize_left()
                    end,
                    desc = "Resize left",
                },
                {
                    "<A-l>",
                    function()
                        require("smart-splits").resize_right()
                    end,
                    desc = "Resize right",
                },
                -- moving between splits
                {
                    "<C-h>",
                    function()
                        require("smart-splits").move_cursor_left()
                    end,
                    desc = "move left",
                },
                {
                    "<C-j>",
                    function()
                        require("smart-splits").move_cursor_down()
                    end,
                    desc = "move down",
                },

                {
                    "<C-k>",
                    function()
                        require("smart-splits").move_cursor_up()
                    end,
                    desc = "move up",
                },
                {
                    "<C-l>",
                    function()
                        require("smart-splits").move_cursor_right()
                    end,
                    desc = "move right",
                },
                -- swapping buffers between windows
                {
                    "<leader><leader>h",
                    function()
                        require("smart-splits").swap_buf_left()
                    end,
                    desc = "swap left",
                },
                {
                    "<leader><leader>j",
                    function()
                        require("smart-splits").swap_buf_down()
                    end,
                    desc = "swap down",
                },
                {
                    "<leader><leader>k",
                    function()
                        require("smart-splits").swap_buf_up()
                    end,
                    desc = "swap up",
                },
                {
                    "<leader><leader>l",
                    function()
                        require("smart-splits").swap_buf_right()
                    end,
                    desc = "swap right",
                },
            }
            for _, key in ipairs(keys) do
                vim.keymap.set("n", key[1], key[2], { noremap = true, silent = true })
            end
        end,
    },
}
