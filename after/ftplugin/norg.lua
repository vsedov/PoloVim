-- vim.opt.number = true
vim.treesitter.start()
-- Local

vim.o.wrap = true
vim.o.linebreak = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.breakindentopt = "list:-1"
vim.o.formatlistpat = [[^\s*[-\*\~]\+[\.\)]*\s\+]]

vim.o.colorcolumn = "180"
vim.bo.textwidth = 180
