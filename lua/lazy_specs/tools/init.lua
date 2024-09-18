return {
    {
        "nvim-jqx",
        ft = "json",
        cmd = { "JqxList", "JqxQuery" },
    },

    {
        "watch.nvim",
        cmd = { "WatchStart", "WatchStop", "WatchFile" },
    },
    {
        "yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            open_for_directories = false,
        },
        cmd = "Yazi",
    },

    {
        "paperplanes.nvim",
        cmd = { "PP" },
        opts = {
            register = "+",
            provider = "dpaste.org",
            provider_options = {},
            notifier = vim.notify or print,
        },
    },
    {
        "vim-markdown",
        opt = true,
        ft = { "markdown", "pandoc.markdown", "rmd" },
        dependencies = { "godlygeek/tabular" },
        cmd = { "Toc" },
    },

    {
        "markdown-preview.nvim",
        opt = true,
        ft = { "markdown", "pandoc.markdown", "rmd", "norg" },
        build = [[sh -c "cd app && yarn install"]],
    },

    {
        "toggleterm.nvim",
        event = "BufWinEnter",
        cmd = { "FocusTerm", "TermExec", "ToggleTerm", "Htop", "GDash" },
        after = function()
            local toggleterm = require("toggleterm")
            local Terminal = require("toggleterm.terminal").Terminal

            -- Function to remove keymaps "jk" and "<esc>" from the terminal buffer
            local function float_handler(term)
                if vim.fn.mapcheck("jk", "t") ~= "" then
                    vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
                    vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
                end
            end

            -- Define terminals
            local terminals = {
                Htop = Terminal:new({
                    cmd = "htop",
                    hidden = true,
                    direction = "float",
                    on_open = float_handler,
                }),
                Ghdash = Terminal:new({
                    cmd = "gh dash",
                    hidden = true,
                    direction = "float",
                    on_open = float_handler,
                    float_opts = {
                        height = function()
                            return math.floor(vim.o.lines * 0.8)
                        end,
                        width = function()
                            return math.floor(vim.o.columns * 0.95)
                        end,
                    },
                }),
                Nap = Terminal:new({
                    cmd = "nap",
                    hidden = true,
                    direction = "float",
                    on_open = float_handler,
                }),
            }

            -- Set keymap bindings using a table
            local keymaps = {
                { ";t0", "<cmd>ToggleTermToggleAll<CR>", desc = "Toggle display all terminals" },
                { ";t1", "<cmd>1ToggleTerm<CR>", desc = "Toggle terminal with id 1" },
                { ";t2", "<cmd>2ToggleTerm<CR>", desc = "Toggle terminal with id 2" },
                { ";t3", "<cmd>3ToggleTerm<CR>", desc = "Toggle terminal with id 3" },
                { ";t4", "<cmd>4ToggleTerm<CR>", desc = "Toggle terminal with id 4" },
                {
                    ";!",
                    [[<cmd>execute v:count . "TermExec cmd='exit;'"<CR>]],
                    silent = true,
                    desc = "Quit terminal",
                },
                {
                    "<Leader>gh",
                    function()
                        Terminal:new({ cmd = "lazygit", hidden = true }):toggle()
                    end,
                },
                { ";tf", "<cmd>ToggleTerm direction='vertical'<cr>" },
                { ";th", "<cmd>ToggleTerm direction='vertical'<cr>" },
            }

            -- Create keymap bindings from the table
            for _, mapping in ipairs(keymaps) do
                vim.keymap.set("n", mapping[1], mapping[2], mapping[3] or {})
            end

            -- captilize

            -- Create commands to toggle terminals
            for name, terminal in pairs(terminals) do
                lambda.command(name, function()
                    terminal:toggle()
                end, {})
            end

            -- Configure toggleterm
            toggleterm.setup({
                open_mapping = [[<c-t>]],
                shade_filetypes = { "none" },
                -- on_open = function()
                --     -- Check if conda is in an env and if so activate it before
                --     -- opening the terminal
                --     local python_env = os.getenv("PYTHONENV")
                --     -- if python_env ~= nil then
                --     --      "conda activate " .. python_env
                --     -- end
                -- end,
                -- on_create = fun(t: Terminal), -- function to run when the terminal is first created
                -- on_open = fun(t: Terminal), -- function to run when the terminal opens
                -- on_close = fun(t: Terminal), -- function to run when the terminal closes
                -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
                -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
                -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
                on_create = function(term)
                    -- local python_env = os.getenv("PYTHONENV")
                    -- vim.defer_fn(function()
                    --     if python_env ~= nil then
                    --         term:send("conda deactivate")
                    --         term:send(string.format("conda activate %s", python_env))
                    --     end
                    -- end, 100)
                end,
                direction = "horizontal",
                insert_mappings = false,
                start_in_insert = true,
                float_opts = { border = "rounded", winblend = 3 },
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return math.floor(vim.o.columns * 0.4)
                    end
                end,
            })
        end,
        keys = {
            ";t0",
            ";t1",
            ";t2",
            ";t3",
            ";t4",
            ";t!",
            "<leader>gh",
            ";tf",
            ";th",
            "<c-t>",
        },
    },

    {
        "vim-translator",
        beforeAll = function()
            vim.g.translator_source_lang = "jp"
        end,
        cmd = { "Translate", "TranslateW", "TranslateR", "TranslateH", "TranslateL" },
    },

    {
        "pre-commit.nvim",
        cmd = "Precommit",
    },

    {
        "suda.vim",
        cmd = {
            "SudaRead",
            "SudaWrite",
            "SudoRead",
            "SudoWrite",
        },
        beforeAll = function()
            vim.g.suda_smart_edit = 1
            lambda.command("SudoWrite", function()
                vim.cmd([[SudaWrite]])
            end, {})
            lambda.command("SudoReadk", function()
                vim.cmd([[SudaRead]])
            end, {})
        end,
    },

    {
        "capslock.nvim",
        keys = "<leader><leader>;",
        after = function()
            require("capslock").setup()
            vim.keymap.set(
                { "i", "c", "n" },
                "<leader><leader>;",
                "<Plug>CapsLockToggle<Cr>",
                { noremap = true, desc = "Toggle CapsLock" }
            )
        end,
    },

    {
        "vim-startuptime",
        cmd = "StartupTime",
        after = function()
            vim.g.startuptime_tries = 15
            vim.g.startuptime_exe_args = { "+let g:auto_session_enabled = 0" }
        end,
    },

    {
        "nvim-genghis",
        cmd = {
            "GenghiscopyFilepath",
            "GenghiscopyFilename",
            "Genghischmodx",
            "GenghisrenameFile",
            "GenghiscreateNewFile",
            "GenghisduplicateFile",
            "Genghistrash",
            "Genghismove",
        },
        after = function()
            local genghis = require("genghis")
            lambda.command("GenghiscopyFilepath", genghis.copyFilepath, {})
            lambda.command("GenghiscopyFilename", genghis.copyFilename, {})
            lambda.command("Genghischmodx", genghis.chmodx, {})
            lambda.command("GenghisrenameFile", genghis.renameFile, {})
            lambda.command("GenghiscreateNewFile", genghis.createNewFile, {})
            lambda.command("GenghisduplicateFile", genghis.duplicateFile, {})
            lambda.command("Genghistrash", function()
                genghis.trashFile({ trashLocation = "/home/viv/.local/share/Trash/" })
            end, {})
            lambda.command("Genghismove", genghis.moveSelectionToNewFile, {})
        end,
    },

    -- {
    --     "nvim-fundo",
    --     event = "BufReadPre",
    --     cmd = { "FundoDisable", "FundoEnable" },
    --     build = function()
    --         require("fundo").install()
    --     end,
    -- },

    {
        "date-time-inserter.nvim",
        cmd = {
            "InsertDate",
            "InsertTime",
            "InsertDateTime",
        },
        after = true,
    },

    {
        "term-edit.nvim",
        event = "TermEnter",
        after = function()
            require("term-edit").setup({
                prompt_end = "[»#$] ",
                mapping = {
                    n = { s = false, S = false },
                },
            })
        end,
    },
    {
        "stevearc/quicker.nvim",
        event = "FileType qf",
        keys = {
            { "\\lq", mode = "n" },
            { "\\ll", mode = "n" },
            { "\\>", mode = "n" },
            { "\\<", mode = "n" },
        },
        after = function()
            vim.keymap.set("n", "\\lq", function()
                require("quicker").toggle()
            end, {
                desc = "Toggle quickfix",
            })
            vim.keymap.set("n", "\\ll", function()
                require("quicker").toggle({ loclist = true })
            end, {
                desc = "Toggle loclist",
            })
            require("quicker").setup({
                keys = {
                    {
                        "\\>",
                        function()
                            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                        end,
                        desc = "Expand quickfix context",
                    },
                    {
                        "\\<",
                        function()
                            require("quicker").collapse()
                        end,
                        desc = "Collapse quickfix context",
                    },
                },
            })
        end,
    },
}
