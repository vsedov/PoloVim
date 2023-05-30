local conf = require("modules.search.config")
local search = require("core.pack").package
search({
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            lazy = true,
        },
        {
            "nvim-telescope/telescope-frecency.nvim",
            lazy = true,
            config = function() end,
        },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            lazy = true,
        },
        {
            "tsakirist/telescope-lazy.nvim",
            lazy = true,
            config = function()
                require("telescope").setup({
                    extensions = {
                        lazy = {
                            -- Optional theme (the extension doesn't set a default theme)
                            theme = "ivy",
                            -- Whether or not to show the icon in the first column
                            show_icon = true,
                            -- Mappings for the actions
                            mappings = {
                                open_in_browser = "<C-o>",
                                open_in_file_browser = "<M-b>",
                                open_in_find_files = "<C-f>",
                                open_in_live_grep = "<C-g>",
                                open_plugins_picker = "<C-b>", -- Works only after having called first another action
                                open_lazy_root_find_files = "<C-r>f",
                                open_lazy_root_live_grep = "<C-r>g",
                            },
                            -- Other telescope configuration options
                        },
                    },
                })

                require("telescope").load_extension("lazy")
            end,
        },
    },
    config = conf.telescope,
})

search({
    "axkirillov/easypick.nvim",
    lazy = true,
    cmd = "Easypick",
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
    lazy = true,
    cmd = "Howdoi",
    config = function()
        vim.api.nvim_create_user_command("Howdoi", function()
            require("utils.telescope").howdoi()
        end, { force = true })
    end,
})

search({
    "danielfalk/smart-open.nvim",
    lazy = true,
    config = function()
        require("telescope").load_extension("smart_open")
    end,
    dependencies = { "kkharji/sqlite.lua" },
})

search({
    "dhruvmanila/telescope-bookmarks.nvim",
    lazy = true,
    dependencies = {
        "kkharji/sqlite.lua",
    },
})

-- :Z {query}: cd to the highest ranked directory matching your query. If {query} is omitted, cd to the home directory
-- :Lz {query}: same as :Z, but local to the current window
-- :Tz {query}: same as :Z, but local to the current tab
-- :Zi {query}: cd to one of your highest ranking directories using fzf
-- :Lzi {query}: same as :Zi, but local to the current window
-- :Tzi {query}: same as :Zi, but local to the current tab

search({ "nanotee/zoxide.vim", lazy = true, cmd = { "Z", "Lz", "Zi", "Tz", "Tzi", "Lzi" } })

-- ze black magic
search({
    "windwp/nvim-spectre",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = conf.spectre,
})

search({
    "ray-x/sad.nvim",
    lazy = true,
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
    config = conf.sad,
})

search({
    "cshuaimin/ssr.nvim",
    lazy = true,
    config = function()
        require("ssr").setup({
            min_width = 50,
            min_height = 5,
            keymaps = {
                close = "q",
                next_match = "n",
                prev_match = "N",
                replace_all = "<cr>",
            },
        })
    end,
})

search({
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    build = "bash ./install --bin",
    config = conf.fzf,
})

search({
    "AckslD/muren.nvim",
    lazy = true,
    cmd = {
        "MurenToggle",
        "MurenOpen",
        "MurenClose",
        "MurenFresh",
        "MurenUnique",
    },

    config = true,
})
