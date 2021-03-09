"Repl and Debug Configs

"" leader dd is nice for running files .
nnoremap <silent> <leader>dd :lua require('dap').continue()<CR>

nnoremap <silent> <F4> :lua require'telescope'.extensions.dap.commands{}<CR>
nnoremap <silent> <leader>bb :lua require'telescope'.extensions.dap.list_breakpoints{}<CR>
"This has broken for some reason . "
"nnoremap <silent> <leader>v :lua require'telescope'.extensions.dap.variables{}<CR>

"This actually seems quite nice "
nnoremap <Leader>vv :lua require'plugins.telescope'.treesitter()<cr>"

"Need to figure out what i want to do with this 
nnoremap <silent> <leader>do :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>di :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>dO :lua require'dap'.step_out()<CR>


nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>drr :lua require'dap'.repl.toggle({width = 50}, "belowright vsplit")<cr>

nnoremap <silent> <leader>dl :lua require'dap'.repl.run_last()<CR>`
nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>

let g:dap_virtual_text = v:true
let g:dap_virtual_text = "all_frames"


"Some issue with all of this for some reason . "
nnoremap <leader><leader>e :ReplToggle<CR>
" Send the text of a motion to the REPL
nmap <leader>rs  :ReplSend <CR>
" Send the current line to the REPL
nmap <leader>rss :ReplSendLine<CR>
nmap <leader>rs_ :ReplSendLine<CR>
" Send the selected text to the REPL
vmap <leader>rs  :ReplSend<CR>


let g:repl_filetype_commands = {
    \ 'javascript': 'node',
    \ 'python': 'ipython',
    \ }
