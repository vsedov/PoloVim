local conf = require("modules.windows.config")
local windows = require("core.pack").package
-- --  Possible, ONE Can be causing huge LAG, it could be a viability : :think:
windows({
    "szw/vim-maximizer",
    lazy = true,
    cmd = "MaximizerToggle",
})

windows({
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    cond = lambda.config.windows.use_smart_splits,
    build = function()
        if vim.fn.getenv("TMUX") ~= vim.NIL then
            -- return "./kitty/install-kittens.bash"
            -- return ""
        else
            return "./kitty/install-kittens.bash"
        end
    end,
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
            mux = {
                type = "tmux",
            },
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
                        swap = false, -- false disables creating a binding
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

windows({
    "tamton-aquib/flirt.nvim",
    cond = lambda.config.windows.flirt.use_flirt,
    lazy = true,
    event = "BufEnter",
    config = function()
        require("flirt").setup({
            override_open = lambda.config.windows.flirt.use_flirt_override, -- experimental
            close_command = "Q",
            default_move_mappings = lambda.config.windows.flirt.move_mappings, -- <C-arrows> to move floats
            default_resize_mappings = true, -- <A-arrows> to resize floats
            default_mouse_mappings = true, -- Drag floats with mouse
            exclude_fts = {
                "lspsagafinder",
                "chatgpt",
                "TelescopePrompt",
                "prompt",
                "notify",
                "cmp_menu",
                "harpoon",
                "hydra_hint",
            },
            custom_filter = function(buffer, win_config)
                return vim.tbl_contains({ "cmp_menu", "hydra_hint", "prompt" }, vim.bo[buffer].buftype)
            end,
        })
    end,
})

windows({
    "sindrets/winshift.nvim",
    lazy = true,
    cmd = "WinShift",
    config = conf.winshift,
})

windows({
    "anuvyklack/windows.nvim",
    dependencies = {
        { "anuvyklack/middleclass" },
        { "anuvyklack/animation.nvim" },
    },
    lazy = true,
    cmd = {

        "WindowsMaximize",
        "WindowsToggleAutowidth",
        "WindowsEnableAutowidth",
        "WindowsDisableAutowidth",
    },
    keys = {
        {
            ";z",

            function()
                vim.cmd([[WindowsMaximize]])
            end,
            desc = "Window Maximize",
        },
        {
            ";Z",
            function()
                vim.cmd([[WindowsDisableAutowidth]])
            end,
            desc = "Window Disable",
        },
    },
    config = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
        require("windows").setup({
            create_commands = true,
            create_keymaps = true,
        })
    end,
})

-- What tf is this plugin ?
windows({
    "andrewferrier/wrapping.nvim",
    ft = { "tex", "norg", "latex", "text" },
    cond = lambda.config.windows.use_wrapping,
    lazy = true,
    config = true,
})
