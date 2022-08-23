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

    refactor.setup({
        prompt_func_return_type = {
            go = true,
            java = true,

            cpp = false,
            c = false,
            h = false,
            hpp = false,
            cxx = false,
        },
        prompt_func_param_type = {
            go = false,
            java = false,
            cpp = false,
            c = false,
            h = false,
            hpp = false,
            cxx = false,
        },

        print_var_statements = {
            python = {
                'ic(f"{%s}")',
            },
        },
    })

    lprint("refactor")
    _G.ts_refactors = function()
        -- telescope refactoring helper
        local function _refactor(prompt_bufnr)
            local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
            require("telescope.actions").close(prompt_bufnr)
            require("refactoring").refactor(content.value)
        end

        require("telescope.pickers")
            .new({}, {
                prompt_title = "refactors",
                finder = require("telescope.finders").new_table({
                    results = require("refactoring").get_refactors(),
                }),
                sorter = require("telescope.config").values.generic_sorter({}),
                attach_mappings = function(_, map)
                    map("i", "<CR>", _refactor)
                    map("n", "<CR>", _refactor)
                    return true
                end,
            })
            :find()
    end

    -- Remaps for the refactoring operations currently offered by the plugin
    vim.keymap.set(
        "v",
        "<leader>re",
        [[<Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
        { noremap = true, silent = true, expr = false }
    )
    vim.keymap.set(
        "v",
        "<leader>rf",
        [[<Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
        { noremap = true, silent = true, expr = false }
    )
    vim.keymap.set(
        "v",
        "<leader>rv",
        [[<Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
    )
    vim.keymap.set(
        "v",
        "<leader>ri",
        [[<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
    )

    -- Extract block doesn't need visual mode
    vim.keymap.set(
        "n",
        "<leader>rb",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
        { noremap = true, silent = true, expr = false }
    )
    vim.keymap.set(
        "n",
        "<leader>rbf",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
        { noremap = true, silent = true, expr = false }
    )

    -- Inline variable can also pick up the identifier currently under the cursor without visual mode
    vim.keymap.set(
        "n",
        "<leader>ri",
        [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
    )
    vim.api.nvim_set_keymap(
        "v",
        "<leader>rr",
        "<cmd>lua require('refactoring').select_refactor()<CR>",
        { noremap = true, silent = true, expr = false }
    )
    -- You can also use below = true here to to change the position of the printf
    -- statement (or set two remaps for either one). This remap must be made in normal mode.
    vim.api.nvim_set_keymap(
        "n",
        "d?v",
        "<cmd>lua require('refactoring').debug.printf({below = false})<CR>",
        { noremap = true }
    )

    -- Print var

    -- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
    vim.api.nvim_set_keymap(
        "n",
        "d?V",
        "<cmd>lua require('refactoring').debug.print_var({ normal = true })<CR>",
        { noremap = true }
    )
    -- Remap in visual mode will print whatever is in the visual selection
    vim.api.nvim_set_keymap(
        "v",
        "<leader>rv",
        "<cmd>lua require('refactoring').debug.print_var({})<CR>",
        { noremap = true }
    )

    -- Cleanup function: this remap should be made in normal mode
    vim.api.nvim_set_keymap(
        "n",
        "<leader>rc",
        "<cmd>lua require('refactoring').debug.cleanup({})<CR>",
        { noremap = true }
    )
end

function config.debugprint()
    require("debugprint").setup({
        create_keymaps = true,
    })
    local bind_table = {

        ["dvl"] = {

            mode = "n",
            command = function()
                require("debugprint").debugprint({ ignore_treesitter = true, variable = true })
            end,
            desc = "Debug print var",
        },
        ["dvL"] = {
            mode = "n",
            command = function()
                require("debugprint").debugprint({ ignore_treesitter = true, above = true, variable = true })
            end,
            desc = { "Debug print var above" },
        },
    }

    for i, v in bind_table do
        vim.keymap.set(v.mode, i, v.command, { desc = v.desc })
    end
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
                julia = "cd $dir && julia $file",
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

function config.dap_setup()
    require("modules.lang.dap.init").setup()
end

function config.dap_config()
    require("modules.lang.dap.init").config()
end

function config.dapui()
    require("modules.lang.dap.init").dapui()
end

function config.neotest()
    vim.cmd([[packadd neotest-python]])
    vim.cmd([[packadd neotest-plenary]])
    vim.cmd([[packadd neotest-vim-test]])
    vim.cmd([[packadd overseer.nvim]])

    local add_cmd = vim.api.nvim_create_user_command

    require("neotest").setup({
        adapters = {
            require("neotest-python")({
                dap = { justMyCode = true },
            }),
            require("neotest-plenary"),
            require("neotest-vim-test")({
                ignore_file_types = { "python", "vim", "lua" },
            }),
        },
        diagnostic = {
            enabled = true,
        },
        consumers = {
            overseer = require("neotest.consumers.overseer"),
        },
        overseer = {
            enabled = true,
            -- When this is true (the default), it will replace all neotest.run.* commands
            force_default = true,
        },
        highlights = {
            adapter_name = "NeotestAdapterName",
            border = "NeotestBorder",
            dir = "NeotestDir",
            expand_marker = "NeotestExpandMarker",
            failed = "NeotestFailed",
            file = "NeotestFile",
            focused = "NeotestFocused",
            indent = "NeotestIndent",
            namespace = "NeotestNamespace",
            passed = "NeotestPassed",
            running = "NeotestRunning",
            skipped = "NeotestSkipped",
            test = "NeotestTest",
        },
        icons = {
            child_indent = "│",
            child_prefix = "├",
            collapsed = "─",
            expanded = "╮",
            failed = "✖",
            final_child_indent = " ",
            final_child_prefix = "╰",
            non_collapsible = "─",
            passed = "✔",
            running = "🗘",
            skipped = "ﰸ",
            unknown = "?",
        },
        output = {
            enabled = true,
            open_on_run = "short",
        },
        run = {
            enabled = true,
        },
        status = {
            enabled = true,
        },
        strategies = {
            integrated = {
                height = 40,
                width = 120,
            },
        },
        summary = {
            enabled = true,
            expand_errors = true,
            follow = true,
            mappings = {
                attach = "a",
                expand = { "<CR>", "<2-LeftMouse>" },
                expand_all = "e",
                jumpto = "i",
                output = "o",
                run = "r",
                short = "O",
                stop = "u",
            },
        },
    })

    -- cmd = { "TestNear", "TestCurrent", "TestSummary", "TestOutput", "TestStrat" , "TestStop"},
    -- test nearest file
    add_cmd("TestNear", function()
        require("neotest").run.run()
    end, { force = true })

    add_cmd("TestCurrent", function()
        require("neotest").run.run(vim.fn.expand("%"))
    end, { force = true })

    add_cmd("TestSummary", function()
        require("neotest").summary.toggle()
    end, { force = true })

    add_cmd("TestOutput", function()
        require("neotest").output.open({ enter = true })
    end, { force = true })

    add_cmd("TestStrat", function(args)
        local options = { "dap", "integrated" }
        if vim.tbl_contains(options, args.arg) then
            require("neotest").run.run({ strategy = args.args })
        else
            require("neotest").run.run({ strategy = "integrated" })
        end
    end, {
        force = true,
        nargs = 1,
    })

    add_cmd("TestStop", function()
        require("neotest").run.stop()
    end, { force = true })

    add_cmd("TestAttach", function()
        require("neotest").run.attach()
    end, { force = true })

    local cmd = {
        ["<leader>ur"] = "TestNear",
        ["<leader>uc"] = "TestCurrent",
        ["<leader>us"] = "TestSummary",
        ["<leader>uo"] = "TestOutput",
        ["<leader>uS"] = "TestStrat",
        ["<leader>uh"] = "TestStop",
    }

    for i, v in pairs(cmd) do
        vim.keymap.set("n", i, "<cmd>" .. v .. "<cr>", { buffer = 0 })
    end
end

function config.overseer()
    require("overseer").setup({
        pre_task_hook = function(task_defn)
            local env = require("utils.set_env").env
            if env then
                task_defn.env = env
                dump(task_defn)
            end
        end,

        component_aliases = {
            default = {
                "on_output_summarize",
                "on_exit_set_status",
                { "on_complete_notify", system = "unfocused" },
                "on_complete_dispose",
            },
            default_neotest = {
                { "on_complete_notify", system = "unfocused", on_change = true },
                "default",
            },
        },
        -- pre_task_hook = function(task_defn, util)
        --   util.add_component(task_defn, { "timeout", timeout = 19 })
        --   -- util.remove_component(task_defn, "timeout")
        -- end,
    })
    vim.api.nvim_create_user_command(
        "OverseerDebugParser",
        'lua require("overseer.parser.debug").start_debug_session()',
        {}
    )
    vim.keymap.set("n", "<leader>oo", "<cmd>OverseerToggle<CR>")
    vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<CR>")
    vim.keymap.set("n", "<leader>ol", "<cmd>OverseerLoadBundle<CR>")
    vim.keymap.set("n", "<leader>ob", "<cmd>OverseerBuild<CR>")
    vim.keymap.set("n", "<leader>od", "<cmd>OverseerQuickAction<CR>")
    vim.keymap.set("n", "<leader>os", "<cmd>OverseerTaskAction<CR>")
end
function config.coverage()
    require("coverage").setup()
end

function config.python_dev()
    require("py").setup({
        leader = "<leader><leader>",
        mappings = true,
        taskipy = true,
        poetry_install_every = 1,
        ipython_in_vsplit = 1,
        ipython_auto_install = 1,
        ipython_auto_reload = 1,
        ipython_send_imports = 1,
        envrc = {
            "layout_poetry",
            "export PYTHONPATH=$(pwd)",
            '#eval "$(register-python-argcomplete cz)"',
        },
        use_direnv = true,
    })
end

function config.goto_preview()
    local telescope = require("telescope.themes")

    require("goto-preview").setup({
        width = 80, -- Width of the floating window
        height = 15, -- Height of the floating window
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
            telescope = {
                require("telescope.themes").get_dropdown({
                    winblend = 15,
                    layout_config = {
                        prompt_position = "top",
                        width = 64,
                        height = 15,
                    },
                    border = {},
                    previewer = false,
                    shorten_path = false,
                }),
            },
        },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
    })
    vim.keymap.set("n", "gt", function()
        require("goto-preview").goto_preview_definition()
    end, { desc = "goto def", noremap = true })

    vim.keymap.set("n", "gi", function()
        require("goto-preview").goto_preview_implementation()
    end, { desc = "goto imp", noremap = true })

    vim.keymap.set("n", "gR", function()
        require("goto-preview").goto_preview_references()
    end, { desc = "goto referece", noremap = true })

    vim.keymap.set("n", "gC", function()
        require("goto-preview").close_all_win()
    end, { desc = "goto close all", noremap = true })
end

function config.regexplainer()
    vim.cmd([[packadd nui.nvim]])
    require("regexplainer").setup({
        -- 'narrative'
        mode = "narrative", -- TODO: 'ascii', 'graphical'

        -- automatically show the explainer when the cursor enters a regexp
        auto = false,

        -- filetypes (i.e. extensions) in which to run the autocommand
        filetypes = {
            "html",
            "js",
            "cjs",
            "mjs",
            "ts",
            "jsx",
            "tsx",
            "cjsx",
            "mjsx",
            "go",
            "lua",
            "vim",
            "python",
        },

        mappings = {
            toggle = "<localleader><localleader>",
        },

        narrative = {
            separator = "\n",
        },
    })
end

return config
