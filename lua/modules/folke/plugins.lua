local folke = require("core.pack").package
local conf = require("modules.folke.config")

folke({
    "folke/edgy.nvim",
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
    event = "VeryLazy",
    cond = lambda.config.folke.noice.enable,
    dependencies = {
        "nui.nvim",
        "nvim-notify",
    },
    opts = require("modules.folke.noice").noice,
    config = require("modules.folke.noice").noice_setup,
})

folke({
    "folke/which-key.nvim",
    cond = lambda.config.tools.use_which_key_or_use_mini_clue == "which",
    event = "CursorMoved",
    lazy = true,
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("todo-comments").setup()
        lambda.command("TodoDots", ("TodoQuickFix cwd=%s keywords=TODO,FIXME"):format(vim.g.vim_dir))
    end,
    cmd = {
        "TodoComments",
        "TodoQuickFix",
        "TodoDots",
    },
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
    ft = "lua",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.paint,
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
    "folke/zen-mode.nvim",
    lazy = true,
    opts = {
        -- - listen_on unix:/tmp/kitty
        kitty = {
            enabled = true,
            font = "+4", -- font size increment
        },
    },
    keys = {
        {
            "<Leader>z",
            function()
                vim.cmd("ZenMode")
            end,
            desc = "General: [Z]en Mode",
        },
    },
})
