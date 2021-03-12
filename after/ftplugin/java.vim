command! -buffer JdtCompile lua require('jdtls').compile()
command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
command! -buffer JdtJol lua require('jdtls').jol()
command! -buffer JdtBytecode lua require('jdtls').javap()
command! -buffer JdtJshell lua require('jdtls').jshell()
nnoremap <buffer> <leader>df <Cmd>lua require'jdtls'.test_class()<CR>

nmap <buffer> <silent> <leader>bb :lua require'dap'.toggle_breakpoint()<CR>
nmap <buffer> <silent> <leader>br :lua require'dap'.restart()<CR>
nmap <buffer> <silent> <leader>bc :lua require'dap'.continue()<CR>
nmap <buffer> <silent> <leader>bn :lua require'dap'.step_over()<CR>
nmap <buffer> <silent> <leader>bi :lua require'dap'.step_into()<CR>
nmap <buffer> <silent> <leader>bo :lua require'dap'.step_out()<CR>
nmap <buffer> <silent> <leader>bm :DebugRepl<cr>

set nospell