local ui = require("core.pack").package
local conf = require("modules.ui.config")

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
    cond = lambda.config.ui.use_illuminate,
    event = "VeryLazy",

    config = conf.illuminate,
})

ui({
    "nyngwang/murmur.lua",
    lazy = true,
    cond = lambda.config.ui.use_murmur,
    event = "VeryLazy",

    config = conf.murmur,
})

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
                    other_win_hl_color = require("utils.ui.utils").get("Visual", "bg"),
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
    lazy = true,
    event = "VeryLazy",
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
    cmd = {
        "UfoAttach",
        "UfoDetach",
        "UfoEnable",
        "UfoDisable",
        "UfoInspect",
        "UfoEnableFold",
        "UfoDisableFold",
    },
    config = conf.ufo,
})

ui({
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    lazy = true,
    cond = lambda.config.use_scroll,
    event = "VeryLazy",
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
    event = "VeryLazy",
    cond = lambda.config.ui.noice.enable,
    dependencies = {
        "nui.nvim",
        "nvim-notify",
        "hrsh7th/nvim-cmp",
    },
    opts = conf.noice,
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

ui({
    "uga-rosa/ccc.nvim",
    lazy = true,
    cmd = {
        "CccPick",
        "CccConvert",
        "CccHighlighterToggle",
        "CccHighlighterEnable",
        "CccHighlighterDisable",
    },
    opts = {
        win_opts = { border = lambda.style.border.type_0 },
        highlighter = { auto_enable = true, excludes = { "dart" } },
    },
})
ui({
    "petertriho/nvim-scrollbar",
    lazy = true,
    dependencies = {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require("hlslens").setup({
                calm_down = true,
                nearest_only = true,
                nearest_float_when = "always",
            })

            vim.keymap.set({ "n", "x" }, ";L", function()
                vim.schedule(function()
                    if require("hlslens").exportLastSearchToQuickfix() then
                        vim.cmd("cw")
                    end
                end)
                return ":noh<CR>"
            end, { expr = true })
        end,
    },
    event = "BufReadPost",
    config = function()
        require("scrollbar.handlers.search").setup()
        require("scrollbar").setup({
            show = true,
            set_highlights = true,
            handle = {
                color = "#777777",
            },
            marks = {
                Search = { color = "#ff9e64" },
                Error = { color = "#db4b4b" },
                Warn = { color = "#e0af68" },
                Info = { color = "#0db9d7" },
                Hint = { color = "#1abc9c" },
                Misc = { color = "#9d7cd8" },
                GitAdd = {
                    color = "#9ed072",
                    text = "+",
                },
                GitDelete = {
                    color = "#fc5d7c",
                    text = "-",
                },
                GitChange = {
                    color = "#76cce0",
                    text = "*",
                },
            },
            handlers = {
                diagnostic = true,
                search = true,
                gitsigns = false,
            },
        })
    end,
})
ui({
    "luukvbaal/statuscol.nvim",
    cond = true,
    event = "VeryLazy",
    config = function()
        local builtin = require("statuscol.builtin")

        local function diagnostic_click(args)
            if args.button == "l" then
                vim.diagnostic.open_float({ border = lambda.style.border.type_0, scope = "line", source = "always" })
            elseif args.button == "m" then
                vim.lsp.buf.code_action()
            end
        end

        require("statuscol").setup({
            separator = "│",
            -- separator = false,
            setopt = true,
            -- thousands = true,
            -- relculright = true,
            order = "NSFs",
            -- Click actions
            Lnum = builtin.lnum_click,
            FoldPlus = builtin.foldplus_click,
            FoldMinus = builtin.foldminus_click,
            FoldEmpty = builtin.foldempty_click,
            DapBreakpointRejected = builtin.toggle_breakpoint,
            DapBreakpoint = builtin.toggle_breakpoint,
            DapBreakpointCondition = builtin.toggle_breakpoint,
            DiagnosticSignError = diagnostic_click,
            DiagnosticSignHint = diagnostic_click,
            DiagnosticSignInfo = diagnostic_click,
            DiagnosticSignWarn = diagnostic_click,
            GitSignsTopdelete = builtin.gitsigns_click,
            GitSignsUntracked = builtin.gitsigns_click,
            GitSignsAdd = builtin.gitsigns_click,
            GitSignsChangedelete = builtin.gitsigns_click,

            GitSignsDelete = builtin.gitsigns_click,
        })
    end,
})
ui({
    "tummetott/reticle.nvim",

    config = function()
        require("reticle").setup({
            -- Make the cursorline and cursorcolumn follow your active window. This
            -- only works if the cursorline and cursorcolumn setting is switched on
            -- globaly like explained in 'Usage'. Default is true for both values
            follow = {
                cursorline = true,
                cursorcolumn = true,
            },

            -- Define filetypes where the cursorline / cursorcolumn is always on,
            -- regardless of the global setting
            always = {
                cursorline = {
                    "json",
                },
                cursorcolumn = {},
            },

            -- Define filetypes where the cursorline / cursorcolumn is always on when
            -- the window is focused, regardless of the global setting
            on_focus = {
                cursorline = {
                    "help",
                    "NvimTree",
                },
                cursorcolumn = {},
            },

            -- Define filetypes where the cursorline / cursorcolumn is never on,
            -- regardless of the global setting
            never = {
                cursorline = {
                    "qf",
                },
                cursorcolumn = {
                    "qf",
                },
            },

            -- Define filetypes which are ignored by the plugin
            ignore = {
                cursorline = {
                    "lspinfo",
                    "neo-tree",
                },
                cursorcolumn = {
                    "lspinfo",
                    "neo-tree",
                },
            },

            -- By default, nvim highlights the cursorline number only when the cursorline setting is
            -- switched on. When enabeling the following setting, the cursorline number
            -- of every window is always highlighted, regardless of the setting
            always_show_cl_number = true,
        })
    end,
})

ui({
    "rebelot/heirline.nvim",
    lazy = true,
    dependencies = {
        {
            "jcdickinson/wpm.nvim",
            lazy = true,
            opts = { sample_interval = 1000 },
            config = true,
        },
        { "uga-rosa/utf8.nvim", lazy = true },
    },
})

ui({
    "glepnir/hlsearch.nvim",
    lazy = true,
    event = "VeryLazy",
    config = true,
})
