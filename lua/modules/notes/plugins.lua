local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    -- "nvim-neorg/neorg",
    "tamton-aquib/neorg",
    branch = "code-execution",
    --[[ branch = "main", ]]
    tags = "*",
    run = ":Neorg sync-parsers",
    requires = {
        { "max397574/neorg-contexts", ft = "norg" },
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-treesitter",
    },
    after = { "telescope.nvim" },
    config = conf.norg,
})

notes({
    "hisbaan/jot.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = { "Jot" },
    config = conf.jot,
})

notes({
    "AckslD/nvim-FeMaco.lua",
    opt = true,
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
    opt = true,
    ft = { "latex", "tex" },
    setup = conf.vimtex,
})

notes({
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    opt = true,
    ft = { "norg", "markdown" },
    conf = conf.table,
})

notes({
    "edluffy/hologram.nvim",
    ft = "norg",
    config = conf.hologram,
})
