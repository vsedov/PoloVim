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

