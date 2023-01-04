local ui = require("core.pack").package
local conf = require("modules.ui.config")

ui({
    "strash/strash/everybody-wants-that-line.nvim",
    lazy = true,
    event = "VeryLazy",
    config = conf.ever_body_line,
})

ui({
    "xiyaowong/virtcolumn.nvim",
    event = "VeryLazy",
})

ui({
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = conf.dressing,
})

ui({ "MunifTanjim/nui.nvim", event = "VeryLazy", lazy = true })

--  ──────────────────────────────────────────────────────────────────────
-- Force Lazy
--  ──────────────────────────────────────────────────────────────────────

ui({
    "RRethy/vim-illuminate",
    lazy = true,
    config = conf.illuminate,
})

ui({
    "nyngwang/murmur.lua",
    lazy = true,
    config = conf.murmur,
})

ui({
    "j-hui/fidget.nvim",
    lazy = true,
    config = conf.fidget,
})
-- ui({
--     "mvllow/modes.nvim",
--     lazy = true,
--     config = conf.modes,
-- })

--  ──────────────────────────────────────────────────────────────────────
--  ──────────────────────────────────────────────────────────────────────

ui({
    "nvim-tree/nvim-web-devicons",
    config = function()
        require("nvim-web-devicons").setup({
            override = {
                zsh = {
                    icon = "",
                    color = "#428850",
                    cterm_color = "65",
                    name = "Zsh",
                },
            },
            color_icons = true,
            default = true,
        })
    end,
})

-- -- -- todo: FIX THIS
ui({
    "rcarriga/nvim-notify",
    lazy = true,
    config = conf.notify,
})

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
    -- event = "VeryLazy",
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

ui({ "max397574/colortils.nvim", cmd = "Colortils", config = conf.colourutils })

ui({
    "Vonr/foldcus.nvim",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { "z;", "z'" },
    cmd = { "Foldcus", "Unfoldcus" },
    config = conf.fold_focus,
})

ui({
    "folke/noice.nvim",
    lazy = not lambda.config.ui.noice.enable,
    dependencies = {
        "nui.nvim",
        "nvim-notify",
        "hrsh7th/nvim-cmp",
    },
    config = conf.noice,
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
