local ui = {}
local conf = require("modules.ui.config")
local package = require("core.pack").package
package({ "j-hui/fidget.nvim", opt = true, ft = { "python", "lua", "c" }, config = conf.fidget })
package({ "camspiers/animate.vim", opt = true })

package({ "kyazdani42/nvim-web-devicons" })

package({ "rebelot/heirline.nvim", opt = true })

package({ "mvllow/modes.nvim", event = "BufEnter", config = conf.modes })

package({ "akinsho/bufferline.nvim", config = conf.nvim_bufferline, event = "UIEnter", opt = true })

-- Lazy Loading nvim-notify
package({
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

package({ "MunifTanjim/nui.nvim", opt = true })

-- Feels slow, might revert backto nvim tree
package({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
        "MunifTanjim/nui.nvim",
        {
            -- only needed if you want to use the "open_window_picker" command
            "s1n7ax/nvim-window-picker",
            tag = "1.*",
            opt = true,
            after = "neo-tree.nvim",
            config = function()
                require("window-picker").setup({
                    autoselect_one = true,
                    include_current = false,
                    filter_rules = {
                        -- filter using buffer options
                        bo = {
                            -- if the file type is one of following, the window will be ignored
                            filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

                            -- if the buffer type is one of following, the window will be ignored
                            buftype = { "terminal" },
                        },
                    },
                    other_win_hl_color = "#e35e4f",
                })
            end,
        },
    },
    cmd = { "Neotree", "NeoTreeShow", "NeoTreeFocus", "NeoTreeFocusToggle" },
    config = conf.neo_tree,
})

package({
    "tamton-aquib/keys.nvim",
    cmd = "KeysToggle",
    opt = true,
    config = function()
        require("keys").setup()
    end,
})

-- Use this with nvimtree .
package({ "elihunter173/dirbuf.nvim", cmd = { "Dirbuf" }, config = conf.dir_buff })

package({ "lukas-reineke/indent-blankline.nvim", opt = true, config = conf.blankline }) -- after="nvim-treesitter",

-- disabled does not work with muliti split
package({
    "lukas-reineke/virt-column.nvim",
    opt = true,
    -- event = {"CursorMoved", "CursorMovedI"},
    config = function()
        vim.cmd("highlight clear ColorColumn")
        require("virt-column").setup()

        vim.cmd("highlight VirtColumn guifg=#4358BF")
    end,
})

-- No longer getting lazy loaded, i like this though
package({ "lewis6991/satellite.nvim", config = conf.satellite })

package({
    "xiyaowong/nvim-transparent",
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    config = conf.transparent,
})

package({
    "anuvyklack/pretty-fold.nvim",
    ft = { "python", "c", "lua", "cpp", "java" },
    config = conf.pretty_fold,
})

package({
    "folke/tokyonight.nvim",
    opt = true,
    setup = conf.tokyonight,
    config = function()
        vim.cmd([[hi CursorLine guibg=#353644]])
        vim.cmd([[colorscheme tokyonight]])
    end,
})

package({
    "tiagovla/tokyodark.nvim",
    opt = true,
    setup = conf.tokyodark,
    config = function()
        vim.cmd([[hi CursorLine guibg=#353644]])
        vim.cmd([[colorscheme tokyodark]])
    end,
})

package({ "catppuccin/nvim", as = "catppuccin", opt = true, config = conf.catppuccin })
package({ "jzone1366/chalklines.nvim", as = "chalklines", opt = true, config = conf.chalk })

-- fix annoying strikethrough issue as that was not a valid key apparently .
package({
    "~/GitHub/Sakura.nvim",
    module = "Sakura",
    opt = true,
    config = function()
        vim.cmd([[colorscheme sakura]])
    end,
})

-- Use default when loading this .
package({ "rebelot/kanagawa.nvim", opt = true, config = conf.kanagawa })

package({ "kazhala/close-buffers.nvim", cmd = { "BDelete", "BWipeout" }, config = conf.buffers_close })

package({
    "narutoxy/dim.lua",
    ft = { "python", "lua" },
    requires = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
    config = conf.dim,
})

package({ "max397574/colortils.nvim", cmd = "Colortils", config = conf.colourutils })

-- return ui
