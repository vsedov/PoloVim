local tools = {}
local conf = require("modules.tools.config")
local package = require("core.pack").package

package({
    "simrat39/symbols-outline.nvim",
    opt = true,
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    setup = conf.outline,
})

package({
    "relastle/vim-nayvy",
    ft = { "python" },
    opt = true,
    config = function()
        vim.g.nayvy_import_config_path = "$HOME/.config/nayvy/nayvy.py"
    end,
})

package({ "neovim/nvimdev.nvim", ft = "lua", opt = true, config = conf.nvimdev })

package({ "gennaro-tedesco/nvim-jqx", ft = "json", cmd = { "JqxList", "JqxQuery" }, opt = true })

package({
    "is0n/fm-nvim",
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
})
package({ "rktjmp/paperplanes.nvim", cmd = { "PP" }, opt = true, config = conf.paperplanes })

package({ "ThePrimeagen/harpoon", module = "harpoon", opt = true, config = conf.harpoon })

package({ "natecraddock/workspaces.nvim", module = "workspaces", config = conf.workspace })

package({
    "axieax/urlview.nvim",
    cmd = { "UrlView", "UrlView packer" },
    config = conf.urlview,
    after = "telescope.nvim",
})

package({ "jghauser/mkdir.nvim", opt = true, cmd = "new", config = [[require'mkdir']] })

-- package{"wellle/targets.vim", }

package({ "liuchengxu/vista.vim", cmd = "Vista", setup = conf.vim_vista, opt = true })

------------- Spelling and Grammer
package({
    "kamykn/spelunker.vim",
    opt = true,
    fn = { "spelunker#check" },
    setup = conf.spelunker,
    config = conf.spellcheck,
})

package({
    "lewis6991/spellsitter.nvim",
    ft = { "norg", "markdown" },
    config = function()
        require("spellsitter").setup({
            filetypes = { "norg" },
            enable = true,
        })
    end,
})
package({
    "rhysd/vim-grammarous",
    opt = true,
    cmd = { "GrammarousCheck" },
    ft = { "markdown", "txt", "norg", "tex" },
    setup = conf.grammarous,
})
-------------

package({
    "plasticboy/vim-markdown",
    ft = "markdown",
    requires = { "godlygeek/tabular" },
    cmd = { "Toc" },
    setup = conf.markdown,
    opt = true,
})

package({
    "ekickx/clipboard-image.nvim",
    ft = { "norg", "markdown" },
    cmd = { "PasteImg" },
    opt = true,
    config = conf.clipboardimage,
})

package({
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "pandoc.markdown", "rmd" },
    cmd = { "MarkdownPreview" },
    setup = conf.mkdp,
    run = [[sh -c "cd app && yarn install"]],
    opt = true,
})

package({
    "turbio/bracey.vim",
    ft = { "html", "javascript", "typescript" },
    cmd = { "Bracey", "BraceyEval" },
    run = 'sh -c "npm install --prefix server"',
    opt = true,
})

package({
    "akinsho/toggleterm.nvim",
    cmd = { "FocusTerm", "TermTrace", "TermExec", "ToggleTerm", "Htop" },
    keys = { "<c-t>", "<leader>gh", "<leader>tf", "<leader>tv", "<leader>tr", "<leader>ld" },
    config = function()
        require("modules.tools.toggleterm")
    end,
})

-- For this to record, cmd might not work
package({
    "wakatime/vim-wakatime",
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
})

-- ze black magic
package({
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

package({
    "ray-x/sad.nvim",
    cmd = { "Sad" },
    requires = { "ray-x/guihua.lua", opt = true, after = "sad.nvim" },
    opt = true,
    config = conf.sad,
})

package({ "ilAYAli/scMRU.nvim", module = "mru" })
-- need quick fix  :vimgrep /\w\+/j % | copen
package({
    "kevinhwang91/nvim-bqf",
    opt = true,
    event = { "CmdlineEnter", "QuickfixCmdPre" },
    config = conf.bqf,
})

-- :Z {query}: cd to the highest ranked directory matching your query. If {query} is omitted, cd to the home directory
-- :Lz {query}: same as :Z, but local to the current window
-- :Tz {query}: same as :Z, but local to the current tab
-- :Zi {query}: cd to one of your highest ranking directories using fzf
-- :Lzi {query}: same as :Zi, but local to the current window
-- :Tzi {query}: same as :Zi, but local to the current tab

package({ "nanotee/zoxide.vim", cmd = { "Z", "Lz", "Zi", "Tz" } })

package({ "tami5/sqlite.lua", branch = "new/index_access", module = "sqlite" })
-- manual call
package({
    "AckslD/nvim-neoclip.lua",
    opt = true,
    requires = { "tami5/sqlite.lua" },
    config = conf.neoclip,
})
-- return tools
