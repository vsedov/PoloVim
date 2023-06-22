local folke = require("core.pack").package
local conf = require("modules.folke.config")

folke({
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = conf.edgy,
})

folke({
    "folke/noice.nvim",
    event = "VeryLazy",
    cond = lambda.config.ui.noice.enable,
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
    opts = { library = {
        plugins = { "nvim-dap-ui" },
    } },
})
folke({
    "folke/paint.nvim",
    lazy = true,
    ft = "lua",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.paint,
})
