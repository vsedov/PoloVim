local conf = require("modules.telescope.config")
local telescope = require("core.pack").package
telescope({
    "nvim-telescope/telescope.nvim",
    module = { "telescope", "utils.telescope" },
    config = conf.telescope,
    requires = {
        { "nvim-neorg/neorg-telescope", opt = true },
        { "nvim-lua/plenary.nvim", opt = true },
        { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make", opt = true },
        { "nvim-telescope/telescope-live-grep-raw.nvim", opt = true },
        { "nvim-telescope/telescope-file-browser.nvim", opt = true },
    },
    opt = true,
})
-- config this better https://github.com/jvgrootveld/telescope-zoxide
telescope({
    "jvgrootveld/telescope-zoxide",
    module = "telescope",
    config = function()
        require("telescope").load_extension("zoxide")
    end,
})

telescope({
    "zane-/howdoi.nvim",
    cmd = "Howdoi",
    config = function()
        vim.api.nvim_create_user_command("Howdoi", function()
            require("utils.telescope").howdoi()
        end, { force = true })
    end,
})

