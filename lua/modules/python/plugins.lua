local conf = require("modules.python.config")
local python = require("core.pack").package

python({
    "direnv/direnv.vim",
    lazy = true,
    ft = { "python", "julia" },
})
