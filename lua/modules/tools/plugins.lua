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
    keys = { "<c-t>", "<leader>gh", "<leader>tf", "<leader><Tab>" },
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
    "izo0x90/quickfix_actually.nvim",
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
    keys = "<leader><leader>;",
    config = function()
        require("capslock").setup()
        vim.keymap.set({ "i", "c", "n" }, "<leader><leader>;", "<Plug>CapsLockToggle<Cr>", { noremap = true })
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
    "willothy/flatten.nvim",
    cond = lambda.config.tools.use_flatten,
    priority = 1001,
    config = {
        window = { open = "alternate" },
        callbacks = {
            block_end = function()
                require("toggleterm").toggle()
            end,
            post_open = function(_, winnr, _, is_blocking)
                if is_blocking then
                    require("toggleterm").toggle()
                else
                    vim.api.nvim_set_current_win(winnr)
                end
            end,
        },
    },
})

-- The goal of nvim-fundo is to make Neovim's undo file become stable and useful.
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
    ft = { "toggleterm", "terminal" },
})

tools({
    "m-demare/attempt.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("attempt").setup()
        require("telescope").load_extension("attempt")
    end,
})

--  TODO: (vsedov) (03:44:50 - 31/05/23): I am not sure how ideal this is.
tools({
    "rebelot/terminal.nvim",
    cond = false,
})
