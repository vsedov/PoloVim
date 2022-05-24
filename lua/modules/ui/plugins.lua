local ui = {}
local conf = require("modules.ui.config")

--
local winwidth = function()
    return vim.api.nvim_call_function("winwidth", { 0 })
end

ui["kyazdani42/nvim-web-devicons"] = {}

ui["rebelot/heirline.nvim"] = {
    opt = true,
}

ui["b0o/incline.nvim"] = {
    opt = true,
    ft = { "python", "lua", "c", "cpp", "rust" },
    after = "heirline.nvim",
    config = conf.incline,
}

ui["mvllow/modes.nvim"] = {
    event = "BufEnter",

    config = function()
        require("modes").setup({
            colors = {
                copy = "#f5c359",
                delete = "#c75c6a",
                insert = "#78ccc5",
                visual = "#9745be",
            },

            -- Set opacity for cursorline and number background
            line_opacity = 0.15,

            -- Enable cursor highlights
            set_cursor = true,

            -- Enable cursorline initially, and disable cursorline for inactive windows
            -- or ignored filetypes
            set_cursorline = true,

            -- Enable line number highlights to match cursorline
            set_number = true,

            -- Disable modes highlights in specified filetypes
            -- Please PR commonly ignored filetypes
            ignore_filetypes = { "NvimTree", "TelescopePrompt", "NeoTree" },
        })
    end,
}

ui["akinsho/bufferline.nvim"] = {
    config = conf.nvim_bufferline,
    event = "UIEnter",
    -- after = {"aurora"}
    -- requires = {'kyazdani42/nvim-web-devicons'}
    opt = true,
}

-- Lazy Loading nvim-notify
ui["rcarriga/nvim-notify"] = {
    opt = true,
    requires = "telescope.nvim", -- this might not be needed
    config = conf.notify,
}

-- ui["kyazdani42/nvim-tree.lua"] = {
--     cmd = { "NvimTreeToggle", "NvimTreeOpen" },
--     -- requires = {'kyazdani42/nvim-web-devicons'},
--     config = conf.nvim_tree_setup,
-- }
ui["MunifTanjim/nui.nvim"] = {
    opt = true,
}

-- Feels slow, might revert backto nvim tree
ui["nvim-neo-tree/neo-tree.nvim"] = {
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
}

ui["tamton-aquib/keys.nvim"] = {
    cmd = "KeysToggle",
    opt = true,
    config = function()
        require("keys").setup()
    end,
}

-- Use this with nvimtree .
ui["elihunter173/dirbuf.nvim"] = {
    cmd = { "Dirbuf" },
    config = conf.dir_buff,
}

ui["lukas-reineke/indent-blankline.nvim"] = { opt = true, config = conf.blankline } -- after="nvim-treesitter",

-- disabled does not work with muliti split
ui["lukas-reineke/virt-column.nvim"] = {
    opt = true,
    -- event = {"CursorMoved", "CursorMovedI"},
    config = function()
        vim.cmd("highlight clear ColorColumn")
        require("virt-column").setup()

        vim.cmd("highlight VirtColumn guifg=#4358BF")
    end,
}

-- ui["dstein64/nvim-scrollview"] = {
--   event = { "CursorMoved", "CursorMovedI" },
--   config = conf.scrollview,
-- }

-- ui["lewis6991/satellite.nvim"] = {
--     event = { "CursorMoved", "CursorMovedI" },
--     config = conf.satellite,
-- }

ui["petertriho/nvim-scrollbar"] = {
    event = { "CursorMoved", "CursorMovedI" },
    config = conf.scrollbar,
}

ui["xiyaowong/nvim-transparent"] = {
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    config = function()
        require("transparent").setup({
            enable = false,
            -- additional groups that should be clear
            extra_groups = {
                -- example of akinsho/nvim-bufferline.lua
                "BufferLineTabClose",
                "BufferlineBufferSelected",
                "BufferLineFill",
                "BufferLineBackground",
                "BufferLineSeparator",
                "BufferLineIndicatorSelected",
            },
            -- groups you don't want to clear
            exclude = {},
        })
    end,
}

ui["anuvyklack/pretty-fold.nvim"] = {
    ft = { "python", "c", "lua", "cpp", "java" },
    requires = { "anuvyklack/nvim-keymap-amend", opt = true, after = "pretty-fold.nvim" },
    config = conf.pretty_fold,
}

ui["folke/tokyonight.nvim"] = {
    opt = true,
    setup = conf.tokyonight,
    config = function()
        vim.cmd([[hi CursorLine guibg=#353644]])
        vim.cmd([[colorscheme tokyonight]])
    end,
}

ui["tiagovla/tokyodark.nvim"] = {
    opt = true,
    setup = conf.tokyodark,
    config = function()
        vim.cmd([[hi CursorLine guibg=#353644]])
        vim.cmd([[colorscheme tokyodark]])
    end,
}

ui["catppuccin/nvim"] = {
    as = "catppuccin",
    opt = true,
    config = conf.catppuccin,
}
ui["jzone1366/chalklines.nvim"] = {
    as = "chalklines",
    opt = true,
    config = conf.chalk,
}

-- fix annoying strikethrough issue as that was not a valid key apparently .
ui["~/GitHub/Sakura.nvim"] = {
    module = "Sakura",
    opt = true,
    config = function()
        vim.cmd([[colorscheme sakura]])
    end,
}

-- Use default when loading this .
ui["rebelot/kanagawa.nvim"] = {
    opt = true,
    config = conf.kanagawa,
}

ui["jabuti-theme/jabuti-nvim"] = {
    opt = true,
    module = " jabuti-nvim",
    config = function()
        -- require("jabuti-nvim").setup()
        vim.cmd([[colorscheme jabuti]])
    end,
}

ui["wadackel/vim-dogrun"] = {
    opt = true,
    setup = conf.dogrun,
    config = function()
        vim.cmd([[colorscheme dogrun]])
    end,
}

-- ui["ThemerCorp/themer.lua"] = {
--     opt = true,
--     branch = "main",
--     config = conf.themer,
-- }

ui["kazhala/close-buffers.nvim"] = {
    cmd = { "BDelete", "BWipeout" },
    config = conf.buffers_close,
}

ui["wiliamks/mechanical.nvim"] = {
    opt = true,
}
return ui
-- hemer.lua: ...te/pack/packer/opt/themer.lua/lua/themer/core/mapper.lua:64: attempt to index field 'bg' (a string value)
