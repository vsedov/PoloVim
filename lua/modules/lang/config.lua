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
                'ic(f"{ %s }")',
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
    vim.keymap.set(
        "v",
        "<leader>rr",
        "<cmd>lua require('refactoring').select_refactor()<CR>",
        { noremap = true, silent = true, expr = false }
    )
    -- You can also use below = true here to to change the position of the printf
    -- statement (or set two remaps for either one). This remap must be made in normal mode.
    vim.keymap.set("n", "d?v", "<cmd>lua require('refactoring').debug.printf({below = false})<CR>", { noremap = true })

    -- Print var

    -- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
    vim.keymap.set(
        "n",
        "d?V",
        "<cmd>lua require('refactoring').debug.print_var({ normal = true })<CR>",
        { noremap = true }
    )
    -- Remap in visual mode will print whatever is in the visual selection
    vim.keymap.set("v", "<leader>rv", "<cmd>lua require('refactoring').debug.print_var({})<CR>", { noremap = true })

    -- Cleanup function: this remap should be made in normal mode
    vim.keymap.set("n", "<leader>rc", "<cmd>lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })
end

function config.debugprint()
    require("debugprint").setup({
        create_keymaps = true,
    })

    vim.keymap.set(
        "n",
        "dvl",
        "<cmd>lua require('debugprint').debugprint({ ignore_treesitter = true, variable = true })<CR>",
        { noremap = true, desc = { "Debug print var above" } }
    )
    vim.keymap.set(
        "n",
        "dvl",
        "<cmd>lua require('debugprint').debugprint({ ignore_treesitter = true, above = true, variable = true })<CR>",
        { noremap = true, desc = { "Debug print var above" } }
    )
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

function config.trouble()
    require("trouble").setup({})
end

function config.dev_comments()
    require("dev_comments").setup({
        -- Enables vim.notify messages
        debug = false,
        -- Creates <Plug> mappings
        default_mappings = false,
        -- Create user commands
        default_commands = true,
        -- Each call of dev-comments is cached
        -- Play around with the reset autocommands for more aggressive caching
        cache = {
            enabled = true,
            reset_autocommands = { "BufWritePost", "BufWinEnter" },
        },
        -- Improves performance when searching in a large directory
        -- Requires ripgrep or grep
        pre_filter = {
            -- If search fails, uses plenary scandir (very slow)
            fallback_to_plenary = true,
        },
        -- Highlight for the tag in picker (not in buffer)
        highlight = {
            tags = {
                ["TODO"] = "TSWarning",
                ["PERF"] = "TSWarning",
                ["HACK"] = "TSWarning",
                ["WARNING"] = "TSWarning",
                ["OPTIM"] = "TSWarning",
                ["REVISIT"] = "TSDanger",
                ["FIXME"] = "TSDanger",
                ["XXX"] = "TSDanger",
                ["BUG"] = "TSDanger",
            },
            -- Used if lookup fails for a given tag
            fallback = "TSNote",
        },
    })

    -- <Plug> keymaps
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeCurrent", function()
        require("telecope").extensions.dev_comments.current({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeOpen", function()
        require("telecope").extensions.dev_comments.open({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeAll", function()
        require("telecope").extensions.dev_comments.open({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsCyclePrev", function()
        require("dev_comments.cycle").goto_prev()
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsCycleNext", function()
        require("dev_comments.cycle").goto_next()
    end, { silent = true })

    -- Keybinds
    vim.keymap.set("n", "[w", "<Plug>DevCommentsCyclePrev")
    vim.keymap.set("n", "]w", "<Plug>DevCommentsCycleNext")
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
    require("modules.lang.overseer")
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
