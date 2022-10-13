local conf = require("modules.ui.config")
local ui = require("core.pack").package

ui({
    "j-hui/fidget.nvim",
    opt = true,
    config = conf.fidget,
})
ui({ "kyazdani42/nvim-web-devicons" })

ui({
    "rebelot/heirline.nvim",
    after = "nvim-lspconfig",
    config = function()
        require("modules.ui.heirline")
        -- require("modules.ui.heirline_min")
    end,
})

ui({ "mvllow/modes.nvim", event = "BufEnter", config = conf.modes })
-- todo: FIX THIS
ui({
    "rcarriga/nvim-notify",
    opt = true,
    requires = "telescope.nvim", -- this might not be needed
    config = conf.notify,
})

ui({
    "vigoux/notifier.nvim",
    opt = true,
    config = conf.notifier,
})

ui({ "MunifTanjim/nui.nvim", modules = "nui" })

-- -- Feels slow, might revert backto nvim tree
ui({
    "mrbjarksen/neo-tree-diagnostics.nvim",
    requires = "nvim-neo-tree/neo-tree.nvim",
    module = "neo-tree.sources.diagnostics", -- if wanting to lazyload
})
ui({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    requires = {
        "MunifTanjim/nui.nvim",
        {
            -- only needed if you want to use the "open_window_picker" command
            "s1n7ax/nvim-window-picker",
            opt = true,
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
    module = "neo-tree", -- if wanting to lazyload
    cmd = { "Neotree", "NeoTreeShow", "NeoTreeFocus", "NeoTreeFocusToggle" },
    config = conf.neo_tree,
})

ui({
    "tamton-aquib/keys.nvim",
    cmd = "KeysToggle",
    opt = true,
    config = function()
        require("keys").setup()
    end,
})

ui({
    "lukas-reineke/indent-blankline.nvim",
    branch = "develop",
    opt = true,
    config = conf.blankline,
}) -- after="nvim-treesitter",
ui({
    "yaocccc/nvim-hlchunk",
    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "BufWinEnter",
            augroup_name = "hlchunk",
            condition = lambda.config.use_hlchunk,
            plugin = "nvim-hlchunk",
        })
    end,
    config = function()
        vim.g.hlchunk_files = "*.ts,*.js,*.json,*.go,*.cpp,*.c,*.lua,*.py"
    end,
})

ui({
    "xiyaowong/nvim-transparent",
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    config = conf.transparent,
})

ui({
    "kevinhwang91/nvim-ufo",
    event = "BufEnter",
    requires = { "kevinhwang91/promise-async", after = "nvim-ufo" },
    config = conf.ufo,
})

ui({
    "Vonr/foldcus.nvim",
    after = "nvim-ufo",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = conf.fold_focus,
})

ui({
    "levouh/tint.nvim",
    opt = true,
    event = "BufEnter",
    config = conf.tint,
})

ui({ "max397574/colortils.nvim", cmd = "Colortils", config = conf.colourutils })

ui({
    "akinsho/clock.nvim",
    opt = true,
    setup = conf.clock_setup,
    config = conf.clock,
})

ui({
    "glepnir/dashboard-nvim",
    as = "dashboard",
    cmd = { "DashboardNewFile" },
    opt = true,
    setup = conf.dashboard_setup,
    config = conf.dashboard_config,
})

ui({
    "xiyaowong/virtcolumn.nvim",
    event = "BufEnter",
})

ui({
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    after = "nvim-ufo",
    config = function()
        require("neoscroll").setup()
    end,
})

ui({
    "stevearc/dressing.nvim",
    event = "BufWinEnter",
    config = conf.dressing,
})

ui({
    "folke/noice.nvim",
    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "VimEnter",
            augroup_name = "noice",
            condition = lambda.config.use_noice,
            plugin = "noice.nvim",
        })
    end,
    requires = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "nui.nvim",
        "nvim-notify",
        "hrsh7th/nvim-cmp",
    },
    config = conf.noice,
})

ui({
    "RRethy/vim-illuminate",
    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "illuminate",
            condition = true,
            plugin = "vim-illuminate",
        })
    end,
    config = conf.illuminate,
})
ui({
    "rainbowhxch/beacon.nvim",

    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "beacon",
            condition = true,
            plugin = "beacon.nvim",
        })
    end,
    config = conf.beacon,
})

ui({
    "samuzora/pet.nvim",
    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "pet",
            condition = lambda.config.use_pet,
            plugin = "pet.nvim",
        })
    end,
    config = function()
        require("pet-nvim")
    end,
})
