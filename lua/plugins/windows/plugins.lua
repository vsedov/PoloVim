local conf = require("modules.windows.config")
local windows = require("core.pack").package
-- --  Possible, ONE Can be causing huge LAG, it could be a viability : :think:
windows({
    "szw/vim-maximizer",
    lazy = true,
    cmd = "MaximizerToggle",
})

windows({
    "sindrets/winshift.nvim",
    lazy = true,
    cmd = "WinShift",
    config = conf.winshift,
})

-- What tf is this plugin ?
windows({
    "andrewferrier/wrapping.nvim",
    ft = { "tex", "norg", "latex", "text" },
    cond = lambda.config.windows.use_wrapping,
    lazy = true,
    config = true,
})
windows({
    "nvim-focus/focus.nvim",
    cond = lambda.config.windows.use_focus,
    event = "BufEnter",
    config = function()
        local ignore_filetypes = { "neo-tree" }
        local ignore_buftypes = { "nofile", "prompt", "popup", "neo-tree" }

        local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

        vim.api.nvim_create_autocmd("WinEnter", {
            group = augroup,
            callback = function(_)
                if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
                    vim.w.focus_disable = true
                else
                    vim.w.focus_disable = false
                end
            end,
            desc = "Disable focus autoresize for BufType",
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = augroup,
            callback = function(_)
                if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
                    vim.b.focus_disable = true
                else
                    vim.b.focus_disable = false
                end
            end,
            desc = "Disable focus autoresize for FileType",
        })
        require("focus").setup({
            enable = true, -- Enable module
            commands = true, -- Create Focus commands
            autoresize = {
                enable = true, -- Enable or disable auto-resizing of splits
                width = 0, -- Force width for the focused window
                height = 0, -- Force height for the focused window
                minwidth = 0, -- Force minimum width for the unfocused window
                minheight = 0, -- Force minimum height for the unfocused windowjj
                height_quickfix = 10, -- Set the height of quickfix panel
            },
            split = {
                bufnew = true, -- Create blank buffer for new split windows
                tmux = false, -- Create tmux splits instead of neovim splits
            },
            ui = {
                number = false, -- Display line numbers in the focussed window only
                relativenumber = false, -- Display relative line numbers in the focussed window only
                hybridnumber = false, -- Display hybrid line numbers in the focussed window only
                absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows
                cursorline = false, -- Display a cursorline in the focussed window only
                cursorcolumn = false, -- Display cursorcolumn in the focussed window only
                colorcolumn = {
                    enable = false, -- Display colorcolumn in the foccused window only
                    list = "+1", -- Set the comma-saperated list for the colorcolumn
                },
                signcolumn = false, -- Display signcolumn in the focussed window only
                winhighlight = false, -- Auto highlighting for focussed/unfocussed windows
            },
        })
        vim.keymap.set("n", "<leader>A", ":FocusToggle<cr>", { desc = "Toggle Focus Mode" })
    end,
})

-- ┌                                          ┐
-- │                                          │
-- │ Very Lazy Scripts that i need to replace │
-- │                                          │
-- └                                          ┘

windows({
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    dependencies = {
        {
            "kwkarlwang/bufresize.nvim",

            config = function()
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
    },
    config = function()
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
})
