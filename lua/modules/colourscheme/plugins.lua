local conf = require("modules.colourscheme.config")
local colourscheme = require("core.pack").package

colourscheme({
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = conf.kanagawa,
})

colourscheme({
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    cmd = "CatppuccinCompile",
    init = function()
        vim.g.catppuccin_flavour = lambda.config.colourscheme.catppuccin_flavour -- latte, frappe, macchiato, mocha
    end,
    config = conf.catppuccin,
})

-- temp::
colourscheme({
    "rose-pine/neovim", -- rose-pine/neovim
    lazy = true,
    name = "rose",
    config = conf.rose,
})

colourscheme({
    "lunarvim/horizon.nvim",
    lazy = true,
    config = conf.horizon,
})
colourscheme({
    "wadackel/vim-dogrun",
    lazy = true,
    config = conf.dogrun,
})

colourscheme({
    "NTBBloodbath/doom-one.nvim",
    config = conf.doom,
    lazy = true,
})

colourscheme({
    "olivercederborg/poimandres.nvim",
    config = conf.poimandres,
    lazy = true,
})

colourscheme({
    "folke/tokyonight.nvim",
    lazy = true,
    config = conf.tokyonight,
})

colourscheme({
    "sam4llis/nvim-tundra",
    lazy = true,
    config = conf.tundra,
})
colourscheme({
    "kvrohit/mellow.nvim",
    lazy = true,
    config = conf.mellow,
})

colourscheme({
    "ramojus/mellifluous.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = true,
    config = conf.melli,
})

colourscheme({
    "JoosepAlviste/palenightfall.nvim",
    lazy = true,
    config = conf.palenightfall,
})
colourscheme({
    "NTBBloodbath/sweetie.nvim",
    lazy = true,
    config = conf.sweetie,
})
colourscheme({
    "svermeulen/text-to-colorscheme.nvim",
    lazy = true,
    config = conf.text_to_colourscheme,
    cmd = { "T2CSelect", "T2CGenerate" },
})
