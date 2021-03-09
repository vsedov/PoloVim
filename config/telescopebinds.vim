" Find files using Telescope command-line sugar.

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fl <cmd>Telescope git_files<cr>


nnoremap <Leader>ppp :lua require'telescope.builtin'.planets{}<cr>
nnoremap <Leader>lbi :lua require'telescope.builtin'.builtin{}<cr>
"Some reason this command doesnt work will figure out why for now we use this . "