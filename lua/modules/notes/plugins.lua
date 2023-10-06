local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    "nvim-neorg/neorg",
    ft = "norg",
    lazy = true,
    cmd = "Neorg",
    init = function()
        require("modules.notes.norg.commands").setup({})
        require("modules.notes.norg.autocmd").setup({})
    end,
    dependencies = {
        "3rd/image.nvim",
        {
            "jarvismkennedy/neorg-roam.nvim",
            branch = "dev",
            dependencies = {
                "nvim-telescope/telescope.nvim",
                "nvim-lua/plenary.nvim",
            },
        },
        "nvim-neorg/neorg-telescope",
        {
            "jbyuki/nabla.nvim",
            ft = "norg",
            config = function()
                require("nabla").enable_virt({
                    autogen = true, -- auto-regenerate ASCII art when exiting insert mode
                    silent = true, -- silents error messages
                })
            end,
        },
        { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } }, -- ADD THIS LINE
        {
            "Jarvismkennedy/git-auto-sync.nvim",
            opts = {
                {
                    "~/Documents/PhD_Norg",
                    "~/neorg",
                    auto_commit = true,
                    prompt = false,
                },
            },
        },
    },
    build = ":Neorg sync-parsers",
    opts = require("modules.notes.neorg").opts,
    config = require("modules.notes.neorg").config,
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
    init = function()
        package.path = package.path .. ";/home/viv/.luarocks/share/lua/5.1/?/init.lua;"
        package.path = package.path .. ";/home/viv/.luarocks/share/lua/5.1/?.lua;"
    end,
    opts = {
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
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        kitty_method = "normal",
        kitty_tmux_write_delay = 10,
    },
})
notes({
    "aaron-p1/virt-notes.nvim",
    keys = { "<leader>va", "<leader>vc", "<leader>ve", "<leader>vp", "<leader>vx", "<leader>vdd", "<leader>vdl" },
    config = true,
})
