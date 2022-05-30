local tools = {}
local conf = require("modules.tools.config")
tools["simrat39/symbols-outline.nvim"] = {
    opt = true,
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    setup = conf.outline,
}

tools["andythigpen/nvim-coverage"] = {
    ft = { "python" },
    cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
    opt = true,
    config = conf.coverage,
}
tools["mgedmin/coverage-highlight.vim"] = {
    ft = "python",
    opt = true,
    run = ":UpdateRemotePlugins",
}

-- -- IPython Mappings
-- M.map("n", "p", "<cmd>lua require('py.ipython').toggleIPython()<CR>")
-- M.map("n", "c", "<cmd>lua require('py.ipython').sendObjectsToIPython()<CR>")
-- M.map("v", "c", '"zy:lua require("py.ipython").sendHighlightsToIPython()<CR>')
-- M.map("v", "s", '"zy:lua require("py.ipython").sendIPythonToBuffer()<CR>')

-- -- Pytest Mappings
-- M.map("n", "t", "<cmd>lua require('py.pytest').launchPytest()<CR>")
-- M.map("n", "r", "<cmd>lua require('py.pytest').showPytestResult()<CR>")

-- -- Poetry Mappings
-- M.map("n", "a", "<cmd>lua require('py.poetry').inputDependency()<CR>")
-- M.map("n", "d", "<cmd>lua require('py.poetry').showPackage()<CR>")
tools["~/GitHub/active_development/py.nvim"] = {
    ft = { "python" },
    opt = true,
    config = conf.python_dev,
}

tools["relastle/vim-nayvy"] = {

    config = function()
        vim.g.nayvy_import_config_path = "$HOME/.config/nayvy/nayvy.py"
    end,
}

tools["vim-test/vim-test"] = {
    opt = true,
}

tools["neovim/nvimdev.nvim"] = {
    ft = "lua",
    opt = true,
    config = conf.nvimdev,
}

tools["rcarriga/vim-ultest"] = {
    requires = { "vim-test/vim-test", opt = true, after = "vim-ultest" },
    run = ":UpdateRemotePlugins",
    opt = true,
}

tools["gennaro-tedesco/nvim-jqx"] = {
    ft = "json",
    cmd = { "JqxList", "JqxQuery" },
    opt = true,
}

tools["is0n/fm-nvim"] = {
    cmd = {
        "Neomutt",
        "Lazygit", -- 3 [ neogit + fugative + lazygit depends how i feel.]
        "Joshuto", -- 2
        "Broot",
        "Ranger",
        "Xplr", -- 1
        "Vifm",
        "Skim",
        "Nnn",
        "Fff",
        "Fzf",
        "Fzy",
        "Fm",
    },
    config = conf.fm,
}
tools["rktjmp/paperplanes.nvim"] = {
    cmd = { "PP" },
    opt = true,
    config = conf.paperplanes,
}

tools["ThePrimeagen/harpoon"] = {
    module = "harpoon",
    opt = true,
    config = conf.harpoon,
}

tools["natecraddock/workspaces.nvim"] = {
    module = "workspaces",
    config = conf.workspace,
}

tools["axieax/urlview.nvim"] = {
    cmd = { "UrlView", "UrlView packer" },
    config = conf.urlview,
    after = "telescope.nvim",
}

tools["jghauser/mkdir.nvim"] = {
    opt = true,
    cmd = "new",
    config = [[require'mkdir']],
}

-- tools["wellle/targets.vim"] = {}

tools["liuchengxu/vista.vim"] = { cmd = "Vista", setup = conf.vim_vista, opt = true }

------------- Spelling and Grammer
tools["kamykn/spelunker.vim"] = {
    opt = true,
    fn = { "spelunker#check" },
    setup = conf.spelunker,
    config = conf.spellcheck,
}

tools["lewis6991/spellsitter.nvim"] = {
    ft = { "norg", "markdown" },
    config = function()
        require("spellsitter").setup({
            filetypes = { "norg" },
            enable = true,
        })
    end,
}
tools["rhysd/vim-grammarous"] = {
    opt = true,
    cmd = { "GrammarousCheck" },
    ft = { "markdown", "txt", "norg", "tex" },
    setup = conf.grammarous,
}
-------------

tools["plasticboy/vim-markdown"] = {
    ft = "markdown",
    requires = { "godlygeek/tabular" },
    cmd = { "Toc" },
    setup = conf.markdown,
    opt = true,
}

tools["ekickx/clipboard-image.nvim"] = {
    ft = { "norg", "markdown" },
    cmd = { "PasteImg" },
    opt = true,
    config = conf.clipboardimage,
}

tools["iamcco/markdown-preview.nvim"] = {
    ft = { "markdown", "pandoc.markdown", "rmd" },
    cmd = { "MarkdownPreview" },
    setup = conf.mkdp,
    run = [[sh -c "cd app && yarn install"]],
    opt = true,
}

tools["turbio/bracey.vim"] = {
    ft = { "html", "javascript", "typescript" },
    cmd = { "Bracey", "BraceyEval" },
    run = 'sh -c "npm install --prefix server"',
    opt = true,
}

tools["akinsho/toggleterm.nvim"] = {
    cmd = { "FocusTerm", "TermTrace", "TermExec", "ToggleTerm" },
    keys = { "<c-t>", "<leader>gh", "<leader>tf", "<leader>tv", "<leader>tr" },
    config = function()
        require("modules.tools.toggleterm")
    end,
}

-- For this to record, cmd might not work
tools["wakatime/vim-wakatime"] = {
    event = "InsertEnter",
    cmd = {
        "WakaTimeApiKey",
        "WakaTimeDebugEnable",
        "WakaTimeDebugDisable",
        "WakaTimeScreenRedrawEnable",
        "WakaTimeScreenRedrawEnableAuto",
        "WakaTimeScreenRedrawDisable",
        "WakaTimeToday",
    },
}

-- ze black magic
tools["windwp/nvim-spectre"] = {
    module = "spectre",
    requires = { "nvim-lua/plenary.nvim" },
    keys = {
        ";w",
        ";W",
        ";v",
        ";c",
    },

    config = conf.spectre,
}

tools["ray-x/sad.nvim"] = {
    cmd = { "Sad" },
    requires = { "ray-x/guihua.lua", opt = true, after = "sad.nvim" },
    opt = true,
    config = conf.sad,
}

tools["ilAYAli/scMRU.nvim"] = {
    module = "mru",
}
-- need quick fix  :vimgrep /\w\+/j % | copen
tools["kevinhwang91/nvim-bqf"] = {
    opt = true,
    event = { "CmdlineEnter", "QuickfixCmdPre" },
    config = conf.bqf,
}

-- :Z {query}: cd to the highest ranked directory matching your query. If {query} is omitted, cd to the home directory
-- :Lz {query}: same as :Z, but local to the current window
-- :Tz {query}: same as :Z, but local to the current tab
-- :Zi {query}: cd to one of your highest ranking directories using fzf
-- :Lzi {query}: same as :Zi, but local to the current window
-- :Tzi {query}: same as :Zi, but local to the current tab

tools["nanotee/zoxide.vim"] = { cmd = { "Z", "Lz", "Zi", "Tz" } }

tools["tami5/sqlite.lua"] = {
    branch = "new/index_access",
    module = "sqlite",
}
-- manual call
tools["AckslD/nvim-neoclip.lua"] = {
    opt = true,
    requires = { "tami5/sqlite.lua" },
    config = conf.neoclip,
}

return tools
