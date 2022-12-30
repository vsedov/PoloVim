local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    "nvim-neorg/neorg",
    config = conf.norg,
    event = "BufEnter",
})

notes({
    "AckslD/nvim-FeMaco.lua",
    lazy = true,
    ft = { "norg", "markdown" },
    config = conf.femaco,
    cmd = "FeMaco",
})

notes({
    "jubnzv/mdeval.nvim",
    ft = { "norg" },
    config = conf.mdeval,
})

notes({
    "lervag/vimtex",
    ft = { "latex", "tex" },
    after = "nvim-treesitter/nvim-treesitter",
    config = conf.vimtex,
})

notes({
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    lazy = true,
    ft = { "norg", "markdown" },
    conf = conf.table,
})
