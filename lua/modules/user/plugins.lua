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
    "Apeiros-46B/qalc.nvim",
    config = true,
    cmd = { "Qalc", "QalcAttach" },
})

-- The goal of nvim-fundo is to make Neovim's undo file become stable and useful.
user({
    "kevinhwang91/nvim-fundo",
    event = "BufReadPre",
    cmd = { "FundoDisable", "FundoEnable" },
    dependencies = "kevinhwang91/promise-async",
    build = function()
        require("fundo").install()
    end,
    config = true,
})

user({
    "stevearc/oil.nvim",
    event = "VeryLazy",
    init = function()
        vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end,
    opts = {
        columns = {
            "icon",
            -- "permissions",
            "mtime",
        },
        buf_options = {
            buflisted = true,
        },
        -- Window-local options to use for oil buffers
        win_options = {
            wrap = true,
            signcolumn = "no",
            cursorcolumn = false,
            foldcolumn = "0",
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = "n",
        },
        -- Restore window options to previous values when leaving an oil buffer
        restore_win_options = true,
        -- Skip the confirmation popup for simple operations
        skip_confirm_for_simple_edits = false,
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-s>"] = "actions.select_vsplit",
            ["<C-h>"] = "actions.select_split",
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["c"] = "actions.cd",
            ["C"] = "actions.tcd",
            ["g."] = "actions.toggle_hidden",
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = false,
        view_options = {
            show_hidden = false,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
            -- Padding around the floating window
            padding = 2,
            max_width = 0,
            max_height = 0,
            border = "rounded",
            win_options = {
                winblend = 10,
            },
        },
    },
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
    event = "VeryLazy",
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
        vim.keymap.set("n", ";1", function()
            require("pommodoro-clock").toggle_pause()
        end)

        vim.keymap.set("n", ";2", function()
            require("pommodoro-clock").start("work")
        end)
        vim.keymap.set("n", ";3", function()
            require("pommodoro-clock").start("short_break")
        end)
        vim.keymap.set("n", ";4", function()
            require("pommodoro-clock").start("long_break")
        end)
        vim.keymap.set("n", ";5", function()
            require("pommodoro-clock").close()
        end)
    end,
})
--
user({
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

--
user({
    "segeljakt/vim-silicon",
    lazy = true,
    cmd = { "Silicon", "SiliconHighlight" },
    config = function()
        vim.cmd([[
            let s:workhours = {
                  \ 'Monday':    [8, 16],
                  \ 'Tuesday':   [9, 17],
                  \ 'Wednesday': [9, 17],
                  \ 'Thursday':  [9, 17],
                  \ 'Friday':    [9, 15],
                  \ }

            function! s:working()
                let day = strftime('%u')
                if has_key(s:workhours, day)
                  let hour = strftime('%H')
                  let [start_hour, stop_hour] = s:workhours[day]
                  if start_hour <= hour && hour <= stop_hour
                    return "~/Work-Snippets/"
                  endif
                endif
                return "/home/viv/Pictures/Silicon/"
            endfunction

            let g:silicon['output'] = function('s:working')
        ]])
    end,
})

user({
    "tamton-aquib/mpv.nvim",
    lazy = true,
    cmd = "MpvToggle",
    config = { setup_widgets = true, timer = { throttle = 100 } },
})

user({

    "strash/everybody-wants-that-line.nvim",
    event = "VeryLazy",
    opts = {
        buffer = {
            enabled = true,
            prefix = "λ:",
            symbol = "0",
            max_symbols = 5,
        },
        diagnostics = {
            enabled = true,
        },
        quickfix_list = {
            enabled = true,
        },
        git_status = {
            enabled = true,
        },
        filepath = {
            enabled = true,
            path = "relative",
            shorten = false,
        },
        filesize = {
            enabled = true,
            metric = "decimal",
        },
        ruller = {
            enabled = true,
        },
        filename = {
            enabled = false,
        },
        separator = "│",
    },
})

user({

    "mskelton/local-yokel.nvim",
    lazy = true,
    cmd = { "E" },
    config = true,
})

user({
    "kwakzalver/duckytype.nvim",
    lazy = true,
    cmd = {
        "PythonSpell",
        "EnglishSpell",
        "DuckyType",
    },
    opts = {
        {
            expected = "python_keywords",
            number_of_words = 42,
            average_word_length = 5.69,
        },
    },
    init = function()
        lambda.command("EnglishSpell", function()
            require("duckytype").Start("english_common")
        end, {})
        lambda.command("PythonSpell", function()
            require("duckytype").Start("python_keywords")
        end, {})
    end,
})
user({
    "tummetott/reticle.nvim",
    cond = false, -- very laggy right now
    lazy = true,
    init = function()
        vim.wo.cursorline = true
        vim.wo.cursorcolumn = true
    end,
    opts = {

        ignore = {
            cursorline = {
                "lspinfo",
                "neotree",
            },
            cursorcolumn = {
                "lspinfo",
                "neotree",
            },
        },
        never = {
            cursorline = {
                "TelescopePrompt",
                "DressingInput",
                "neotree",
            },
            cursorcolumn = {
                "neotree",
            },
        },
    },
})

user({
    "Wansmer/sibling-swap.nvim",
    dependencies = { "nvim-treesitter" },
    opts = {
        use_default_keymaps = false,
        keymaps = {
            ["]w"] = "swap_with_right",
            ["[w"] = "swap_with_left",
        },
    },
})

user({
    "aserowy/tmux.nvim",
    lazy = true,
    cond = vim.fn.getenv("TMUX") ~= vim.NIL,
    event = "InsertEnter",
    config = true,
})
