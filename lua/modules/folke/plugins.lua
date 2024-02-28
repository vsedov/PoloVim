local folke = require("core.pack").package
local conf = require("modules.folke.config")

folke({
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<Leader>E",
            function()
                require("edgy").toggle()
            end,
            "General: [F]orce Close Edgy",
        },
    },
    opts = conf.edgy,
})

folke({
    "folke/noice.nvim",
    cond = lambda.config.folke.noice.enable,
    dependencies = {
        "nui.nvim",
        "nvim-notify",
        "hrsh7th/nvim-cmp",
    },
    opts = require("modules.folke.noice").noice,

    config = require("modules.folke.noice").noice_setup,
})

folke({
    "folke/which-key.nvim",
    cond = lambda.config.tools.use_which_key_or_use_mini_clue == "which",
    -- lazy = true,
    -- event = "VeryLazy",
    config = conf.which_key,
})

folke({
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    lazy = true,
    config = true,
})

folke({
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("todo-comments").setup()
        lambda.command("TodoDots", ("TodoQuickFix cwd=%s keywords=TODO,FIXME"):format(vim.g.vim_dir))
    end,
})
folke({
    "folke/neodev.nvim",
    lazy = true,
    ft = "lua",
    opts = {
        library = {
            plugins = { "nvim-dap-ui" },
        },
    },
})
folke({
    "folke/paint.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.paint,
})

folke({
    "folke/zen-mode.nvim",
    lazy = true,
    opts = {
        window = {
            backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            -- height and width can be:
            -- * an absolute number of cells when > 1
            -- * a percentage of the width / height of the editor when <= 1
            -- * a function that returns the width or the height
            width = 150, -- width of the Zen window
            height = 1, -- height of the Zen window
            -- by default, no options are changed for the Zen window
            -- uncomment any of the options below, or add other vim.wo options you want to apply
            options = {
                wrap = true, -- disable Zen's wrapping
                -- signcolumn = "no", -- disable signcolumn
                -- number = false, -- disable number column
                -- relativenumber = false, -- disable relative numbers
                -- cursorline = false, -- disable cursorline
                -- cursorcolumn = false, -- disable cursor column
                -- foldcolumn = "0", -- disable fold column
                -- list = false, -- disable whitespace characters
            },
        },
        plugins = {
            -- disable some global vim options (vim.o...)
            -- comment the lines to not apply the options
            options = {
                enabled = true,
                ruler = false, -- disables the ruler text in the cmd line area
                showcmd = false, -- disables the command in the last line of the screen
                -- you may turn on/off statusline in zen mode by setting 'laststatus'
                -- statusline will be shown only if 'laststatus' == 3
                laststatus = 0, -- turn off the statusline in zen mode
            },
            twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
            gitsigns = { enabled = true }, -- disables git signs
            tmux = { enabled = vim.fn.getenv("TMUX") }, -- disables the tmux statusline

            -- this will change the font size on kitty when in zen mode
            -- to make this work, you need to set the following kitty options:
            -- - allow_remote_control socket-only
            -- - listen_on unix:/tmp/kitty
            kitty = {
                enabled = true,
                font = "+4", -- font size increment
            },
            -- this will change the font size on alacritty when in zen mode
            -- requires  Alacritty Version 0.10.0 or higher
            -- uses `alacritty msg` subcommand to change font size
            alacritty = {
                enabled = false,
                font = "14", -- font size
            },
            -- this will change the font size on wezterm when in zen mode
            -- See alse also the Plugins/Wezterm section in this projects README
            wezterm = {
                enabled = false,
                -- can be either an absolute font size or the number of incremental steps
                font = "+4", -- (10% increase per step)
            },
        },
    },
    keys = {
        {
            "<Leader>z",
            function()
                require("zen-mode").toggle()
            end,
            "General: [Z]en Mode",
        },
    },
})
folke({
    "folke/twilight.nvim",
    lazy = true,
    cmd = {
        "Twilight",
    },
    config = true,
})

folke({
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
        -- add any custom options here
    },
})
folke({
    "folke/drop.nvim",
    event = "VimEnter",
    config = function()
        require("drop").setup()
    end,
})
