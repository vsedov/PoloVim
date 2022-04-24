local config = {}
-- local bind = require('keymap.bind')
-- local map_cr = bind.map_cr
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
-- local loader = require"packer".loader
function config.filetype()
    require("filetype").setup({
        overrides = {
            literal = {
                ["kitty.conf"] = "kitty",
                [".gitignore"] = "conf",
            },
            complex = {
                [".clang*"] = "yaml",
                [".*%.env.*"] = "sh",
                [".*ignore"] = "conf",
            },
            extensions = {
                tf = "terraform",
                tfvars = "terraform",
                hcl = "hcl",
                tfstate = "json",
                eslintrc = "json",
                prettierrc = "json",
                mdx = "markdown",
            },
        },
    })
end
function config.nvim_treesitter()
    require("modules.lang.treesitter").treesitter()
end

function config.endwise()
    require("modules.lang.treesitter").endwise()
end

function config.treesitter_obj()
    require("modules.lang.treesitter").treesitter_obj()
end

function config.treesitter_ref()
    require("modules.lang.treesitter").treesitter_ref()
end

function config.pyfold()
    require("modules.lang.treesitter").pyfold()
end

function config.neogen()
    require("neogen").setup({
        snippet_engine = "luasnip",
        languages = {
            lua = {
                template = { annotation_convention = "emmylua" },
            },
            python = {
                template = { annotation_convention = "numpydoc" },
            },
            c = {
                template = { annotation_convention = "doxygen" },
            },
        },
    })
end

function config.refactor()
    local refactor = require("refactoring")
    refactor.setup({
      print_var_statements = {
          -- add a custom print var statement for cpp
          python = {
            'log.info(ic.format(f"{%%s} %s , %s")'
          }
      }

    })

    lprint("refactor")
    _G.ts_refactors = function()
        -- telescope refactoring helper
        local function _refactor(prompt_bufnr)
            local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
            require("telescope.actions").close(prompt_bufnr)
            require("refactoring").refactor(content.value)
        end

        local opts = require("telescope.themes").get_cursor() -- set personal telescope options
        require("telescope.pickers").new(opts, {
            prompt_title = "refactors",
            finder = require("telescope.finders").new_table({
                results = require("refactoring").get_refactors(),
            }),
            sorter = require("telescope.config").values.generic_sorter(opts),
            attach_mappings = function(_, map)
                map("i", "<CR>", _refactor)
                map("n", "<CR>", _refactor)
                return true
            end,
        }):find()
    end

    -- vim.api.nvim_set_keymap("v", "<Leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
    -- vim.api.nvim_set_keymap("v", "<Leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
    -- vim.api.nvim_set_keymap("v", "<Leader>rt", [[ <Esc><Cmd>lua M.refactors()<CR>]], {noremap = true, silent = true, expr = false})
end

function config.neorunner()
    vim.g.runner_c_compiler = "gcc"
    vim.g.runner_cpp_compiler = "g++"
    vim.g.runner_c_options = "-Wall"
    vim.g.runner_cpp_options = "-std=c++11 -Wall"
end

function config.jaq()
    require("jaq-nvim").setup({
        -- Commands used with 'Jaq'
        cmds = {
            -- Default UI used (see `Usage` for options)
            default = "float",

            -- Uses external commands such as 'g++' and 'cargo'
            external = {
                javascript = "node",
                java = "cd $dir && javac $file && java $fileBase",
                c = "gcc $file -o $fileBase && ./$fileBase",
                cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
                python = "cd $dir && python3 $file ",
                shellscript = "bash",
                csharp = "cd $dir && mcs $fileName && mono $fileNameWithoutExt.exe",
                typescript = "deno run",
                rust = "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
                dart = "dart",
            },
            -- Uses internal commands such as 'source' and 'luafile'
            internal = {
                lua = "luafile %",
                vim = "source %",
            },
        },

        -- UI settings
        ui = {
            -- Start in insert mode
            startinsert = false,

            -- Floating Window settings
            float = {
                -- Floating window border (see ':h nvim_open_win')
                border = "none",

                -- Num from `0 - 1` for measurements
                height = 0.8,
                width = 0.8,

                -- Highlight group for floating window/border (see ':h winhl')
                border_hl = "FloatBorder",
                float_hl = "Normal",

                -- Floating Window Transparency (see ':h winblend')
                blend = 0,
            },

            terminal = {
                -- Position of terminal
                position = "bot",

                -- Size of terminal
                size = 10,
            },

            quickfix = {
                -- Position of quickfix window
                position = "bot",

                -- Size of quickfix window
                size = 10,
            },
        },
    })
end

function config.goto_preview()
    vim.cmd([[command! -nargs=* GotoPrev lua require('goto-preview').goto_preview_definition()]])
    vim.cmd([[command! -nargs=* GotoImp lua require('goto-preview').goto_preview_implementation()]])
    vim.cmd([[command! -nargs=* GotoTel lua require('goto-preview').goto_preview_references()]])

    require("goto-preview").setup({
        width = 120, -- Width of the floating window
        height = 15, -- Height of the floating window
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
    })
end

function config.tsubject()
    require("nvim-treesitter.configs").setup({
        textsubjects = {
            enable = true,
            keymaps = { ["<CR>"] = "textsubjects-smart", [";"] = "textsubjects-container-outer" },
        },
    })
end

function config.outline()
    vim.g.symbols_outline = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = true,
        position = "right",
        relative_width = true,
        width = 25,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = "Pmenu",
        keymaps = { -- These keymaps can be a string or a table for multiple keys
            close = { "<Esc>", "q" },
            goto_location = "<Cr>",
            focus_location = "o",
            hover_symbol = "<C-space>",
            toggle_preview = "K",
            rename_symbol = "r",
            code_actions = "a",
        },
        lsp_blacklist = {},
        symbol_blacklist = {},
        symbols = {
            File = { icon = "", hl = "TSURI" },
            Module = { icon = "", hl = "TSNamespace" },
            Namespace = { icon = "", hl = "TSNamespace" },
            Package = { icon = "", hl = "TSNamespace" },
            Class = { icon = "𝓒", hl = "TSType" },
            Method = { icon = "ƒ", hl = "TSMethod" },
            Property = { icon = "", hl = "TSMethod" },
            Field = { icon = "", hl = "TSField" },
            Constructor = { icon = "", hl = "TSConstructor" },
            Enum = { icon = "ℰ", hl = "TSType" },
            Interface = { icon = "ﰮ", hl = "TSType" },
            Function = { icon = "", hl = "TSFunction" },
            Variable = { icon = "", hl = "TSConstant" },
            Constant = { icon = "", hl = "TSConstant" },
            String = { icon = "𝓐", hl = "TSString" },
            Number = { icon = "#", hl = "TSNumber" },
            Boolean = { icon = "⊨", hl = "TSBoolean" },
            Array = { icon = "", hl = "TSConstant" },
            Object = { icon = "⦿", hl = "TSType" },
            Key = { icon = "🔐", hl = "TSType" },
            Null = { icon = "NULL", hl = "TSType" },
            EnumMember = { icon = "", hl = "TSField" },
            Struct = { icon = "𝓢", hl = "TSType" },
            Event = { icon = "🗲", hl = "TSType" },
            Operator = { icon = "+", hl = "TSOperator" },
            TypeParameter = { icon = "𝙏", hl = "TSParameter" },
        },
    }
end

function config.sqls() end

function config.ultest()
    require("modules.lang.language_utils").testStart()
end

function config.magma()
    vim.g.magma_automatically_open_output = false
end

function config.sniprun()
    require("modules.lang.language_utils").load_snip_run()
end

function config.syntax_folding()
    local fname = vim.fn.expand("%:p:f")
    local fsize = vim.fn.getfsize(fname)
    if fsize > 1024 * 1024 then
        print("disable syntax_folding")
        vim.api.nvim_command("setlocal foldmethod=indent")
        return
    end
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    vim.o.foldtext =
        [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
    vim.opt.fillchars = "fold: "
    vim.wo.foldnestmax = 3
    vim.wo.foldminlines = 1
end

-- https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8

function config.context()
    require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    })
end

-- function config.treehopper() end

function config.playground()
    require("nvim-treesitter.configs").setup({
        playground = {
            enable = true,
            disable = {},
            updatetime = 50, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = true, -- Whether the query persists across vim sessions
        },
    })
end
function config.luadev()
    vim.cmd([[vmap <leader><leader>lr <Plug>(Luadev-Run)]])
end

function config.dap()
    require("modules.lang.dap.init")
end

function config.yabs()
    require("yabs"):setup({
        languages = { -- List of languages in vim's `filetype` format
            lua = {
                tasks = {
                    run = {
                        command = "luafile %", -- The command to run (% and other
                        -- wildcards will be automatically
                        -- expanded)
                        type = "vim", -- The type of command (can be `vim`, `lua`, or
                        -- `shell`, default `shell`)
                    },
                },
            },
            python = {
                default_task = "run",
                tasks = {
                    run = {
                        command = "poetry run python %", -- The command to run (% and other
                        output = "quickfix",
                        -- wildcards will be automatically
                        -- expanded)
                        type = "shell", -- The type of command (can be `vim`, `lua`, or
                        -- `shell`, default `shell`)
                    },
                    build = {
                        command = "poetry run task lint", -- The command to run (% and other
                        output = "quickfix", -- Where to show output of the
                    },
                },
            },
            c = {
                default_task = "build_and_run",
                tasks = {
                    build = {
                        command = "gcc main.c -o main",
                        output = "quickfix", -- Where to show output of the
                        -- command. Can be `buffer`,
                        -- `consolation`, `echo`,
                        -- `quickfix`, `terminal`, or `none`
                        opts = { -- Options for output (currently, there's only
                            -- `open_on_run`, which defines the behavior
                            -- for the quickfix list opening) (can be
                            -- `never`, `always`, or `auto`, the default)
                            open_on_run = "always",
                        },
                    },
                    run = { -- You can specify as many tasks as you want per
                        -- filetype
                        command = "./main",
                        output = "consolation",
                    },
                    build_and_run = { -- Setting the type to lua means the command
                        -- is a lua function
                        command = function()
                            -- The following api can be used to run a task when a
                            -- previous one finishes
                            -- WARNING: this api is experimental and subject to
                            -- changes
                            require("yabs"):run_task("build", {
                                -- Job here is a plenary.job object that represents
                                -- the finished task, read more about it here:
                                -- https://github.com/nvim-lua/plenary.nvim#plenaryjob
                                on_exit = function(Job, exit_code)
                                    -- The parameters `Job` and `exit_code` are optional,
                                    -- you can omit extra arguments or
                                    -- skip some of them using _ for the name
                                    if exit_code == 0 then
                                        require("yabs").languages.c:run_task("run")
                                    end
                                end,
                            })
                        end,
                        type = "lua",
                    },
                },
            },
        },
        tasks = { -- Same values as `language.tasks`, but global
            build = {
                command = "echo building project...",
                output = "consolation",
            },
            run = {
                command = "echo running project...",
                output = "echo",
            },
            optional = {
                command = "echo runs on condition",
                -- You can specify a condition which determines whether to enable a
                -- specific task
                -- It should be a function that returns boolean,
                -- not a boolean directly
                -- Here we use a helper from yabs that returns such function
                -- to check if the files exists
                condition = require("yabs.conditions").file_exists("filename.txt"),
            },
        },
        opts = { -- Same values as `language.opts`
            output_types = {
                quickfix = {
                    open_on_run = "always",
                },
            },
        },
    })
end

function config.todo_comments()
    require("todo-comments").setup({

        signs = true, -- show icons in the signs column
        sign_priority = 8, -- sign priority
        -- keywords recognized as todo comments
        keywords = {
            FIX = {
                icon = " ", -- icon used for the sign, and in search results
                color = "error", -- can be a hex color, or a named color (see below)
                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                -- signs = false, -- configure signs for some keywords individually
            },
            TODO = { icon = " ", color = "info", alt = { "REVIST" } },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
        merge_keywords = true, -- when true, custom keywords will be merged with the defaults
        -- highlighting of the line containing the todo comment
        -- * before: highlights before the keyword (typically comment characters)
        -- * keyword: highlights of the keyword
        -- * after: highlights after the keyword (todo text)
        highlight = {
            before = "", -- "fg" or "bg" or empty
            keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
            after = "fg", -- "fg" or "bg" or empty
            pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
            comments_only = true, -- uses treesitter to match keywords in comments only
            max_line_len = 400, -- ignore lines longer than this
            exclude = {}, -- list of file types to exclude highlighting
        },
        -- list of named colors where we try to extract the guifg from the
        -- list of hilight groups or use the hex color if hl not found as a fallback
        colors = {
            error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
            warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
            info = { "DiagnosticInfo", "#2563EB" },
            hint = { "DiagnosticHint", "#10B981" },
            default = { "Identifier", "#7C3AED" },
        },
        search = {
            command = "rg",
            args = {
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
            },
            -- regex that will be used to match keywords.
            -- don't replace the (KEYWORDS) placeholder
            pattern = [[\b(KEYWORDS):]], -- ripgrep regex
            -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        },
    })
end

return config
