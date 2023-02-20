vim.g.wordmotion_nomap = 1
for _, key in ipairs({ "e", "b", "w", "E", "B", "W", "ge", "gE" }) do
    vim.keymap.set({ "n", "x", "o" }, key, "<Plug>WordMotion_" .. key)
end
vim.keymap.set({ "x", "o" }, "aW", "<Plug>WordMotion_aW")
vim.keymap.set({ "x", "o" }, "iW", "<Plug>WordMotion_iW")
vim.keymap.set("c", "<C-R><C-W>", "<Plug>WordMotion_<C-R><C-W>")
vim.keymap.set("c", "<C-R><C-A>", "<Plug>WordMotion_<C-R><C-A>")
vim.g.wordmotion_spaces = "['_']"
vim.g.wordmotion_uppercase_spaces =
    "['-', '.', ',', '<', '>', '(', ')', '[', ']', '{', '}', '&', '*', '=', '!', '+', ';', ':', '/', '\"']"
