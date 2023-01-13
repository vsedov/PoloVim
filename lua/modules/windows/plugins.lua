local conf = require("modules.windows.config")
local windows = require("core.pack").package
-- --  Possible, ONE Can be causing huge LAG, it could be a viability : :think:
windows({
    "szw/vim-maximizer",
    lazy = true,
    cmd = "MaximizerToggle",
})

--  Possible, ONE Can be causing huge LAG, it could be a viability : :think:
windows({
    "mrjones2014/smart-splits.nvim",
    lazy = true,
})

windows({
    "tamton-aquib/flirt.nvim",
    lazy = true,
    event = "FileType",
    config = function()
        require("flirt").setup({
            override_open = true, -- experimental
            close_command = "Q",
            default_move_mappings = true, -- <C-arrows> to move floats
            default_resize_mappings = true, -- <A-arrows> to resize floats
            default_mouse_mappings = true, -- Drag floats with mouse
            exclude_fts = { "notify", "cmp_menu", "harpoon", "hydra_hint" },
            custom_filter = function(buffer, win_config)
                return vim.bo[buffer].filetype == "cmp_menu" or vim.bo[buffer].buftype == "hydra_hint"
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
        "<c-w>z",
        ";z",
    },
    config = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
        require("windows").setup()
        vim.keymap.set("n", ";z", "<Cmd>WindowsMaximize<CR>")
    end,
})

-- What tf is this plugin ?
windows({
    "andrewferrier/wrapping.nvim",
    lazy = true,
    config = true,
    ft = { "tex", "norg", "latex", "text" },
})

windows({
    "princejoogie/chafa.nvim",
    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "m00qek/baleia.nvim",
    },
    cmd = { "ViewImage" },
    config = true,
})
