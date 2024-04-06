local conf = require("modules.notes.config")
local notes = require("core.pack").package
notes({
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
})
notes({
    "nvim-neorg/neorg",
    ft = { "norg" },
    branch = "luarocks",
    init = function()
        vim.defer_fn(function()
            require("modules.notes.norg.commands").setup({})
            require("modules.notes.norg.autocmd").setup({})
        end, 500)
    end,
    dependencies = {
        "vhyrro/luarocks.nvim",
        -- "3rd/image.nvim",
        {
            "jarvismkennedy/neorg-roam.nvim",
            cond = true,
            branch = "dev",
            dependencies = {
                "nvim-telescope/telescope.nvim",
                "nvim-lua/plenary.nvim",
            },
        },
        "nvim-neorg/neorg-telescope",
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-cmp",
        "mason.nvim",
        "plenary.nvim",
        "image.nvim",
        "laher/neorg-exec",
        "phenax/neorg-hop-extras",
        { "pysan3/neorg-templates-draft", dependencies = { "L3MON4D3/LuaSnip" } },
        { "nvim-neorg/neorg-telescope", dependencies = { "nvim-telescope/telescope.nvim" } },
    },
    opts = require("modules.notes.neorg").opts,
    config = require("modules.notes.neorg").config,
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
    ft = { "markdown" },
    config = conf.table,
})

notes({
    "3rd/image.nvim",
    init = function()
        package.path = package.path .. ";/home/viv/.luarocks/share/lua/5.1/?/init.lua;"
        package.path = package.path .. ";/home/viv/.luarocks/share/lua/5.1/?.lua;"
    end,
    lazy = true,
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
    config = function(_, opts)
        require("image").setup(opts)
    end,
})
notes({
    "aaron-p1/virt-notes.nvim",
    keys = { "<leader>va", "<leader>vc", "<leader>ve", "<leader>vp", "<leader>vx", "<leader>vdd", "<leader>vdl" },
    config = true,
})
notes({
    "ellisonleao/glow.nvim",
    opts = {
        install_path = "/home/viv/.local/share/zinit/plugins/charmbracelet---glow/",
        style = "dark",
    },
    cmd = "Glow",
})
