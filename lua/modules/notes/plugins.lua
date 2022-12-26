local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    "nvim-neorg/neorg",
    -- "tamton-aquib/neorg",
    -- branch = "code-execution",
    --[[ branch = "main", ]]
    tags = "*",
    run = ":Neorg sync-parsers",
    dependencies = {
        { "max397574/neorg-contexts", ft = "norg" },
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-treesitter",
    },

    config = conf.norg,
})

-- --  REVISIT: (vsedov) (02:26:26 - 10/11/22): Required?
notes({
    "hisbaan/jot.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = { "Jot" },
    config = conf.jot,
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
    lazy = true,
    ft = { "latex", "tex" },
    init = conf.vimtex,
})

notes({
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    lazy = true,
    ft = { "norg", "markdown" },
    conf = conf.table,
})

notes({
    "edluffy/hologram.nvim",
    lazy = true,
    -- Disable this fo rth etime , there could be some breaking changes
    -- that i dont really know how to deal with
    config = conf.hologram,
})


-- -- notes({
-- --     "jghauser/papis.nvim",
-- --     -- after = { "telescope.nvim", "nvim-cmp" },
-- --     ft = { "latex", "tex", "norg" },
-- --     dependencies = {
-- --         "kkharji/sqlite.lua",
-- --         "nvim-lua/plenary.nvim",
-- --         "MunifTanjim/nui.nvim",
-- --         "nvim-treesitter/nvim-treesitter",
-- --     },
-- --     rocks = { "lyaml" },
-- --     config = function()
-- --         require("papis").init({
-- --             papis_python = {
-- --                 dir = "/home/viv/Documents/papers/",
-- --                 info_name = "info.yaml", -- (when setting papis options `-` is replaced with `_`
-- --                 notes_name = [[notes.norg]],
-- --             },
-- --             enable_keymaps = false,
-- --         })
-- --     end,
-- -- })
