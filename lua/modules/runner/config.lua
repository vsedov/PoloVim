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
return config
