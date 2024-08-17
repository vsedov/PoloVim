local conf = require("modules.treesitter.config")
conf.treesitter_init()
conf.nvim_treesitter()
local rainbow_delimiters = require("rainbow-delimiters")

vim.g.rainbow_delimiters = {

    strategy = {
        [""] = rainbow_delimiters.strategy["global"],
    },
    query = {
        [""] = "rainbow-delimiters",
    },
}
