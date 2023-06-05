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
    lazy = true,
    build = "./kitty/install-kittens.bash",
    config = true,
})

windows({
    "tamton-aquib/flirt.nvim",
    cond = lambda.config.ui.flirt.use_flirt,
    lazy = true,
    event = "BufEnter",
    config = function()
        require("flirt").setup({
            override_open = lambda.config.ui.flirt.use_flirt_override, -- experimental
            close_command = "Q",
            default_move_mappings = lambda.config.ui.flirt.move_mappings, -- <C-arrows> to move floats
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

windows({ "sindrets/winshift.nvim", lazy = true, cmd = "WinShift", config = conf.winshift })

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
        ";z",
        ";Z",
    },
    config = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
        require("windows").setup()
        vim.keymap.set("n", ";z", "<Cmd>WindowsMaximize<CR>")
        vim.keymap.set("n", ";Z", "<Cmd>WindowsDisableAutowidth<CR>")
    end,
})

-- What tf is this plugin ?
windows({
    "andrewferrier/wrapping.nvim",
    lazy = true,
    config = true,
    ft = { "tex", "norg", "latex", "text" },
})
