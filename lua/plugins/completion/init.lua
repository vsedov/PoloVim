local conf = require("plugins.completion.config")

-- ----
conf.cmp()
conf.luasnip()
conf.snippet()
conf.neotab()
conf.autopair()
require("cmdline")({
    window = {
        matchFuzzy = true,
    },

    hl = {
        default = "Pmenu",
        selection = "PmenuSel",
        directory = "Directory",
        substr = "LineNr",
    },

    column = {
        maxNumber = 6,
        minWidth = 20,
    },

    binds = {
        next = "<Tab>",
        back = "<S-Tab>",
    },
})
