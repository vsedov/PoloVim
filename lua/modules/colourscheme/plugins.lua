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

-- colourscheme({
--     "shaunsingh/oxocarbon.nvim",
--     -- as = "oxocarbon",
--     run = "./install.sh",
--     -- opt = true,
--     config = conf.oxocarbon,

-- })

colourscheme({
    "lunarvim/horizon.nvim",
    opt = true,
    config = conf.horizon,
})
