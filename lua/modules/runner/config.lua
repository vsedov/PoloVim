local config = {}
function config.overseer()
    require("modules.runner.overseer")
end

function config.executor()
    require("executor").setup({
        preset_commands = {
            ["*.py"] = {
                "python -m unittest",
                "pytest",
                "python3 script.py",
            },
        },
    })
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
                dap = { justMyCode = false },
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
        discovery = {
            enabled = false,
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
            enabled = true,
        },
    })
end

return config
