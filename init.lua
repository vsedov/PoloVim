-- add kitty-scrollback.nvim to the runtimepath to allow us to require the kitty-scrollback module
-- pick a runtimepath that corresponds with your package manager, if you are not sure leave them all it will not cause any issues

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/kitty-scrollback.nvim") -- lazy.nvim
vim.loader.enable()
require("core")
vim.defer_fn(function()
    vim.cmd("silent! UpdateRemotePlugins")
end, 6000)
