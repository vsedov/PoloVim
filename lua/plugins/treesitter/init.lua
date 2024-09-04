local conf = require("modules.treesitter.config")
-- conf.nvim_treesitter()
-- conf.treesitter_init()
local rainbow_delimiters = require("rainbow-delimiters")
vim.g.rainbow_delimiters = {

    strategy = {
        [""] = rainbow_delimiters.strategy["global"],
    },
    query = {
        [""] = "rainbow-delimiters",
    },
}
