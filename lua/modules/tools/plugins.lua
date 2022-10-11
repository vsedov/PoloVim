local conf = require("modules.tools.config")
local tools = require("core.pack").package

tools({
    "relastle/vim-nayvy",
    ft = { "python" },
    opt = true,
    config = function()
        vim.g.nayvy_import_path_format = "all_relative"
        vim.g.nayvy_import_config_path = "$HOME/.config/nayvy/nayvy.py"
    end,
})

tools({ "neovim/nvimdev.nvim", ft = "lua", opt = true, config = conf.nvimdev })

tools({ "gennaro-tedesco/nvim-jqx", ft = "json", cmd = { "JqxList", "JqxQuery" }, opt = true })

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
tools({ "rktjmp/paperplanes.nvim", cmd = { "PP" }, opt = true, config = conf.paperplanes })

tools({ "ThePrimeagen/harpoon", module = "harpoon", opt = true, config = conf.harpoon })

tools({
    "natecraddock/workspaces.nvim",
    after = "telescope.nvim",
    config = conf.workspace,
})

tools({ "jghauser/mkdir.nvim", opt = true, cmd = "new", config = [[require'mkdir']] })

tools({
    "xiyaowong/link-visitor.nvim",
    cmd = { "VisitLinkInBuffer", "VisitLinkUnderCursor", "VisitLinkNearCursor" },
    config = function()
        require("link-visitor").setup({
            silent = true, -- disable all prints, `false` by default
        })
    end,
})

------------- Spelling and Grammer
tools({
    "kamykn/spelunker.vim",
    opt = true,
    fn = { "spelunker#check" },
    setup = conf.spelunker,
    config = conf.spellcheck,
})

tools({
    "rhysd/vim-grammarous",
    opt = true,
    cmd = { "GrammarousCheck" },
    ft = { "markdown", "txt", "norg", "tex" },
    setup = conf.grammarous,
})
-------------

tools({
    "plasticboy/vim-markdown",
    ft = "markdown",
    requires = { "godlygeek/tabular" },
    cmd = { "Toc" },
    setup = conf.markdown,
    opt = true,
})

tools({
    "ekickx/clipboard-image.nvim",
    ft = { "norg", "markdown" },
    cmd = { "PasteImg" },
    opt = true,
    config = conf.clipboardimage,
})

tools({
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "pandoc.markdown", "rmd" },
    cmd = { "MarkdownPreview" },
    setup = conf.mkdp,
    run = [[sh -c "cd app && yarn install"]],
    opt = true,
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
    opt = true,
    setup = conf.wakatime,
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
    config = function()
        require("pqf").setup()
    end,
})

tools({ "tami5/sqlite.lua", module = "sqlite" })
-- manual call
tools({
    "AckslD/nvim-neoclip.lua",
    opt = true,
    requires = { "tami5/sqlite.lua" },
    config = conf.neoclip,
})

tools({
    "voldikss/vim-translator",
    opt = true,
    setup = function()
        vim.g.translator_source_lang = "jp"
    end,
    cmd = { "Translate", "TranslateW", "TranslateR", "TranslateH", "TranslateL" },
})

tools({
    "rmagatti/alternate-toggler",
    opt = true,
    cmd = "ToggleAlternate",
})

tools({
    "ttibsi/pre-commit.nvim",
    cmd = "Precommit",
    opt = true,
})

tools({
    "lambdalisue/suda.vim",
    cmd = {
        "SudaRead",
        "SudaWrite",
    },
    setup = function()
        vim.g.suda_smart_edit = 1
    end,
})
-- Default:~
--     normal = {
--       ["<cr>"] = "open_data",
--       ["<s-cr>"] = "open_data_index",
--       ["<tab>"] = "toggle_node",
--       ["<s-tab>"] = "toggle_node",
--       ["/"] = "select_path",
--       ["$"] = "change_icon_menu",
--       c = "add_inside_end_index",
--       I = "add_inside_start",
--       i = "add_inside_end",
--       l = "copy_node_link",
--       L = "copy_node_link_index",
--       d = "delete",
--       O = "add_above",
--       o = "add_below",
--       q = "quit",
--       r = "rename",
--       R = "change_icon",
--       u = "make_url",
--       x = "select",
--     }

--     selection = {
--       ["<cr>"] = "open_data",
--       ["<s-tab>"] = "toggle_node",
--       ["/"] = "select_path",
--       I = "move_inside_start",
--       i = "move_inside_end",
--       O = "move_above",
--       o = "move_below",
--       q = "quit",
--       x = "select",
--     }

tools({
    "phaazon/mind.nvim",
    cmd = { "MindOpenMain", "MindOpenProject", "MindReloadState" },
    config = function()
        require("mind").setup()
    end,
})

tools({
    lambda.use_local("pomodoro.nvim", "personal"),
    cmd = {
        "PomodoroStartFocus",
        "PomodoroStartBreak",
        "PomodoroStartLongBreak",
        "PomodoroPause",
        "PomodoroResume",
        "PomodoroTogglePopup",
    },
})

-- tools({
--     "mong8se/actually.nvim",
--     wants = "dressing.nvim",
--     setup = function()
--     tb = {
--         events = "VimEnter",
--         augroup_name  = "actually",
--         condition =  lambda.config.use_actually,
--         plugin = "actually.nvim"
--     }
--         lambda.lazy_load(tb)
--     end,
-- })

tools({
    "barklan/capslock.nvim",
    keys = {
        { "i", "<C-;>" },
        { "n", "<C-;>" },
        { "c", "<C-;>" },
    },
    config = function()
        require("capslock").setup()
        vim.keymap.set({ "n", "i", "C" }, "<C-;>", "<Plug>CapsLockToggle", {})
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
