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
    module = "workspaces",
    setup = function()
        require("telescope").load_extension("workspaces")
    end,
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
    "lewis6991/spellsitter.nvim",
    ft = { "norg", "markdown", "tex" },
    config = function()
        require("spellsitter").setup({
            filetypes = { "norg" },
            enable = true,
        })
    end,
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
    cmd = { "FocusTerm", "TermTrace", "TermExec", "ToggleTerm", "Htop" },
    keys = { "<c-t>", "<leader>gh", "<leader>tf", "<leader>tv", "<leader>tr", "<leader>ld", "<leader><Tab>" },
    config = function()
        require("modules.tools.toggleterm")
    end,
})

tools({
    "wakatime/vim-wakatime",
    opt = true,
    setup = conf.wakatime,
})

-- ze black magic
tools({
    "windwp/nvim-spectre",
    module = "spectre",
    requires = { "nvim-lua/plenary.nvim" },
    keys = {
        ";w",
        ";W",
        ";v",
        ";c",
    },
    config = conf.spectre,
})

tools({
    "ray-x/sad.nvim",
    cmd = { "Sad" },
    requires = { "ray-x/guihua.lua", opt = true, after = "sad.nvim" },
    opt = true,
    config = conf.sad,
})

tools({ "ilAYAli/scMRU.nvim", cmd = { "MruRepos", "Mru", "Mfu", "MruAdd", "MruDel" }, module = "mru" })

-- need quick fix  :vimgrep /\w\+/j % | copen
tools({
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = conf.bqf,
})
tools({
    "https://gitlab.com/yorickpeterse/nvim-pqf",
    event = "BufReadPre",
    config = function()
        require("pqf").setup()
    end,
})

-- :Z {query}: cd to the highest ranked directory matching your query. If {query} is omitted, cd to the home directory
-- :Lz {query}: same as :Z, but local to the current window
-- :Tz {query}: same as :Z, but local to the current tab
-- :Zi {query}: cd to one of your highest ranking directories using fzf
-- :Lzi {query}: same as :Zi, but local to the current window
-- :Tzi {query}: same as :Zi, but local to the current tab

tools({ "nanotee/zoxide.vim", cmd = { "Z", "Lz", "Zi", "Tz", "Tzi", "Lzi" } })

tools({ "tami5/sqlite.lua", branch = "new/index_access", module = "sqlite" })
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

tools({
    "NTBBloodbath/rest.nvim",
    opt = true,
    ft = { "http" },
    -- keys = { "<Plug>RestNvim", "<Plug>RestNvimPreview", "<Plug>RestNvimLast" },
    config = conf.rest,
})

tools({ "ibhagwan/fzf-lua", branch = "main", config = conf.fzf, opt = true, cmd = { "FzfLua" } })
