local telescope = {}
local conf = require("modules.telescope.config")

telescope["nvim-telescope/telescope.nvim"] = {
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
}
-- config this better https://github.com/jvgrootveld/telescope-zoxide
telescope["jvgrootveld/telescope-zoxide"] = {
    opt = true,
    after = { "telescope.nvim" },
    config = function()
        require("utils.telescope")
        require("telescope").load_extension("zoxide")
    end,
}
return telescope
