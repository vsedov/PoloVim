local conf = require("modules.windows.config")
local windows = require("core.pack").package
--  Possible, ONE Can be causing huge LAG, it could be a viability : :think:
windows({
    "szw/vim-maximizer",
    cmd = "MaximizerToggle!",
})

--  Possible, ONE Can be causing huge LAG, it could be a viability : :think:
windows({
    "mrjones2014/smart-splits.nvim",
    module = "smart-splits",
})

windows({
    "tamton-aquib/flirt.nvim",
    keys = {
        "<C-down>",
        "<C-up>",
        "<C-right>",
        "<C-left>",
        "<A-up>",
        "<A-down>",
        "<A-left>",
        "<A-right>",
    },
    config = function()
        require("flirt").setup({
            override_open = false, -- experimental
            close_command = "Q",
            default_move_mappings = true, -- <C-arrows> to move floats
            default_resize_mappings = true, -- <A-arrows> to resize floats
        })
    end,
})

windows({ "sindrets/winshift.nvim", cmd = "WinShift", opt = true, config = conf.winshift })

windows({
    "anuvyklack/windows.nvim",
    requires = {
        { "anuvyklack/middleclass", opt = true },
        { "anuvyklack/animation.nvim", opt = true },
    },
    opt = true,
    cmd = {

        "WindowsMaximize",
        "WindowsMaximize!",
        "WindowsToggleAutowidth",
        "WindowsEnableAutowidth",
        "WindowsDisableAutowidth",
    },
    keys = {
        "<c-w>z",
        ";z",
    },
    config = function()
        vim.cmd([[packadd middleclass]])
        vim.cmd([[packadd animation.nvim]])
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
    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "wrapping",
            condition = lambda.config.use_wrapping,
            plugin = "wrapping.nvim",
        })
    end,
    config = function()
        require("wrapping").setup()
    end,
})
