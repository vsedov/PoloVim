local user = require("core.pack").package

user({
    "p00f/cphelper.nvim",
    cmd = {
        "CphReceive",
        "CphTest",
        "CphReTest",
        "CphEdit",
        "CphDelete",
    },
    lazy = true,
    config = function()
        vim.g["cph#lang"] = "python"
        vim.g["cph#border"] = lambda.style.border.type_0
    end,
})

user({
    "samjwill/nvim-unception",
    lazy = true,
    event = "CmdLineEnter",
    config = function()
        vim.g.unception_delete_replaced_buffer = true
        vim.g.unception_enable_flavor_text = false
    end,
})

user({
    "LunarVim/bigfile.nvim",
    event = "VeryLazy",
    config = function()
        local default_config = {
            filesize = 2,
            pattern = { "*" },
            features = {
                "indent_blankline",
                "illuminate",
                "syntax",
                "matchparen",
                "vimopts",
                "filetype",
            },
        }
        require("bigfile").config(default_config)
    end,
})

user({
    "tamton-aquib/mpv.nvim",
    lazy = true,
    cmd = "MpvToggle",
    config = true,
})

user({
    "Apeiros-46B/qalc.nvim",
    config = true,
    cmd = { "Qalc", "QalcAttach" },
})

-- The goal of nvim-fundo is to make Neovim's undo file become stable and useful.
user({
    "kevinhwang91/nvim-fundo",
    event = "VeryLazy",
    cmd = { "FundoDisable", "FundoEnable" },
    dependencies = "kevinhwang91/promise-async",
    build = function()
        require("fundo").install()
    end,
    config = true,
})

user({
    "stevearc/oil.nvim",
    lazy = true,
    init = function()
        vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end,
    event = "VeryLazy",
    config = true,
})

user({
    "AntonVanAssche/date-time-inserter.nvim",
    lazy = true,
    cmd = {
        "InsertDate",
        "InsertTime",
        "InsertDateTime",
    },
    config = true,
})

user({
    "2kabhishek/co-author.nvim",
    lazy = true,
    cmd = {
        "GitCoAuthors",
    },
})
user({
    "petertriho/nvim-scrollbar",
    lazy = true,
    dependencies = { "kevinhwang91/nvim-hlslens" },
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

user({
    "romainchapou/nostalgic-term.nvim",
    lazy = true,
    event = "TermOpen",
    config = function()
        require("nostalgic-term").setup({
            mappings = {
                { "<c-h>", "h" },
                { "<c-j>", "j" },
                { "<c-k>", "k" },
                { "<c-l>", "l" },
            },
            add_normal_mode_mappings = true,
        })
    end,
})

user({
    "linty-org/readline.nvim",
    config = function()
        local readline = require("readline")
        vim.keymap.set("!", "<C-u>", readline.backward_kill_line)
        vim.keymap.set("!", "<C-w>", readline.unix_word_rubout)

        vim.keymap.set("!", "<C-d>", "<Delete>") -- delete-char
        vim.keymap.set("!", "<C-h>", "<BS>") -- backward-delete-char

        vim.keymap.set("!", "<C-a>", readline.beginning_of_line)
        vim.keymap.set("!", "<C-e>", readline.end_of_line)

        vim.keymap.set("!", "<c-F>", readline.forward_word)
        vim.keymap.set("!", "<c-B>", readline.backward_word)

        vim.keymap.set("!", "<C-f>", "<Right>") -- forward-char
        vim.keymap.set("!", "<C-b>", "<Left>") -- backward-char
        vim.keymap.set("!", "<C-n>", "<Down>") -- next-line
        vim.keymap.set("!", "<C-p>", "<Up>") -- previous-line
    end,
})
user({
    "ThePrimeagen/vim-apm",
    lazy = true,
    event = "VimEnter",
})

user({
    "sindrets/scratchpad.nvim",
    cmd = { "Float", "FloatMove", "Scratchpad" },
})

user({
    "gennaro-tedesco/nvim-possession",
    keys = {
        "<leader>sl",
        "<leader>sn",
        "<leader>su",
    },
    dependencies = {
        "ibhagwan/fzf-lua",
    },
    config = true,
    init = function()
        local possession = require("nvim-possession")
        vim.keymap.set("n", "<leader>sl", function()
            possession.list()
        end)
        vim.keymap.set("n", "<leader>sn", function()
            possession.new()
        end)
        vim.keymap.set("n", "<leader>su", function()
            possession.update()
        end)
    end,
})

user({
    "jackMort/pommodoro-clock.nvim",
    lazy = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    keys = {
        ";1",
        ";2",
        ";3",
        ";4",
        ";5",
    },
    config = function()
        require("pommodoro-clock").setup({})

        local function pc(func)
            return "<Cmd>lua require('pommodoro-clock')." .. func .. "()<CR>"
        end
        vim.keymap.set("n", ";1", pc("start_work"), { silent = true })
        vim.keymap.set("n", ";2", pc("start_short_break"), { silent = true })
        vim.keymap.set("n", ";2", pc("start_long_break"), { silent = true })
        vim.keymap.set("n", ";3", pc("toggle_pause"), { silent = true })
        vim.keymap.set("n", ";4", pc("close"), { silent = true })
    end,
})
user({
    "luukvbaal/statuscol.nvim",
    config = function()
        local builtin = require("statuscol.builtin")

        local function diagnostic_click(args)
            if args.button == "l" then
                vim.diagnostic.open_float({ border = Border, scope = "line", source = "always" })
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

user({
    "tamton-aquib/staline.nvim",
    lazy = true,
    event = "BufWinEnter",
    config = function()
        require("staline").setup({

            sections = {
                left = {
                    "mode",
                    " ",
                    "file_name",
                    " ",
                    "branch",
                    " ",
                },
                mid = { "lsp" },
                right = {
                    "cool_symbol",
                    " ",
                    " ",
                    "lsp_name",
                    " ",
                    "line_column",
                    " ",
                },
            },

            defaults = {
                fg = "#986fec",
                cool_symbol = "  ",
                true_colors = true,
                branch_symbol = " ",
                line_column = "[%l:%c] 並%p%% ",
                -- font_active = "bold"
            },
            mode_colors = {
                i = "#d4be98",
                n = "#CBA6F7",
                c = "#8fbf7f",
                v = "#fc802d",
            },
        })
    end,
})
