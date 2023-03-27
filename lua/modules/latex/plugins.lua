local conf = require("modules.latex.config")
local latex = require("core.pack").package
local filetype = { "latex", "tex" }
latex({
    "lervag/vimtex",
    ft = filetype,
    init = conf.vimtex,
})

latex({
    "jakewvincent/texmagic.nvim",
    ft = filetype,
    config = conf.texmagic,
})
