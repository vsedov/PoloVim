local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    "nvim-neorg/neorg",
    -- lazy = true,
    -- ft = "norg",
    -- cmd = "Neorg",
    opts = require("modules.notes.neorg").opts,
})

notes({
    "AckslD/nvim-FeMaco.lua",
    lazy = true,
    ft = { "norg", "markdown", "tex" },
    cmd = "FeMaco",
    config = conf.femaco,
})

notes({
    "jubnzv/mdeval.nvim",
    lazy = true,
    ft = { "norg" },
    config = conf.mdeval,
})

notes({
    "dhruvasagar/vim-table-mode",
    lazy = true,
    cmd = "TableModeToggle",
    ft = { "norg", "markdown" },
    conf = conf.table,
})
