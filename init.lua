require("core")
require("modules.lsp.lsp.config.handlers").setup()

vim.keymap.set({ "i", "c", "n" }, "<C-g>c", "<Plug>CapsLockToggle")
vim.keymap.set("i", "<C-l>", "<Plug>CapsLockToggle")

