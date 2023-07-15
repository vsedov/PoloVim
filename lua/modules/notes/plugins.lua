local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    "nvim-neorg/neorg",
    build = ":Neorg sync-parser",
    opts = require("modules.notes.neorg").opts,
})

notes({
    "AckslD/nvim-FeMaco.lua",
    lazy = true,
    ft = { "norg", "markdown", "tex" },
    cmd = "FeMaco",
    config = conf.femaco,
})

notes({
    "jubnzv/mdeval.nvim",
    lazy = true,
    ft = { "norg" },
    config = conf.mdeval,
})

notes({
    "dhruvasagar/vim-table-mode",
    lazy = true,
    cmd = "TableModeToggle",
    ft = { "norg", "markdown" },
    config = conf.table,
})

notes({
    "3rd/image.nvim",
    lazy = true,
    ft = {
        "org",
        "norg",
        "tex",
    },
    config = function()
        require("image").setup({
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    sizing_strategy = "auto",
                    download_remote_images = true,
                    clear_in_insert_mode = false,
                },
                neorg = {
                    enabled = true,
                    download_remote_images = true,
                    clear_in_insert_mode = false,
                },
            },
            max_width = nil,
            max_height = nil,
            max_width_window_percentage = nil,
            max_height_window_percentage = 50,
            kitty_method = "normal",
            kitty_tmux_write_delay = 10, -- makes rendering more reliable with Kitty+Tmux
        })
    end,
})
