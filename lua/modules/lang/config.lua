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

function config.tsubject()
    require("nvim-treesitter.configs").setup({
        textsubjects = {
            enable = true,
            keymaps = { ["<CR>"] = "textsubjects-smart", [";"] = "textsubjects-container-outer" },
        },
    })
end

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

function config.refactor()
    local refactor = require("refactoring")
    refactor.setup({})

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

function config.context()
    require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    })
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
function config.trouble()
    require("trouble").setup({})
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
function config.luadev()
    vim.cmd([[vmap <leader><leader>lr <Plug>(Luadev-Run)]])
end
function config.luapad()
    require("luapad").setup({
        count_limit = 150000,
        error_indicator = true,
        eval_on_move = true,
        error_highlight = "WarningMsg",
        on_init = function()
            print("Hello from Luapad!")
        end,
        context = {
            the_answer = 42,
            shout = function(str)
                return (string.upper(str) .. "!")
            end,
        },
    })
end

function config.dap()
    require("modules.lang.dap.init")
end

return config
