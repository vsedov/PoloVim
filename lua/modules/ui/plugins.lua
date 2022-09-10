local conf = require("modules.ui.config")
local ui = require("core.pack").package
function not_headless()
    return #vim.api.nvim_list_uis() > 0
end
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
    ft = {
        "python",
        "lua",
        "js",
        "json",
        "go",
        "cpp",
        "c",
    },
    setup = function()
        vim.g.hlchunk_files = "*.ts,*.js,*.json,*.go,*.cpp,*.c,*.lua,*.py"
    end,
})

ui({
    "lewis6991/satellite.nvim",
    opt = true,
    ft = lambda.config.main_file_types,
    config = conf.satellite,
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
    "kazhala/close-buffers.nvim",
    cmd = { "Kwbd", "BDelete", "BWipeout" },
    module = "close-buffers",
    config = conf.buffers_close,
})

ui({
    "levouh/tint.nvim",
    opt = true,
    event = "BufEnter",
    config = function()
        require("tint").setup({
            tint = -30,
            highlight_ignore_patterns = {
                "WinSeparator",
                "St.*",
                "Comment",
                "Panel.*",
                "Telescope.*",
                "Bqf.*",
            },
            window_ignore_function = function(win_id)
                if vim.wo[win_id].diff or vim.fn.win_gettype(win_id) ~= "" then
                    return true
                end
                local buf = vim.api.nvim_win_get_buf(win_id)
                local b = vim.bo[buf]
                local ignore_bt = { "terminal", "prompt", "nofile" }
                local ignore_ft = {
                    "neo-tree",
                    "packer",
                    "diff",
                    "toggleterm",
                    "Neogit.*",
                    "Telescope.*",
                    "qf",
                }
                return lambda.any(b.bt, ignore_bt) or lambda.any(b.ft, ignore_ft)
            end,
        })
    end,
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
    "RRethy/vim-illuminate",
    event = "BufEnter",
    config = conf.illuminate,
})
