local conf = require("modules.tools.config")
local tools = require("core.pack").package
tools({
    "gennaro-tedesco/nvim-jqx",
    lazy = true,
    ft = "json",
    cmd = { "JqxList", "JqxQuery" },
})

tools({
    "is0n/fm-nvim",
    lazy = true,
    cmd = {
        "Lazygit", -- 3 [ neogit + fugative + lazygit depends how i feel.]
        "Joshuto", -- 2
        "Ranger",
        "Xplr", -- Nice but, i think ranger tops this one for the.time
        "Skim",
        "Nnn",
        "Fff",
        "Fzf",
        "Fzy",
    },
    config = conf.fm,
})
tools({
    "rktjmp/paperplanes.nvim",
    lazy = true,
    cmd = { "PP" },
    opts = {
        register = "+",
        provider = "dpaste.org",
        provider_options = {},
        notifier = vim.notify or print,
    },
})

tools({
    "rhysd/vim-grammarous",
    lazy = true,
    cmd = { "GrammarousCheck" },
    ft = { "markdown", "txt", "norg", "tex" },
    init = conf.grammarous,
})
-------------

tools({
    "plasticboy/vim-markdown",
    lazy = true,
    ft = { "markdown", "pandoc.markdown", "rmd" },
    dependencies = { "godlygeek/tabular" },
    cmd = { "Toc" },
    init = conf.markdown,
})

tools({
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = { "markdown", "pandoc.markdown", "rmd", "norg" },
    build = [[sh -c "cd app && yarn install"]],
})

tools({
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = { "FocusTerm", "TermExec", "ToggleTerm", "Htop", "GDash" },
    config = function()
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
})

tools({
    "wakatime/vim-wakatime",
    lazy = true,
})

tools({
    "ashfinal/qfview.nvim",
    -- event = "VeryLazy",
    ft = "qf",
    config = true,
})
tools({
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
        lambda.highlight.plugin("bqf", { { BqfPreviewBorder = { fg = { from = "Comment" } } } })
    end,
})
tools({
    "stevearc/qf_helper.nvim",
    ft = "qf",
    cmd = {
        "QFOpen",
        "QFNext",
        "QFPrev",
        "QFToggle",
    },
    config = function()
        require("qf_helper").setup({
            prefer_loclist = false,
        })
    end,
})

tools({
    "voldikss/vim-translator",
    lazy = true,
    init = function()
        vim.g.translator_source_lang = "jp"
    end,
    cmd = { "Translate", "TranslateW", "TranslateR", "TranslateH", "TranslateL" },
})

tools({
    "ttibsi/pre-commit.nvim",
    lazy = true,
    cmd = "Precommit",
})

tools({
    "lambdalisue/suda.vim",
    lazy = true,
    cmd = {
        "SudaRead",
        "SudaWrite",
        "SudoRead",
        "SudoWrite",
    },
    init = function()
        vim.g.suda_smart_edit = 1
        lambda.command("SudoWrite", function()
            vim.cmd([[SudaWrite]])
        end, {})
        lambda.command("SudoReadk", function()
            vim.cmd([[SudaRead]])
        end, {})
    end,
})

tools({
    "barklan/capslock.nvim",
    lazy = true,
    keys = "<leader><leader>;",
    config = function()
        require("capslock").setup()
        vim.keymap.set(
            { "i", "c", "n" },
            "<leader><leader>;",
            "<Plug>CapsLockToggle<Cr>",
            { noremap = true, desc = "Toggle CapsLock" }
        )
    end,
})

tools({
    "dstein64/vim-startuptime",
    lazy = true,
    cmd = "StartupTime",
    config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { "+let g:auto_session_enabled = 0" }
    end,
})

tools({
    "chrisgrieser/nvim-genghis",
    lazy = true,
    dependencies = { "stevearc/dressing.nvim" },
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
    config = function()
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
})

tools({
    "kevinhwang91/nvim-fundo",
    event = "BufReadPre",
    cond = lambda.config.tools.use_fundo, -- messes with some buffers which is really not that amazing | will have to see if there is a better fix for this
    cmd = { "FundoDisable", "FundoEnable" },
    dependencies = "kevinhwang91/promise-async",
    build = function()
        require("fundo").install()
    end,
    config = true,
})

tools({
    "AntonVanAssche/date-time-inserter.nvim",
    lazy = true,
    cmd = {
        "InsertDate",
        "InsertTime",
        "InsertDateTime",
    },
    config = true,
})

tools({
    "chomosuke/term-edit.nvim",
    lazy = true, -- or ft = 'toggleterm' if you use toggleterm.nvim
    event = "TermEnter",
    config = function()
        require("term-edit").setup({
            prompt_end = "[»#$] ",
            mapping = {
                n = { s = false, S = false },
            },
        })
    end,
})

tools({
    "m-demare/attempt.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local attempt = require("attempt")
        attempt.setup()
        require("telescope").load_extension("attempt")

        lambda.command("AttemptNew", function()
            attempt.new_select()
        end, {})
        lambda.command("AttemptRun", function()
            attempt.run()
        end, {})
        lambda.command("AttemptDelete", function()
            attempt.delete_buf()
        end, {})
        lambda.command("AttemptRename", function()
            attempt.rename_buf()
        end, {})
        lambda.command("AttemptNewExt", function()
            attempt.new_input_ext()
        end, {})
    end,
    cmd = {
        "AttemptNew",
        "AttemptRun",
        "AttemptDelete",
        "AttemptRename",
        "AttemptNewExt",
    },
})

tools({
    "smjonas/live-command.nvim",
    cond = lambda.config.tools.use_live_command,
    event = "VeryLazy",
    opts = {
        commands = {
            Norm = { cmd = "norm" },
            Glive = { cmd = "g" },
            Dlive = { cmd = "d" },
            Qlive = {
                cmd = "norm",
                -- This will transform ":5Qlive a" into ":norm 5@a"
                args = function(opts)
                    local reg = opts.fargs and opts.fargs[1] or "q"
                    local count = opts.fargs and opts.fargs[2] or (opts.count == -1 and "" or opts.count)
                    return count .. "@" .. reg
                end,
                range = "",
            },
        },
    },
    config = function(_, opts)
        require("live-command").setup(opts)
    end,
})
