local conf = require("modules.telescope.config")
local tele = require("core.pack").package
tele({
    "nvim-telescope/telescope.nvim",
    branch = "master",
    module = "telescope",
    requires = {
        { "nvim-neorg/neorg-telescope", after = "telescope.nvim" },
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

tele({
    "jvgrootveld/telescope-zoxide",
    opt = true,
    config = function()
        require("telescope").load_extension("zoxide")
    end,
})

tele({
    "zane-/howdoi.nvim",
    cmd = "Howdoi",
    config = function()
        vim.api.nvim_create_user_command("Howdoi", function()
            require("utils.telescope").howdoi()
        end, { force = true })
    end,
})

tele({
    "dhruvmanila/telescope-bookmarks.nvim",
    opt = true,
    requires = {
        "kkharji/sqlite.lua",
    },
    config = conf.bookmark,
})
