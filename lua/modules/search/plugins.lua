local conf = require("modules.search.config")
local search = require("core.pack").package
search({
    "nvim-telescope/telescope.nvim",
    branch = "master",
    module = "telescope",
    requires = {
        { "vhyrro/neorg-telescope", after = "telescope.nvim" },
        { "nvim-lua/plenary.nvim", opt = true },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            opt = true,
            config = function()
                require("telescope").load_extension("file_browser")
            end,
        },
        {
            "nvim-telescope/telescope-frecency.nvim",
            opt = true,
            config = function()
                require("telescope").load_extension("frecency")
            end,
        },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            opt = true,
            config = function()
                require("telescope").load_extension("live-grep-args")
            end,
        },
    },
    config = conf.telescope,
})

search({
    "jvgrootveld/telescope-zoxide",
    opt = true,
    config = function()
        require("telescope").load_extension("zoxide")
    end,
})

search({
    "zane-/howdoi.nvim",
    cmd = "Howdoi",
    config = function()
        vim.api.nvim_create_user_command("Howdoi", function()
            require("utils.telescope").howdoi()
        end, { force = true })
    end,
})

search({
    "dhruvmanila/telescope-bookmarks.nvim",
    opt = true,
    requires = {
        "kkharji/sqlite.lua",
    },
})

-- NOTE: (vsedov) (23:27:10 - 16/09/22): Azy seems to be very fast
-- So please refer to the hydra config for this. /lua/modules/editor/hydra/azy
search({
    "vigoux/azy.nvim",
    run = "make lib",
    commit = "b3e6577318ec496f22204ee9eed32656c6c3156a",
    module = "azy",
    config = function()
        require("azy").setup({
            preview = true, -- Whether to preview selected items on the fly (this is an unstable feature, feedback appreciated)
        })
    end,
})

search({ "ibhagwan/fzf-lua", branch = "main", config = conf.fzf, opt = true, cmd = { "FzfLua" } })

search({
    "wincent/command-t",
    run = "cd lua/wincent/commandt/lib && make",
    opt = true,
    setup = function()
        vim.g.CommandTPreferredImplementation = "lua"
    end,
    config = function()
        require("wincent.commandt").setup()
    end,
})

-- :Z {query}: cd to the highest ranked directory matching your query. If {query} is omitted, cd to the home directory
-- :Lz {query}: same as :Z, but local to the current window
-- :Tz {query}: same as :Z, but local to the current tab
-- :Zi {query}: cd to one of your highest ranking directories using fzf
-- :Lzi {query}: same as :Zi, but local to the current window
-- :Tzi {query}: same as :Zi, but local to the current tab

search({ "nanotee/zoxide.vim", cmd = { "Z", "Lz", "Zi", "Tz", "Tzi", "Lzi" } })

-- ze black magic
search({
    "windwp/nvim-spectre",
    module = "spectre",
    requires = { "nvim-lua/plenary.nvim" },
    keys = {
        ";e",
        ";W",
        ";v",
        ";c",
    },
    config = conf.spectre,
})

search({
    "ray-x/sad.nvim",
    cmd = { "Sad" },
    requires = {
        "ray-x/guihua.lua",
        opt = true,
        config = function()
            require("guihua.maps").setup({
                maps = {
                    close_view = "<C-x>",
                },
            })
        end,
    },
    opt = true,
    config = conf.sad,
})
