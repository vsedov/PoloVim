local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    "nvim-neorg/neorg",
    lazy = true,
    ft = "norg",
    cmd = "Neorg",
    opts = require("modules.notes.neorg").opts,
    -- config = require("modules.notes.neorg").config
})

notes({
    "AckslD/nvim-FeMaco.lua",
    lazy = true,
    ft = { "norg", "markdown" },
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
    "lervag/vimtex",
    lazy = true,
    ft = { "latex", "tex" },
    config = conf.vimtex,
})

notes({
    "dhruvasagar/vim-table-mode",
    lazy = true,
    cmd = "TableModeToggle",
    ft = { "norg", "markdown" },
    conf = conf.table,
})
