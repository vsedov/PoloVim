-- add kitty-scrollback.nvim to the runtimepath to allow us to require the kitty-scrollback module
-- pick a runtimepath that corresponds with your package manager, if you are not sure leave them all it will not cause any issues

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/kitty-scrollback.nvim") -- lazy.nvim

vim.loader.enable()
vim.opt.clipboard = "unnamedplus"

vim.cmd([[
    let g:clipboard = {
        \ 'name': 'xsel',
        \ 'copy': {
        \    '+': 'xsel --nodetach -i -b',
        \    '*': 'xsel --nodetach -i -p',
        \  },
        \ 'paste': {
        \    '+': 'xsel -o -b',
        \    '*': 'xsel -o -p',
        \ },
        \ 'cache_enabled': 1,
        \ }
]])
require("core")
