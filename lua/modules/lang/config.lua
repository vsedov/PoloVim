local config = {}

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

    -- lprint("refactor")
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
end

function config.debugprint()
    require("debugprint").setup({
        create_keymaps = true,
    })
end

function config.dev_comments()
    require("dev_comments").setup({
        -- Enables vim.notify messages
        debug = false,
        -- Creates <Plug> mappings
        default_mappings = true,
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
                ["NOTE"] = "TSWarning",
                ["PERF"] = "TSWarning",
                ["HACK"] = "TSWarning",
                ["WARNING"] = "TSWarning",
                ["OPTIM"] = "TSWarning",
                ["TRIAL"] = "TSWarning",
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

function config.dap_config()
    -- require("modules.lang.dap.init").config()
    -- Explore:
    -- - External terminal
    -- - make the virt lines thing available if ppl want it
    -- - find the nearest codelens above cursor

    -- Must Show:
    -- - Connect to an existing neovim instance, and step through some plugin
    -- - Connect using configuration from VS **** json file (see if VS **** is actually just "it works" LUL)
    -- - Completion in the repl, very cool for exploring objects / data

    -- - Generating your own config w/ dap.run (can show rust example) (rust BTW)

    local has_dap, dap = pcall(require, "dap")
    if not has_dap then
        return
    end

    vim.fn.sign_define("DapBreakpoint", { text = "ß", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "ü", texthl = "", linehl = "", numhl = "" })
    -- Setup cool Among Us as avatar
    vim.fn.sign_define("DapStopped", { text = "ඞ", texthl = "Error" })

    require("nvim-dap-virtual-text").setup({
        enabled = true,

        -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
        enabled_commands = false,

        -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_changed_variables = true,
        highlight_new_as_changed = true,

        -- prefix virtual text with comment string
        commented = false,

        show_stop_reason = true,

        -- experimental features:
        virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    })

    -- TODO: How does terminal work?
    dap.defaults.fallback.external_terminal = {
        command = "/home/tjdevries/.local/bin/kitty",
        args = { "-e" },
    }

    dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host, port = config.port })
    end

    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
            host = function()
                return "127.0.0.1"
            end,
            port = function()
                -- local val = tonumber(vim.fn.input('Port: '))
                -- assert(val, "Please provide a port number")
                local val = 54231
                return val
            end,
        },
    }

    dap.adapters.c = {
        name = "lldb",

        type = "executable",
        attach = {
            pidProperty = "pid",
            pidSelect = "ask",
        },
        command = "lldb-vscode-11",
        env = {
            LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
        },
    }

    dap.configurations.c = {
        {
            name = "Launch binary nvim",
            type = "c",
            request = "launch",
            program = "./build/bin/nvim",
            args = {
                "--headless",
                "-c",
                'echo getcompletion("vim.api.nvim_buf_", "lua")',
                "-c",
                "qa!",
            },
            cwd = nil,
            environment = nil,
            externalConsole = true,
            MIMode = "lldb",
        },
        {
            name = "Deprecated",
            type = "c",
            request = "attach",
            program = "./build/bin/nvim",
            cwd = vim.fn.expand("~/build/neovim/"),
            -- environment = nil,
            externalConsole = false,
            MIMode = "gdb",
        },
        {
            name = "Attach to Neovim",
            type = "c",
            request = "attach",
            program = vim.fn.expand("~/build/neovim/build/bin/nvim"),
            cwd = vim.fn.getcwd(),
            externalConsole = true,
            MIMode = "gdb",
        },
        {
            -- If you get an "Operation not permitted" error using this, try disabling YAMA:
            --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            --
            -- Careful, don't try to attach to the neovim instance that runs *this*
            name = "Fancy attach",
            type = "c",
            request = "attach",
            pid = function()
                local output = vim.fn.system({ "ps", "a" })
                local lines = vim.split(output, "\n")
                local procs = {}
                for _, line in pairs(lines) do
                    -- output format
                    --    " 107021 pts/4    Ss     0:00 /bin/zsh <args>"
                    local parts = vim.fn.split(vim.fn.trim(line), " \\+")
                    local pid = parts[1]
                    local name = table.concat({ unpack(parts, 5) }, " ")
                    if pid and pid ~= "PID" then
                        pid = tonumber(pid)
                        if pid ~= vim.fn.getpid() then
                            table.insert(procs, { pid = pid, name = name })
                        end
                    end
                end
                local choices = { "Select process" }
                for i, proc in ipairs(procs) do
                    table.insert(choices, string.format("%d: pid=%d name=%s", i, proc.pid, proc.name))
                end
                -- Would be cool to have a fancier selection, but needs to be sync :/
                -- Should nvim-dap handle coroutine results?
                local choice = vim.fn.inputlist(choices)
                if choice < 1 or choice > #procs then
                    return nil
                end
                return procs[choice].pid
            end,
            args = {},
        },
    }

    --  https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly
    dap.adapters.go = function(callback, _)
        local stdout = vim.loop.new_pipe(false)
        local handle, pid_or_err
        local port = 38697

        handle, pid_or_err = vim.loop.spawn("dlv", {
            stdio = { nil, stdout },
            args = { "dap", "-l", "127.0.0.1:" .. port },
            detached = true,
        }, function(code)
            stdout:close()
            handle:close()

            print("[delve] Exit Code:", code)
        end)

        assert(handle, "Error running dlv: " .. tostring(pid_or_err))

        stdout:read_start(function(err, chunk)
            assert(not err, err)

            if chunk then
                vim.schedule(function()
                    require("dap.repl").append(chunk)
                    print("[delve]", chunk)
                end)
            end
        end)

        -- Wait for delve to start
        vim.defer_fn(function()
            callback({ type = "server", host = "127.0.0.1", port = port })
        end, 100)
    end

    dap.configurations.go = {
        {
            type = "go",
            name = "Debug (from vscode-go)",
            request = "launch",
            showLog = false,
            program = "${file}",
            dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
        },
        {
            type = "go",
            name = "Debug (No File)",
            request = "launch",
            program = "",
        },
        {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}",
            showLog = true,
            -- console = "externalTerminal",
            -- dlvToolPath = vim.fn.exepath "dlv",
        },
        {
            name = "Test Current File",
            type = "go",
            request = "launch",
            showLog = true,
            mode = "test",
            program = ".",
            dlvToolPath = vim.fn.exepath("dlv"),
        },
        {
            type = "go",
            name = "Run lsif-clang indexer",
            request = "launch",
            showLog = true,
            program = ".",
            args = {
                "--indexer",
                "lsif-clang compile_commands.json",
                "--dir",
                vim.fn.expand("~/sourcegraph/lsif-clang/functionaltest"),
                "--debug",
            },
            dlvToolPath = vim.fn.exepath("dlv"),
        },
        {
            type = "go",
            name = "Run lsif-go-imports in smol_go",
            request = "launch",
            showLog = true,
            program = "./cmd/lsif-go",
            args = {
                "--project-root=/home/tjdevries/sourcegraph/smol_go/",
                "--repository-root=/home/tjdevries/sourcegraph/smol_go/",
                "--module-root=/home/tjdevries/sourcegraph/smol_go/",
                "--repository-remote=github.com/tjdevries/smol_go",
                "--no-animation",
            },
            dlvToolPath = vim.fn.exepath("dlv"),
        },
        {
            type = "go",
            name = "Run lsif-go-imports in sourcegraph",
            request = "launch",
            showLog = true,
            program = "./cmd/lsif-go",
            args = {
                "--project-root=/home/tjdevries/sourcegraph/sourcegraph.git/main",
                "--repository-root=/home/tjdevries/sourcegraph/sourcegraph.git/main",
                "--module-root=/home/tjdevries/sourcegraph/sourcegraph.git/main",
                "--no-animation",
            },
            dlvToolPath = vim.fn.exepath("dlv"),
        },
    }

    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Build api",
            program = "${file}",
            args = { "--target", "api" },
            console = "integratedTerminal",
        },
        {
            type = "python",
            request = "launch",
            name = "lsif",
            program = "src/lsif/__main__.py",
            args = {},
            console = "integratedTerminal",
        },
    }

    local dap_python = require("dap-python")
    dap_python.setup("python", {
        -- So if configured correctly, this will open up new terminal.
        --    Could probably get this to target a particular terminal
        --    and/or add a tab to kitty or something like that as well.
        console = "externalTerminal",

        include_configs = true,
    })

    dap_python.test_runner = "pytest"

    vim.cmd([[
augroup DapRepl
  au!
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
augroup END
]])

    local dap_ui = require("dapui")

    local _ = dap_ui.setup({
        layouts = {
            {
                elements = {
                    "scopes",
                    "breakpoints",
                    "stacks",
                    "watches",
                },
                size = 40,
                position = "left",
            },
            {
                elements = {
                    "repl",
                    "console",
                },
                size = 10,
                position = "bottom",
            },
        },
    })

    local original = {}
    local debug_map = function(lhs, rhs, desc)
        local keymaps = vim.api.nvim_get_keymap("n")
        original[lhs] = vim.tbl_filter(function(v)
            return v.lhs == lhs
        end, keymaps)[1] or true

        vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    local debug_unmap = function()
        for k, v in pairs(original) do
            if v == true then
                vim.keymap.del("n", k)
            else
                local rhs = v.rhs

                v.lhs = nil
                v.rhs = nil
                v.buffer = nil
                v.mode = nil
                v.sid = nil
                v.lnum = nil

                vim.keymap.set("n", k, rhs, v)
            end
        end

        original = {}
    end

    dap.listeners.after.event_initialized["dapui_config"] = function()
        debug_map("asdf", ":echo 'hello world<CR>", "showing things")

        dap_ui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
        debug_unmap()

        dap_ui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
        dap_ui.close()
    end

    local ok, dap_go = pcall(require, "dap-go")
    if ok then
        dap_go.setup()
    end
end

return config
