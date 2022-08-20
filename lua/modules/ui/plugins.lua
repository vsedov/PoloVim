local conf = require("modules.ui.config")
local ui = require("core.pack").package
-- ui({ "j-hui/fidget.nvim", opt = true, ft = { "julia", "python", "lua", "c" }, config = conf.fidget })

ui({ "kyazdani42/nvim-web-devicons" })

ui({
    lambda.use_local("heirline.nvim", "contributing"),
    after = "nvim-lspconfig",
    config = function()
        require("modules.ui.heirline")
        -- require("modules.ui.heirline_min")
    end,
})

ui({ "mvllow/modes.nvim", event = "BufEnter", config = conf.modes })

ui({
    "akinsho/bufferline.nvim",
    config = conf.nvim_bufferline,
    opt = true,
})

ui({
    "nanozuki/tabby.nvim",
    config = conf.tabby,
    opt = true,
})

-- Lazy Loading nvim-notify
ui({
    "rcarriga/nvim-notify",
    opt = true,
    setup = function()
        vim.notify = function(msg, level, opts)
            require("packer").loader("nvim-notify")
            vim.notify = require("notify")
            vim.notify(msg, level, opts)
        end
    end,
    requires = "telescope.nvim", -- this might not be needed
    config = conf.notify,
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
    branch = "v2.x",
    requires = {
        "MunifTanjim/nui.nvim",
        {
            -- only needed if you want to use the "open_window_picker" command
            "s1n7ax/nvim-window-picker",
            -- tag = "v1.2",
            tag = "v1.*",
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

                            -- if the buffer type is one of following, the window will be ignored
                            buftype = { "terminal" },
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

-- No longer getting lazy loaded, i like this though
ui({ "lewis6991/satellite.nvim", config = conf.satellite })

ui({
    "xiyaowong/nvim-transparent",
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    config = conf.transparent,
})

-- ui({
--     "anuvyklack/pretty-fold.nvim",
--     -- ft = { "python", "c", "lua", "cpp", "java" },
--     config = conf.pretty_fold,
-- })

ui({
    "kevinhwang91/nvim-ufo",
    --[[ ft = lambda.config.main_file_types, ]]
    event = "BufEnter",
    requires = { "kevinhwang91/promise-async", after = "nvim-ufo" },
    config = conf.ufo,
})

ui({ "kazhala/close-buffers.nvim", cmd = { "BDelete", "BWipeout" }, config = conf.buffers_close })

ui({
    "zbirenbaum/neodim",
    ft = { "python", "lua" },
    requires = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
    config = conf.dim,
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
