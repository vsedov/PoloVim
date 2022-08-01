local conf = require("modules.colourscheme.config")
local colourscheme = require("core.pack").package

colourscheme({
    "catppuccin/nvim",
    opt = true,
    as = "catppuccin",
    cmd = "CatppuccinCompile",
    run = "CatppuccinCompile",
    config = conf.catppuccin,
})

-- Use default when loading this .
colourscheme({ "rebelot/kanagawa.nvim", opt = true, config = conf.kanagawa })

colourscheme({
    "lunarvim/horizon.nvim",
    opt = true,
    config = conf.horizon,
})
