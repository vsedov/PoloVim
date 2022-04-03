--# selene: allow(unscoped_variables)
--# selene: allow(undefined_variable)
vim.opt.shadafile = "NONE"
require("core")
require("overwrite")
vim.schedule(function()
    vim.opt.shadafile = ""
    vim.cmd([[ silent! rsh ]])
end)
