local conf = require("modules.tools.config")
local tools = require("core.pack").package

tools({
    "neovim/nvimdev.nvim",
    lazy = true,
    ft = "lua",
    config = conf.nvimdev,
})

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

tools({ "rktjmp/paperplanes.nvim", lazy = true, cmd = { "PP" }, config = true })

tools({
    "natecraddock/workspaces.nvim",
    lazy = true,
    cmd = {
        "WorkspacesAdd",
        "WorkspacesRemove",
        "WorkspacesRename",
        "WorkspacesList",
        "WorkspacesOpen",
    },
    config = conf.workspace,
})

tools({
    "xiyaowong/link-visitor.nvim",
    lazy = true,
    cmd = { "VisitLinkInBuffer", "VisitLinkUnderCursor", "VisitLinkNearCursor" },
    config = function()
        require("link-visitor").setup({
            silent = true, -- disable all prints, `false` by default
        })
    end,
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
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    cmd = { "Toc" },
    init = conf.markdown,
})

tools({
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = { "markdown", "pandoc.markdown", "rmd" },
    cmd = { "MarkdownPreview" },
    init = conf.mkdp,
    build = [[sh -c "cd app && yarn install"]],
})

tools({
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = { "FocusTerm", "TermTrace", "TermExec", "ToggleTerm", "Htop", "GDash" },
    keys = { "<c-t>", "<leader>gh", "<leader>tf", "<leader>tv", "<leader>tr", "<leader><Tab>" },
    config = function()
        require("modules.tools.toggleterm")
    end,
})

tools({
    "wakatime/vim-wakatime",
    lazy = true,
})

tools({ "ilAYAli/scMRU.nvim", lazy = true, cmd = { "MruRepos", "Mru", "Mfu", "MruAdd", "MruDel" } })

tools({
    "kevinhwang91/nvim-bqf",
    lazy = true,
    ft = "qf",
    config = conf.bqf,
})

tools({
    "barklan/nvim-pqf",
    lazy = true,
    ft = "qf",
    config = true,
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
    },
    init = function()
        vim.g.suda_smart_edit = 1
    end,
})

tools({
    "barklan/capslock.nvim",
    lazy = true,
    keys = "<leader><leader><leader>",
    config = function()
        require("capslock").setup()
        vim.keymap.set({ "i", "c", "n" }, "<leader><leader><leader>", "<Plug>CapsLockToggle<Cr>", { noremap = true })
    end,
})

tools({
    "jbyuki/nabla.nvim",
    lazy = true,
    keys = { "<localleader>s" },
    config = function()
        vim.keymap.set("n", "<localleader>s", [[:lua require("nabla").popup()<CR>]], {})
        require("nabla").enable_virt()
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
    "inkarkat/vim-visualrepeat",
    event = "ModeChanged",
})

tools({
    "tyru/open-browser.vim",
    lazy = true,
    keys = { { "gx", "<Plug>(openbrowser-smart-search)", mode = { "n", "v" } } },
})

tools({
    "tyru/capture.vim",
    lazy = true,
    cmd = "Capture",
})

tools({
    "thinca/vim-qfreplace",
    lazy = true,
    cmd = "Qfreplace",
})

tools({
    "itchyny/vim-qfedit",
    lazy = true,
    ft = "qf",
})

tools({
    "samjwill/nvim-unception",
    lazy = true,
    event = "CmdLineEnter",
    config = function()
        vim.g.unception_delete_replaced_buffer = true
        vim.g.unception_enable_flavor_text = false
    end,
})

tools({
    "Apeiros-46B/qalc.nvim",
    config = true,
    cmd = { "Qalc", "QalcAttach" },
})

-- The goal of nvim-fundo is to make Neovim's undo file become stable and useful.
tools({
    "kevinhwang91/nvim-fundo",
    event = "BufReadPre",
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
    "wincent/terminus",
    cond = vim.fn.getenv("TMUX") ~= vim.NIL,
    event = "VeryLazy",
})

tools({
    "aserowy/tmux.nvim",
    lazy = true,
    cond = vim.fn.getenv("TMUX") ~= vim.NIL,
    event = "BufWinEnter",
    config = function()
        require("tmux").setup({
            copy_sync = { enable = false },
            navigation = {
                cycle_navigation = false,
                enable_default_keybindings = false,
                persist_zoom = false,
            },
        })

        keymaps = {
            Up = function()
                require("tmux").resize_top()
            end,
            Left = function()
                require("tmux").resize_left()
            end,
            Right = function()
                require("tmux").resize_right()
            end,
            Down = function()
                require("tmux").resize_down()
            end,
        }
        for k, v in pairs(keymaps) do
            vim.keymap.set("n", "<A-" .. k .. ">", v, { noremap = true, silent = true })
        end
    end,
})

tools({
    "numToStr/Navigator.nvim",
    cond = vim.fn.getenv("TMUX") ~= vim.NIL,
    event = "VeryLazy",
    config = function()
        require("Navigator").setup({
            auto_save = "all",
        })
        for k, value in pairs({ Left = "h", Down = "j", Up = "k", Right = "l", Previous = "=" }) do
            vim.keymap.set({ "n", "t" }, "<c-" .. value .. ">", function()
                vim.cmd("Navigator" .. k)
            end, { noremap = true, silent = true })
        end
    end,
})

tools({
    "chomosuke/term-edit.nvim",
    lazy = true, -- or ft = 'toggleterm' if you use toggleterm.nvim
    ft = { "toggleterm", "terminal" },
})

-- Disable this for now, as i believe there are better things to do,. than use this
tools({
    "romainchapou/nostalgic-term.nvim",
    lazy = true,
    cond = (not vim.fn.getenv("TMUX") ~= vim.NIL and false),
    event = "TermOpen",
    config = function()
        require("nostalgic-term").setup({
            mappings = {
                { "<c-h>", "h" },
                { "<c-j>", "j" },
                { "<c-k>", "k" },
                { "<c-l>", "l" },
            },
            add_normal_mode_mappings = false,
        })
    end,
})
