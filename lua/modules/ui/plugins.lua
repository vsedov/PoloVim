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
    cond = lambda.config.ui.use_heirline,
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
    event = "VeryLazy",
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
                            filetype = { "neo-tree-popup", "quickfix" },
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
    cond = lambda.config.ui.indent_blankline.use_indent_blankline,
    event = "VeryLazy",
    dependencies = {
        "shell-Raining/hlchunk.nvim",
        cond = lambda.config.ui.indent_blankline.use_hlchunk,
        event = { "VeryLazy" },
        config = true,
    },
    config = conf.blankline,
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
    keys = { "z;", "z'" },
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
    "folke/noice.nvim",
    event = "VeryLazy",
    cond = lambda.config.ui.noice.enable,
    dependencies = {
        "nui.nvim",
        "nvim-notify",
        "hrsh7th/nvim-cmp",
    },
    opts = require("modules.ui.noice").noice,
    config = require("modules.ui.noice").noice_setup,
})

ui({
    "samuzora/pet.nvim",
    lazy = true,
    cond = lambda.config.ui.use_pet,
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
    cond = lambda.config.ui.use_scroll,
    event = "VeryLazy",
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
    cond = lambda.config.ui.use_reticle,
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
    opts = { hide_cursor = true, mappings = { "<C-d>", "<C-u>", "zt", "zz", "zb" } },
})
