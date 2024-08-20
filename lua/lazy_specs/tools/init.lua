local conf = require("modules.tools.config")
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
        init = conf.markdown,
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
            require("modules.tools.toggleterm")
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
