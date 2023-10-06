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
    init = function()
        vim.opt.laststatus = 3
        vim.opt.splitkeep = "screen"
    end,

    opts = conf.edgy,
})

folke({
    "folke/noice.nvim",
    event = "VeryLazy",
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
    lazy = true,
    event = "VeryLazy",
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
    event = "VeryLazy",
    config = conf.zen,
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
    },
})
-- folke({
--     "folke/twilight.nvim",
--     event = "VeryLazy",
--     config = true,
-- })
