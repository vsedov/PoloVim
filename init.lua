vim.opt.shadafile = "NONE"
require("core")
require("overwrite")
vim.schedule(function()
    vim.opt.shadafile = ""
    vim.cmd([[ silent! rsh ]])
end)
