local conf = require("modules.colourscheme.config")
local colourscheme = require("core.pack").package
colourscheme({
    "rebelot/kanagawa.nvim",
    opt = true,
    config = conf.kanagawa,
})

colourscheme({
    "catppuccin/nvim",
    opt = true,
    as = "catppuccin",
    cmd = "CatppuccinCompile",
    run = "CatppuccinCompile",
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
