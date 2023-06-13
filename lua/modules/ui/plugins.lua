local ui = require("core.pack").package
local conf = require("modules.ui.config")
local api, fn = vim.api, vim.fn
local highlight = lambda.highlight

ui({
    "glepnir/nerdicons.nvim",
    cmd = "NerdIcons",
    config = true,
})

ui({
    "lukas-reineke/virt-column.nvim",
    cond = lambda.config.ui.use_virtcol,
    opts = { char = "▕" },
    init = function()
        lambda.augroup("VirtCol", {
            {
                event = { "VimEnter", "BufEnter", "WinEnter" },
                command = function(args)
                    if vim.bo.filetype == "harpoon" then
                        return
                    end
                    lambda.style.decorations.set_colorcolumn(args.buf, function(virtcolumn)
                        require("virt-column").setup_buffer({ virtcolumn = virtcolumn })
                    end)
                end,
            },
        })
    end,
})
ui({
    "rebelot/heirline.nvim",
    cond = lambda.config.ui.heirline.use_heirline,
    event = "VeryLazy",
    config = function()
        require("modules.ui.heirline")
    end,
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

ui({
    "rcarriga/nvim-notify",
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
    event = "VeryLazy", -- No clue why, but this is required for my hydra to work o_o
    keys = {
        {
            "<leader>e",
            function()
                if vim.bo.filetype == "neo-tree" then
                    vim.cmd.NeoTreeClose()
                end
                vim.cmd.NeoTreeFocusToggle()
            end,
            "NeoTree Focus Toggle",
        },
        {
            "<Leader>E",
            function()
                require("edgy").toggle()
            end,
            "General: [F]orce Close Edgy",
        },

        {
            "<leader>gt",
            function()
                vim.cmd("Neotree . git_status reveal toggle")
            end,
            desc = "General: [t]oggle the [g]it control explorer",
        },
    },

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        {
            -- only needed if you want to use the commands with "_with_window_picker" suffix
            "s1n7ax/nvim-window-picker",
            config = function()
                require("window-picker").setup({
                    use_winbar = "smart",
                    autoselect_one = true,
                    include_current = false,
                    other_win_hl_color = lambda.highlight.get("Visual", "bg"),
                    filter_rules = {
                        bo = {
                            filetype = { "neo-tree-popup", "quickfix", "edgy", "neo-tree" },
                            buftype = { "terminal", "quickfix", "nofile" },
                        },
                    },
                })
            end,
        },
    },
    config = conf.neo_tree,
})

ui({
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    cond = lambda.config.ui.indent_lines.use_indent_blankline,
    event = { "UIEnter" },
    config = conf.blankline,
})
ui({
    "shell-Raining/hlchunk.nvim",
    cond = lambda.config.ui.indent_lines.use_hlchunk,
    event = { "UIEnter" },
    opts = {
        blank = {
            enable = false,
        },
    },
})
-- after="nvim-treesitter",

ui({
    "xiyaowong/nvim-transparent",
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    config = conf.transparent,
})

ui({
    "levouh/tint.nvim",
    cond = lambda.config.ui.use_tint,
    event = "VeryLazy",
    opts = {
        tint = -30,
        highlight_ignore_patterns = {
            "WinSeparator",
            "St.*",
            "Comment",
            "Panel.*",
            "Telescope.*",
            "Bqf.*",
            "VirtColumn",
            "Headline.*",
            "NeoTree.*",
        },
        window_ignore_function = function(win_id)
            local win, buf = vim.wo[win_id], vim.bo[vim.api.nvim_win_get_buf(win_id)]
            if win.diff or not lambda.falsy(fn.win_gettype(win_id)) then
                return true
            end
            local ignore_bt = lambda.p_table({ terminal = true, prompt = true, nofile = false })
            local ignore_ft = lambda.p_table({
                ["Telescope.*"] = true,
                ["Neogit.*"] = true,
                ["flutterTools.*"] = true,
                ["qf"] = true,
            })
            local has_bt, has_ft = ignore_bt[buf.buftype], ignore_ft[buf.filetype]
            return has_bt or has_ft
        end,
    },
})

ui({
    "kevinhwang91/promise-async",
    lazy = true,
})
ui({
    "kevinhwang91/nvim-ufo",
    lazy = true,
    cond = lambda.config.ui.use_ufo,
    cmd = {
        "UfoAttach",
        "UfoDetach",
        "UfoEnable",
        "UfoDisable",
        "UfoInspect",
        "UfoEnableFold",
        "UfoDisableFold",
    },
    keys = {
        {
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
            "open all folds",
        },
        {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
            "close all folds",
        },
        {
            "zP",
            function()
                require("ufo").peekFoldedLinesUnderCursor()
            end,
            "preview fold",
        },
    },
    config = conf.ufo,
})

ui({
    "Vonr/foldcus.nvim",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    cmd = { "Foldcus", "Unfoldcus" },
    config = conf.fold_focus,
})

ui({
    "jghauser/fold-cycle.nvim",
    config = true,
    keys = {
        {
            "<BS>",
            function()
                require("fold-cycle").open()
            end,
            desc = "fold-cycle: toggle",
        },
    },
})
ui({
    "uga-rosa/ccc.nvim",
    ft = { "lua", "vim", "typescript", "typescriptreact", "javascriptreact", "svelte" },
    cmd = { "CccHighlighterToggle" },
    opts = function()
        local ccc = require("ccc")
        local p = ccc.picker
        p.hex.pattern = {
            [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)>]=],
            [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)(\x\x)>]=],
        }
        ccc.setup({
            win_opts = { border = lambda.style.border.type_0 },
            pickers = { p.hex, p.css_rgb, p.css_hsl, p.css_hwb, p.css_lab, p.css_lch, p.css_oklab, p.css_oklch },
            highlighter = {
                auto_enable = true,
                excludes = { "dart", "lazy", "orgagenda", "org", "NeogitStatus", "toggleterm" },
            },
        })
    end,
})
ui({
    "petertriho/nvim-scrollbar",
    lazy = true,
    cond = lambda.config.ui.use_scrollbar,
    event = "VeryLazy",
    dependencies = {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require("hlslens").setup({
                calm_down = true,
                nearest_only = true,
                nearest_float_when = "always",
            })

            --  TODO: (vsedov) (13:26:03 - 10/06/23): This might not be needed, dry mapping right
            --  now
            vim.keymap.set({ "n", "x" }, "<leader>F", function()
                vim.schedule(function()
                    if require("hlslens").exportLastSearchToQuickfix() then
                        vim.cmd("cw")
                    end
                end)
                return ":noh<CR>"
            end, { expr = true, desc = "hlslens: search and replace" })
        end,
    },
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
    cond = lambda.config.ui.use_status_col,
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
--  TODO: (vsedov) (02:31:08 - 02/06/23): This impacts dropbar, so this im not sure,
--  Further testing is required
ui({
    "tummetott/reticle.nvim",
    cond = lambda.config.ui.use_reticle and false,
    lazy = false,
    config = conf.reticle,
})

--  TODO: (vsedov) (13:12:54 - 30/05/23):@ Temp disable, want to test out akinshos autocmds,
--  i wonder if they are any better that what ive had before
ui({
    "glepnir/hlsearch.nvim",
    cond = lambda.config.ui.use_hlsearch,
    event = "CursorHold",
    config = true,
})

ui({
    "yaocccc/nvim-foldsign",
    event = "CursorHold",
    config = true,
})

ui({
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    cond = lambda.config.ui.use_scroll,
    event = "VeryLazy",
    config = function()
        require("neoscroll").setup({
            -- All these keys will be mapped to their corresponding default scrolling animation
            --mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
            mappings = { "C-j", "C-k", "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>" },
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = false, -- Stop at <EOF> when scrolling downwards
            -- use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
            -- respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            -- cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
        })

        local t = {}
        t["<c-k>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
        t["<c-j>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
        require("neoscroll.config").set_mappings(t)
    end,
})
ui({
    "rainbowhxch/beacon.nvim",
    cond = lambda.config.ui.use_beacon,
    event = "VeryLazy",
    opts = {
        minimal_jump = 20,
        ignore_buffers = { "terminal", "nofile", "neorg://Quick Actions" },
        ignore_filetypes = {
            "qf",
            "dap_watches",
            "dap_scopes",
            "neo-tree",
            "NeogitCommitMessage",
            "NeogitPopup",
            "NeogitStatus",
        },
    },
})
ui({
    "mawkler/modicator.nvim",
    ft = { "python", "lua", "sh", "rmd", "markdown", "markdown.pandoc", "quarto" },
    init = function()
        vim.o.cursorline = true
        vim.o.number = true
        vim.o.termguicolors = true
    end,
    opts = {
        bold = true,
        italic = true,
    },
})

ui({
    "mvllow/modes.nvim",
    event = "VeryLazy",
    config = true,
})
--
ui({
    "tzachar/highlight-undo.nvim",
    keys = {
        "<c-r>",
        "u",
    },
    config = true,
})
--  ╭────────────────────────────────────────────────────────────────────╮
--  │                            MINI PLUGINS                            │
--  │                                                                    │
--  ╰────────────────────────────────────────────────────────────────────╯
ui({
    "echasnovski/mini.indentscope",
    cond = lambda.config.ui.indent_lines.use_mini_indent_scope,
    version = false,
    event = { "UIEnter" },
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "Trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
    opts = {
        symbol = "│",
        options = {
            border = "both",
            indent_at_cursor = true,
            try_as_border = true,
        },
    },
})
ui({
    "echasnovski/mini.animate",
    cond = lambda.config.ui.use_mini_animate,
    event = "VeryLazy",
    config = function()
        local animate = require("mini.animate")

        animate.setup({
            -- Cursor path
            cursor = {
                -- Whether to enable this animation
                enable = true,
                --<function: implements linear total 250ms animation duration>,
                timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
            },
            -- Vertical scroll
            scroll = {
                enable = false,
                -- enable = vim.g.loaded_gui and true or false,
                timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
                subscroll = animate.gen_subscroll.equal({ max_output_steps = 60 }),
            },
            -- Window resize -- we use the animation library that comes with windows.nvim instead
            resize = {
                enable = false,
            },
            -- Window open
            open = {
                enable = false,
            },
            -- Window close
            close = {
                enable = false,
            },
        })
    end,
})
