"-- or use command LspSagaFinder
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
"-- code action
nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
"-- show hover doc
nnoremap <silent>K :Lspsaga hover_doc<CR>
"-- scroll down hover doc
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>
"-- scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>
"-- show signature help
nnoremap <silent> gs :Lspsaga signature_help<CR>
"-- preview definition
nnoremap <silent> gd :Lspsaga preview_definition<CR>
"-- show
nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
"-- jump diagnostic
nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>


"-- float terminal also you can pass the cli command in open_float_terminal function
"nnoremap <silent> <S-D> :Lspsaga open_floaterm<CR>
"tnoremap <silent> <S-D> <C-\><C-n>:Lspsaga close_floaterm<CR>
