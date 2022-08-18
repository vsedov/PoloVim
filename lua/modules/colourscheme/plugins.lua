local conf = require("modules.colourscheme.config")
local colourscheme = require("core.pack").package
colourscheme({
    "rebelot/kanagawa.nvim",
    -- opt = true,
    opt = true,
    config = conf.kanagawa,
})

colourscheme({
    "catppuccin/nvim",
    opt = true,
    as = "catppuccin",
    cmd = "CatppuccinCompile",
    setup = function()
        vim.g.catppuccin_flavour = lambda.config.colourscheme.catppuccin_flavour -- latte, frappe, macchiato, mocha
    end,
    config = conf.catppuccin,
})

colourscheme({
    "rose-pine/neovim",
    opt = true,
    as = "rose",
    module = "rose-pine",
    tag = "v1.*",
    config = conf.rose,
})

colourscheme({
    "lunarvim/horizon.nvim",
    opt = true,
    config = conf.horizon,
})
colourscheme({
    "wadackel/vim-dogrun",
    opt = true,
    config = conf.dogrun,
})

colourscheme({
    "NTBBloodbath/doom-one.nvim",
    config = conf.doom,
    opt = true,
})
