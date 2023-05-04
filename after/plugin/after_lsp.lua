require("modules.lsp.lsp.config.handlers").setup()

vim.cmd([[
imap <c-f> <c-g>u<Esc>[s1z=`]a<c-g>u
imap <F1> <Esc>mti<C-X>s<Esc>`tla
nmap <c-f> [s1z=<c-o>
]])
