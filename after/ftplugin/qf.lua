local opt = vim.opt_local

opt.wrap = false
opt.number = false
opt.signcolumn = "yes"
opt.buflisted = false
opt.winfixheight = true

vim.keymap.set("n", "dd", lambda.list.qf.delete, { desc = "delete current quickfix entry", buffer = 0 })
vim.keymap.set("v", "d", lambda.list.qf.delete, { desc = "delete selected quickfix entry", buffer = 0 })
vim.keymap.set("n", "H", ":colder<CR>", { buffer = 0 })
vim.keymap.set("n", "L", ":cnewer<CR>", { buffer = 0 })
-- force quickfix to open beneath all other splits
vim.cmd.wincmd("J")

lambda.adjust_split_height(3, 10)
