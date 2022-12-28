local conf = require("modules.search.config")
local search = require("core.pack").package
search({
    "nvim-telescope/telescope.nvim",
    branch = "master",
    module = "telescope",
    dependencies = {
        { "vhyrro/neorg-telescope", after = "telescope.nvim" },
        { "nvim-lua/plenary.nvim", lazy = true },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            lazy = true,
        },
        {
            "nvim-telescope/telescope-frecency.nvim",
            lazy = true,
        },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            lazy = true,
        },
    },
    config = conf.telescope,
})

search({
    "axkirillov/easypick.nvim",
    after = "telescope.nvim",
    config = conf.easypick,
})
search({
    "jvgrootveld/telescope-zoxide",
    lazy = true,
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
    lazy = true,
    dependencies = {
        "kkharji/sqlite.lua",
    },
})

-- search({
--     "https://git.sr.ht/~vigoux/azy.nvim",
--     run = "make lib",
--     module = "azy",
--     config = function()
--         require("azy").setup({
--             preview = true, -- Whether to preview selected items on the fly (this is an unstable feature, feedback appreciated)
--         })
--     end,
-- })

search({ "ibhagwan/fzf-lua", branch = "main", config = conf.fzf, lazy = true, cmd = { "FzfLua" } })

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
    dependencies = { "nvim-lua/plenary.nvim" },
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
    dependencies = {
        "ray-x/guihua.lua",
        lazy = true,
        config = function()
            require("guihua.maps").setup({
                maps = {
                    close_view = "<C-x>",
                },
            })
        end,
    },
    lazy = true,
    config = conf.sad,
})

search({
    "cshuaimin/ssr.nvim",
    module = "ssr",
    -- Calling setup is optional.
    config = function()
        require("ssr").setup({
            min_width = 50,
            min_height = 5,
            keymaps = {
                close = "q",
                next_match = "n",
                prev_match = "N",
                replace_all = "<leader><cr>",
            },
        })
    end,
})
