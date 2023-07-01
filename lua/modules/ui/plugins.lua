local ui = require("core.pack").package
local conf = require("modules.ui.config")
local highlight, foo, falsy, augroup = lambda.highlight, lambda.style, lambda.falsy, lambda.augroup
local icons, border, rect = foo.icons.lsp, foo.border.type_0, foo.border.type_0

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
                event = { "BufEnter", "WinEnter" },
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
            relative = "editor",
        },
        select = {
            backend = { "fzf_lua", "builtin" },
            builtin = {
                border = lambda.style.border.type_0,
                min_height = 10,
                win_options = { winblend = 10 },
                mappings = { n = { ["q"] = "Close" } },
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
                    backend = "fzf_lua",
                    fzf_lua = lambda.fzf.dropdown({
                        winopts = { title = opts.prompt, height = 0.33, row = 0.5, width = 0.8 },
                    }),
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

ui({
    "kevinhwang91/promise-async",
    lazy = true,
})
ui({
    "kevinhwang91/nvim-ufo",
    lazy = true,
    cond = lambda.config.ui.use_ufo,

    dependencies = {
        "kevinhwang91/promise-async",
        {
            "luukvbaal/statuscol.nvim",
            config = function()
                local builtin = require("statuscol.builtin")
                require("statuscol").setup({
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
        },
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
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
        require("hlslens").setup({
            override_lens = function(render, posList, nearest, idx, relIdx)
                local sfw = vim.v.searchforward == 1
                local indicator, text, chunks
                local absRelIdx = math.abs(relIdx)
                if absRelIdx > 1 then
                    indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
                elseif absRelIdx == 1 then
                    indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
                else
                    indicator = ""
                end

                local lnum, col = unpack(posList[idx])
                if nearest then
                    local cnt = #posList
                    if indicator ~= "" then
                        text = ("[%s %d/%d]"):format(indicator, idx, cnt)
                    else
                        text = ("[%d/%d]"):format(idx, cnt)
                    end
                    chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
                else
                    text = ("[%s %d]"):format(indicator, idx)
                    chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
                end
                render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
            end,
        })

        --  TODO: (vsedov) (13:26:03 - 10/06/23): This might not be needed, dry mapping right
        --  now
        vim.keymap.set({ "n", "x" }, "<leader>L", function()
            vim.schedule(function()
                if require("hlslens").exportLastSearchToQuickfix() then
                    vim.cmd("cw")
                end
            end)
            return ":noh<CR>"
        end, { expr = true, desc = "hlslens: search and replace" })
    end,
})

ui({
    "petertriho/nvim-scrollbar",
    lazy = true,
    cond = lambda.config.ui.scroll_bar.use_scrollbar,
    event = "VeryLazy",
    dependencies = { "kevinhwang91/nvim-hlslens" },
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
    cond = false,
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
            mappings = { "C-j", "C-k", "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
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
            "neo-tree",
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
ui({
    "HampusHauffman/block.nvim",
    lazy = true,
    cmd = { "Block", "BlockOn", "BlockOff" },
    opts = { percent = 1.05, depth = 10, automatic = true },
})
