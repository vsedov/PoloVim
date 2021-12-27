-- https://github.com/max397574/NeovimConfig/blob/master/clipboard_neorg.vim
vim.bo.shiftwidth = 2
vim.o.conceallevel = 2
vim.bo.commentstring = "#%s"

local wk = require("which-key")

wk.register({
  t = {
    name = "+Tasks",
    d = { "Done" },
    u = { "Undone" },
    p = { "Pending" },
    i = { "Important" },
    h = { "On Hold" },
    c = { "Cancelled" },
    r = { "Recurring" },
  },
}, {
  prefix = "g",
  mode = "n",
})

wk.register({
  m = {
    name = "+Mode",
    n = "Norg",
    h = "Traverse Heading",
  },
  t = {
    name = "+Gtd",
    c = "Capture",
    e = "Edit",
    v = "Views",
  },
  n = {
    name = "+New Note",
    n = "New Note",
  },
}, {
  prefix = "<leader>o",
  mode = "n",
})

vim.cmd([[source ~/.config/nvim/clipboard_neorg.vim]])