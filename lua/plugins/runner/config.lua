local config = {}
function config.overseer()
    require("modules.runner.overseer")
end

function config.code_runner()
    require("code_runner").setup({
        startinsert = true,
        term = {
            -- tab = true,
            size = 15,
        },
        filetype = {
            javascript = "node",
            java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
            kotlin = "cd $dir && kotlinc-native $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt.kexe",
            c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
            cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
            python = "python -u",
            sh = "bash",
            typescript = "deno run",
            typescriptreact = "yarn dev$end",
            rust = "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
            dart = "dart",
            cs = function(...)
                local root_dir = require("lspconfig").util.root_pattern("*.csproj")(vim.loop.cwd())
                return "cd " .. root_dir .. " && dotnet run$end"
            end,
            scala = "scala $fileName",
            haskell = "cd $dir && ghc -dynamic $fileName &&./$fileNameWithoutExt",
        },
        -- project_path = vim.fn.expand("~/.config/nvim/project_manager.json"),
    })
end

function config.neotest()
    require("neotest").setup({
        adapters = {
            require("neotest-python")({
                dap = {
                    justMyCode = false,
                    console = "integratedTerminal",
                },
                -- args = { "--log-level", "DEBUG", "--quiet"  },-- show stdoutput
                -- - verbose output;
                -- - standard output displayed;
                -- - test duration displayed for the slowest 3 tests;
                -- - long traceback for failed tests;
                -- - execution stops after the first failure;
                -- - local variables displayed in traceback;
                -- - colored output;
                -- - logging level set to 'warning'.
                args = {
                    "-v",
                    "-s",
                    "--durations",
                    "3",
                    "--tb",
                    "long",
                    "-x",
                    "-l",
                    "--color",
                    "yes",
                    "--log-level",
                    "DEBUG",
                    "--quiet",
                }, -- show stdoutput

                runner = "pytest",
            }),
            require("neotest-plenary"),
            require("neotest-vim-test")({
                ignore_file_types = { "python", "vim", "lua" },
            }),
        },
        diagnostic = {
            enabled = false, -- this is not really required.
        },
        consumers = {
            overseer = require("neotest.consumers.overseer"),
        },
        overseer = {
            enabled = true,
            force_default = true,
        },
        discovery = {
            enabled = true,
        },

        summary = {
            mappings = {
                attach = "a",
                expand = "l",
                expand_all = "L",
                jumpto = "gf",
                output = "o",
                run = "<C-r>",
                short = "p",
                stop = "u",
            },
        },
        icons = {
            passed = " ",
            running = " ",
            failed = " ",
            unknown = " ",
            running_animated = vim.tbl_map(function(s)
                return s .. " "
            end, { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }),
        },
        output = {
            enabled = true,
            open_on_run = true,
        },
        status = {
            enabled = true,
        },
        quickfix = {
            enabled = false,
        },
    })
    function setup_commands_keymaps()
        local open_win_split = function(split_or_vsplit, size)
            if split_or_vsplit == "split" then
                vim.cmd(string.format([[ botright %dsplit ]], size))
            else
                vim.cmd(string.format([[ %dvsplit ]], size))
            end
            local win_id = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_option(win_id, "number", false)
            vim.api.nvim_win_set_option(win_id, "signcolumn", "no")
            return win_id
        end

        lambda.command("NeotestOutputSplit", function(opts)
            local height = tonumber(opts.args) or 20
            require("neotest").output.open({
                open_win = function()
                    return open_win_split("split", height)
                end,
            })
        end, { nargs = "?" })
        lambda.command("NeotestOutputVSplit", function(opts)
            local width = tonumber(opts.args) or 70
            require("neotest").output.open({
                open_win = function()
                    return open_win_split("vsplit", width)
                end,
            })
        end, { nargs = "?" })
        lambda.command("NeotestRun", function()
            require("neotest").run.run()
        end, { nargs = 0 })
        lambda.command("NeotestRunFile", function()
            require("neotest").run.run(vim.fn.expand("%"))
        end, { nargs = 0 })
        lambda.command("NeotestStop", function()
            require("neotest").run.stop()
        end, { nargs = 0 })

        lambda.command("NeotestOutputPanel", function()
            require("neotest").output_panel.open()
        end, { nargs = 0 })
        lambda.command("NeotestSummary", function()
            require("neotest").summary.toggle()
        end, { nargs = 0 })
        lambda.command("TestOutput", function()
            require("neotest").output.open()
        end, { nargs = 0 })
    end

    setup_commands_keymaps()
end

return config
