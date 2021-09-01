" if has('nvim-0.5')
"   augroup lsp
"     au!
"     au FileType java lua require('jdtls').start_or_attach({cmd = {'/home/viv/workspace/java-lsp.sh'}})
"   augroup end
" endif







" nnoremap ga <Cmd>lua require('jdtls').code_action()<CR>
" vnoremap ga <Esc><Cmd>lua require('jdtls').code_action(true)<CR>
" nnoremap <leader>gr <Cmd>lua require('jdtls').code_action(false, 'refactor')<CR>


" nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
" nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>



" nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
" nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
" vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
" nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
" vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
" vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>

