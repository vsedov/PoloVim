local ui = require("core.pack").package
local conf = require("modules.ui.config")
local highlight, foo, falsy, augroup = lambda.highlight, lambda.style, lambda.falsy, lambda.augroup
local icons, border, rect = foo.icons.lsp, foo.border.type_0, foo.border.type_0
ui({
    "rcarriga/nvim-notify",
    dependencies = {
        {
            "j-hui/fidget.nvim",
            cond = lambda.config.ui.use_fidgit,
            event = "VeryLazy",
            opts = {
                notification = {
                    override_vim_notify = true,
                },
            },
        },
    },
})

ui({
    "glepnir/nerdicons.nvim",
    cmd = "NerdIcons",
    config = true,
})

ui({
    "rebelot/heirline.nvim",

    cond = lambda.config.ui.heirline.use_heirline,
    event = "VeryLazy",
    config = function()
        local comp = require("modules.ui.heirline_components")
        local utils = require("heirline.utils")

        require("heirline").load_colors(comp.setup_colors())
        local aug = vim.api.nvim_create_augroup("Heirline", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
            desc = "Update Heirline colors",
            group = aug,
            callback = function()
                local colors = comp.setup_colors()
                utils.on_colorscheme(colors)
            end,
        })

        require("heirline").setup({
            statusline = utils.insert(
                {
                    static = comp.stl_static,
                    hl = { bg = "bg" },
                },
                comp.ViMode,
                comp.lpad(comp.LSPActive),
                comp.lpad(comp.Diagnostics),
                require("modules.ui.statusline").left_components,
                { provider = "%=" },
                require("modules.ui.statusline").right_components,
                comp.rpad(comp.ConjoinStatus),
                comp.rpad(comp.ArduinoStatus),
                comp.rpad(comp.SessionName),
                comp.rpad(comp.Overseer),
                comp.rpad(comp.FileType),
                comp.Ruler
            ),

            opts = {
                disable_winbar_cb = function(args)
                    local buf = args.buf
                    local ignore_buftype =
                        vim.tbl_contains({ "prompt", "nofile", "terminal", "quickfix" }, vim.bo[buf].buftype)
                    local filetype = vim.bo[buf].filetype
                    local ignore_filetype = filetype == "fugitive" or filetype == "qf" or filetype:match("^git")
                    local is_float = vim.api.nvim_win_get_config(0).relative ~= ""
                    return ignore_buftype or ignore_filetype or is_float
                end,
            },
        })

        vim.api.nvim_create_user_command("HeirlineResetStatusline", function()
            vim.o.statusline = "%{%v:lua.require'heirline'.eval_statusline()%}"
        end, {})

        -- -- Because heirline is lazy loaded, we need to manually set the winbar on startup
        -- vim.opt_local.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
    end,
})

ui({
    "stevearc/dressing.nvim",
    init = function()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.select(...)
        end
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.input = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.input(...)
        end
    end,
    opts = {
        input = {
            enabled = true,
            border = lambda.style.border.type_0,
            default_prompt = "➤ ",
            win_options = { wrap = true, winhighlight = "Normal:Normal,NormalNC:Normal" },
            prefer_width = 100,
            min_width = 20,
            title_pos = "center",
            get_config = function()
                if vim.api.nvim_win_get_width(0) < 50 then
                    return {
                        relative = "editor",
                    }
                end
            end,
        },
        select = {
            backend = { "fzf_lua", "builtin" },
            builtin = {
                border = lambda.style.border.type_0,
                min_height = 10,
                win_options = { winblend = 10 },
                mappings = { n = { ["q"] = "Close", ["<esc>"] = "Close" } },
            },
            get_config = function(opts)
                opts.prompt = opts.prompt and opts.prompt:gsub(":", "")
                if opts.kind == "codeaction" then
                    return {
                        backend = "fzf_lua",
                        fzf_lua = lambda.fzf.cursor_dropdown({
                            winopts = { title = opts.prompt },
                        }),
                    }
                end
                if opts.kind == "norg" then
                    return {
                        backend = "nui",
                        nui = {
                            position = "97%",
                            border = { style = rect },
                            min_width = vim.o.columns - 2,
                        },
                    }
                end
                return {
                    backend = "telescope",
                }
            end,
            nui = {
                min_height = 10,
                win_options = {
                    winhighlight = table.concat({
                        "Normal:Italic",
                        "FloatBorder:PickerBorder",
                        "FloatTitle:Title",
                        "CursorLine:Visual",
                    }, ","),
                },
            },
        },
    },
    config = function(_, opts)
        require("dressing").setup(opts)
        vim.keymap.set("n", "z=", function()
            local word = vim.fn.expand("<cword>")
            local suggestions = vim.fn.spellsuggest(word)
            vim.ui.select(
                suggestions,
                {},
                vim.schedule_wrap(function(selected)
                    if selected then
                        vim.cmd.normal({ args = { "ciw" .. selected }, bang = true })
                    end
                end)
            )
        end)
    end,
})
ui({ "MunifTanjim/nui.nvim", event = "VeryLazy", lazy = true })
--
-- --  ──────────────────────────────────────────────────────────────────────
-- -- Force Lazy
-- --  ──────────────────────────────────────────────────────────────────────
--
ui({
    "RRethy/vim-illuminate",
    lazy = true,
    cond = lambda.config.ui.use_illuminate,
    event = "VeryLazy",
    config = conf.illuminate,
})

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
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy", -- No clue why, but this is required for my hydra to work o_o
    keys = {
        {
            "<leader>e",
            function()
                vim.cmd.NeoTreeFocusToggle()
            end,
            "NeoTree Focus Toggle",
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
                    hint = "floating-big-letter",
                    autoselect_one = true,
                    include_current = false,
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
--
ui({
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    cond = lambda.config.ui.indent_lines.use_indent_blankline,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    opts = {
        filetype_exclude = {
            "glowpreview",
            "dbout",
            "neo-tree-popup",
            "log",
            "gitcommit",
            "txt",
            "help",
            "NvimTree",
            "git",
            "flutterToolsOutline",
            "undotree",
            "markdown",
            "norg",
            "org",
            "orgagenda",
            "neo-tree",
            "neo-tree-*",
            "help",
            "NvimTree",
            "Neotree",
            "vaffle",
        },
        buftype_exclude = { "terminal", "nofile", "NvimTree", "Neotree" },
        indent = {
            char = "│", -- ▏┆ ┊ 
            tab_char = "│",
        },
        scope = {
            char = "▎",
        },
    },
    config = function(_, opts)
        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }
        local hooks = require("ibl.hooks")
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)

        vim.g.rainbow_delimiters = { highlight = highlight }
        require("ibl").setup({ scope = { highlight = highlight } })

        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
})
-- dropbar_menu
ui({
    "shell-Raining/hlchunk.nvim",
    cond = lambda.config.ui.indent_lines.use_hlchunk,
    event = { "UIEnter" },
    opts = {
        indent = {
            chars = { "│", "¦", "┆", "┊" }, -- more code can be found in https://unicodeplus.com/
        },
        chunk = {
            enable = true,
            use_treesitter = true,
            notify = true, -- notify if some situation(like disable chunk mod double time)
            exclude_filetypes = {
                glowpreview = true,
                harpoon = true,
                aerial = true,
                dropbar_menu = true,
                dashboard = true,
                sagaoutline = true,
                oil_preview = true,
                oil = true,
                ["neo-tree"] = true,
            },
        },
        blank = {
            enable = false,
        },
    },
})
--
ui({
    "levouh/tint.nvim",
    cond = lambda.config.ui.use_tint,
    event = "VeryLazy",
    opts = {
        tint = -15,
        highlight_ignore_patterns = {
            "WinSeparator",
            "St.*",
            "Comment",
            "Panel.*",
            "Telescope.*",
            "IndentBlankline.*",
            "Bqf.*",
            "VirtColumn",
            "Headline.*",
            "NeoTree.*",
            "LineNr",
            "NeoTree.*",
            "Telescope.*",
            "VisibleTab",
        },
        window_ignore_function = function(win_id)
            local win, buf = vim.wo[win_id], vim.bo[vim.api.nvim_win_get_buf(win_id)]
            if win.diff or not lambda.falsy(vim.fn.win_gettype(win_id)) then
                return true
            end
            local ignore_bt = lambda.p_table({ terminal = true, prompt = true, nofile = false })
            local ignore_ft = lambda.p_table({ ["Neogit.*"] = true, ["flutterTools.*"] = true, ["qf"] = true })
            return ignore_bt[buf.buftype] or ignore_ft[buf.filetype]
        end,
    },
})
--
ui({
    "kevinhwang91/promise-async",
    lazy = true,
})
ui({
    "luukvbaal/statuscol.nvim",
    cond = lambda.config.ui.use_statuscol,
    event = "UIEnter",
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            ft_ignore = {
                "neotree",
                "OverseerList",
                "sagaoutline",
            }, -- lua table with filetypes for which 'statuscolumn' will be unset
            bt_ignore = {
                "nofile",
                "terminal",
            }, -- lua table with 'buftype' values for which 'statuscolumn' will be unset
            relculright = true,
            segments = {
                { text = { "%s" }, click = "v:lua.ScSa" },
                -- {
                --     --
                --
                --     -- Git Signs
                --     text = { "%s" },
                --     sign = { name = { "GitSigns" }, maxwidth = 1, colwidth = 1, auto = false },
                --     click = "v:lua.ScSa",
                -- },
                {
                    -- Line Numbers
                    text = { builtin.lnumfunc },
                    click = "v:lua.ScLa",
                },
                {
                    -- Dap Breakpoints
                    sign = {
                        name = { "DapBreakpoint" },
                        maxwidth = 1,
                        colwidth = 1,
                        auto = false,
                        fillchars = "",
                    },
                    click = "v:lua.ScSa",
                },
                {
                    -- Fold Markers
                    text = { builtin.foldfunc },
                    click = "v:lua.ScFa",
                },
                -- {
                --     -- Diagnostics
                --     sign = { name = { "Diagnostic" }, maxwidth = 1, colwidth = 1, auto = false, fillchars = "" },
                --     click = "v:lua.ScSa",
                -- },
                -- {
                --     -- All Other Signs
                --     sign = {
                --         name = { ".*" },
                --         fillchars = "",
                --
                --         auto = false,
                --     },
                --     click = "v:lua.ScSa",
                -- },

                { text = { "│" } },
            },
        })
    end,
})

ui({
    "kevinhwang91/nvim-ufo",
    lazy = true,
    cond = lambda.config.ui.use_ufo,
    event = "VeryLazy",
    dependencies = {
        "kevinhwang91/promise-async",
    },
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
            desc = "ufo: open all folds",
        },
        {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
        },
        {
            "zr",
            function()
                require("ufo").openFoldsExceptKinds()
            end,
            desc = "ufo: open folds except kinds",
        },
        {
            "zm",
            function()
                require("ufo").closeFoldsWith()
            end,
            desc = "ufo: close folds with",
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
    event = "VeryLazy",
    config = true,
    keys = {
        {
            "<BS>",
            function()
                require("fold-cycle").open()
            end,
            desc = "fold-cycle: toggle",
            silent = true,
        },
        {
            "<C-BS>",
            function()
                require("fold-cycle").close()
            end,
            desc = "fold-cycle: toggle",
            silent = true,
        },
        {
            "zC",
            function()
                require("fold-cycle").close_all()
            end,
            desc = "fold-cycle: Close all ",
            remap = true,
        },
    },
})
ui({
    "uga-rosa/ccc.nvim",
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
--  TODO: (vsedov) (13:12:54 - 30/05/23):@ Temp disable, want to test out akinshos autocmds,
--  i wonder if they are any better that what ive had before
ui({
    "glepnir/hlsearch.nvim",
    cond = lambda.config.ui.use_hlsearch,
    event = "CursorHold",
    config = true,
})
--
ui({
    "kevinhwang91/nvim-hlslens",
    cond = lambda.config.ui.use_hlslens,
    lazy = true,
    config = true,
    event = "VeryLazy",
})
--

ui({
    "yaocccc/nvim-foldsign",
    cond = false,
    event = "CursorHold",
    config = true,
})

ui({
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    cond = lambda.config.ui.scroll_bar.use_scroll,
    event = "VeryLazy",
    config = function()
        require("neoscroll").setup({
            -- All these keys will be mapped to their corresponding default scrolling animation
            --mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
            mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = false, -- Stop at <EOF> when scrolling downwards
            -- use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
            -- respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            -- cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
        })
    end,
})

ui({
    "mvllow/modes.nvim",
    cond = false,
    event = "VeryLazy",
    config = true,
})
