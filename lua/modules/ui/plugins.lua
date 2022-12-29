local ui = require("core.pack").package
local conf = require("modules.ui.config")

ui({
    "j-hui/fidget.nvim",
    lazy = true,
    config = conf.fidget,
})

ui({
    "nvim-tree/nvim-web-devicons",

    config = function()
        require("nvim-web-devicons").setup({
            -- your personnal icons can go here (to override)
            -- you can specify color or cterm_color instead of specifying both of them
            -- DevIcon will be appended to `name`
            override = {
                zsh = {
                    icon = "",
                    color = "#428850",
                    cterm_color = "65",
                    name = "Zsh",
                },
            },
            -- globally enable different highlight colors per icon (default to true)
            -- if set to false all icons will have the default icon's color
            color_icons = true,
            -- globally enable default icons (default to false)
            -- will get overriden by `get_icons` option
            default = true,
        })
    end,
})

-- -- ui({
-- --     "rebelot/heirline.nvim",
-- --     after = "nvim-lspconfig",
-- --     config = function()
-- --         require("modules.ui.heirline")
-- --         -- require("modules.ui.heirline_min")
-- --     end,
-- -- })

ui({ "mvllow/modes.nvim", event = "BufEnter", config = conf.modes })
-- -- -- todo: FIX THIS
ui({
    "rcarriga/nvim-notify",
    lazy = true,
    config = conf.notify,
})

ui({ "MunifTanjim/nui.nvim", lazy = true })

-- -- -- Feels slow, might revert backto nvim tree
ui({
    "mrbjarksen/neo-tree-diagnostics.nvim",
    dependencies = "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
})
ui({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
        "MunifTanjim/nui.nvim",
        {
            -- only needed if you want to use the "open_window_picker" command
            "s1n7ax/nvim-window-picker",
            lazy = true,
            after = "neo-tree.nvim",
            config = function()
                require("window-picker").setup({
                    autoselect_one = true,
                    include_current = true,
                    filter_rules = {
                        -- filter using buffer options
                        bo = {
                            -- if the file type is one of following, the window will be ignored
                            filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },
                            buftype = { "terminal", "quickfix", "nofile" },
                        },
                    },
                    other_win_hl_color = require("utils.ui.highlights").get("Visual", "bg"),
                })
            end,
        },
    },
    cmd = { "Neotree", "NeoTreeShow", "NeoTreeFocus", "NeoTreeFocusToggle" },
    config = conf.neo_tree,
})

ui({
    "lukas-reineke/indent-blankline.nvim",
    branch = "develop",
    lazy = true,
    config = conf.blankline,
}) -- after="nvim-treesitter",

ui({
    "xiyaowong/nvim-transparent",
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    config = conf.transparent,
})

ui({
    "kevinhwang91/promise-async",
    lazy = true,
})
ui({
    "kevinhwang91/nvim-ufo",
    lazy = true,
    config = conf.ufo,
})

ui({
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    lazy = true,
    config = function()
        require("neoscroll").setup({
            mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = true, -- Stop at <EOF> when scrolling downwards
            respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
            easing_function = nil, -- Default easing function
            pre_hook = nil, -- Function to run before the scrolling animation starts
            post_hook = nil, -- Function to run after the scrolling animation ends
            performance_mode = true, -- Disable "Performance Mode" on all buffers.
        })
    end,
})

--  REVISIT: (vsedov) (03:44:46 - 16/11/22): What does this plugin do again ?
ui({
    "Vonr/foldcus.nvim",
    after = "nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.fold_focus,
})

ui({ "max397574/colortils.nvim", cmd = "Colortils", config = conf.colourutils })

ui({
    "akinsho/clock.nvim",
    lazy = true,
    init = conf.clock_setup,
    config = conf.clock,
})

ui({
    "xiyaowong/virtcolumn.nvim",
    event = "BufEnter",
})

ui({
    "stevearc/dressing.nvim",
    event = "BufWinEnter",
    config = conf.dressing,
})

ui({
    "folke/noice.nvim",
    lazy = not lambda.config.ui.noice.enable,
    after = "leap.nvim",
    dependencies = {
        "nui.nvim",
        "nvim-notify",
        "hrsh7th/nvim-cmp",
    },
    config = conf.noice,
})

ui({
    "RRethy/vim-illuminate",
    lazy = true,

    config = conf.illuminate,
})
ui({
    "nyngwang/murmur.lua",
    lazy = true,
    config = function()
        require("murmur").setup({
            -- cursor_rgb = 'purple', -- default to '#393939'
            max_len = 80, -- maximum word-length to highlight
            -- disable_on_lines = 2000, -- to prevent lagging on large files. Default to 2000 lines.
            exclude_filetypes = {},
            callbacks = {
                -- to trigger the close_events of vim.diagnostic.open_float.
                function()
                    -- Close floating diag. and make it triggerable again.
                    vim.cmd("doautocmd InsertEnter")
                    vim.w.diag_shown = false
                end,
            },
        })
    end,
})

ui({
    "rainbowhxch/beacon.nvim",
    lazy = true,
    config = conf.beacon,
})

ui({
    "samuzora/pet.nvim",
    lazy = true,
    config = function()
        require("pet-nvim")
    end,
})

ui({
    "tamton-aquib/duck.nvim",
    cmd = {
        "DuckUse",
        "DuckStop",
    },
    config = function()
        require("duck").setup({
            height = 5,
            width = 5,
        })
        lambda.command("DuckUse", function()
            require("duck").hatch("🐼")
        end, {})
        lambda.command("DuckStop", function()
            require("duck").cook()
        end, {})
    end,
})

-- True emotional Support
ui({ "rtakasuke/vim-neko", cmd = "Neko", lazy = true })
