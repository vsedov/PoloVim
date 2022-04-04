vim.opt.shadafile = "NONE"
require("core")
require("overwrite")
vim.opt.shadafile = ""
vim.cmd([[ silent! rsh ]])
