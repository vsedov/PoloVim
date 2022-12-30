local conf = require("modules.tools.config")
local tools = require("core.pack").package

tools({ "neovim/nvimdev.nvim", ft = "lua", lazy = true, config = conf.nvimdev })

tools({ "gennaro-tedesco/nvim-jqx", ft = "json", cmd = { "JqxList", "JqxQuery" }, lazy = true })

tools({
    "is0n/fm-nvim",
    cmd = {
        "Lazygit", -- 3 [ neogit + fugative + lazygit depends how i feel.]
        "Joshuto", -- 2
        "Broot",
        "Ranger",
        "Xplr", -- Nice but, i think ranger tops this one for the.time
        "Lf",
        "Vifm",
        "Skim",
        "Nnn",
        "Fff",
        "Fzf",
        "Fzy",
        "Fm",
    },
    config = conf.fm,
})
tools({ "rktjmp/paperplanes.nvim", cmd = { "PP" }, lazy = true, config = true })

tools({
    "natecraddock/workspaces.nvim",
    lazy = true,
    config = conf.workspace,
})

tools({
    "xiyaowong/link-visitor.nvim",
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
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    cmd = { "Toc" },
    init = conf.markdown,
    lazy = true,
})

tools({
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "pandoc.markdown", "rmd" },
    cmd = { "MarkdownPreview" },
    init = conf.mkdp,
    build = [[sh -c "cd app && yarn install"]],
    lazy = true,
})

tools({
    "akinsho/toggleterm.nvim",
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

tools({ "ilAYAli/scMRU.nvim", cmd = { "MruRepos", "Mru", "Mfu", "MruAdd", "MruDel" }, module = "mru" })

-- need quick fix  :vimgrep /\w\+/j % | copen
tools({
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = conf.bqf,
})
tools({
    "barklan/nvim-pqf",
    event = "BufReadPre",
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
    cmd = "Precommit",
    lazy = true,
})

tools({
    "lambdalisue/suda.vim",
    cmd = {
        "SudaRead",
        "SudaWrite",
    },
    lazy = true,
    init = function()
        vim.g.suda_smart_edit = 1
    end,
})

tools({
    "barklan/capslock.nvim",
    keys = {
        { "<C-;>" },
    },
    lazy = true,
    config = function()
        require("capslock").setup()
        vim.keymap.set({ "n", "i", "c" }, "<C-;>", "<Plug>CapsLockToggle", {})
    end,
})

tools({
    "jbyuki/nabla.nvim",
    keys = { "<localleader>s" },
    config = function()
        vim.keymap.set("n", "<localleader>s", [[:lua require("nabla").popup()<CR>]], {})
        require("nabla").enable_virt()
    end,
})

tools({
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { "+let g:auto_session_enabled = 0" }
    end,
})

tools({
    "stevearc/three.nvim",
    modules = "three",
    config = function()
        require("three").setup({
            bufferline = {
                enabled = true,
                icon = {
                    -- Tab left/right dividers
                    -- Set to this value for fancier, more "tab-looking" tabs
                    -- dividers = { " ", " " },
                    dividers = { "▍", "" },
                    -- Scroll indicator icons when buffers exceed screen width
                    scroll = { "«", "»" },
                    -- Pinned buffer icon
                    pin = "車",
                },
                -- When true, only show buffers that are inside the current directory
                -- This can be toggled on a per-tab basis with toggle_scope_by_dir()
                scope_by_directory = true,
            },
            windows = {
                enabled = false,
                -- Constant or function to calculate the minimum window width of the focused window
                winwidth = function(winid)
                    local bufnr = vim.api.nvim_win_get_buf(winid)
                    return math.max(vim.api.nvim_buf_get_option(bufnr, "textwidth"), 80)
                end,
                -- Constant or function to calculate the minimum window height of the focused window
                winheight = 10,
            },
            projects = {
                enabled = true,
                -- Name of file to store the project directory cache
                filename = "projects.json",
                -- When true, automatically add directories entered as projects
                -- If false, you will need to manually call add_project()
                autoadd = true,
                -- List of lua patterns. If any match the directory, it will be allowed as a project
                allowlist = {},
                -- List of lua patterns. If any match the directory, it will be ignored as a project
                blocklist = {},
                -- Return true to allow a directory as a project
                filter_dir = function(dir)
                    return true
                end,
            },
        })
    end,
})
tools({
    "chrisgrieser/nvim-genghis",
    dependencies = { "stevearc/dressing.nvim" },
    lazy = true,
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