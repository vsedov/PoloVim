let g:SnipRun_repl_behavior_enable = ["Python3_jupyter"]
let g:SnipRun_select_interpreters = ["Python3_jupyter"]


"Mini Debugging Mode
let g:vim_printer_print_below_keybinding = '<leader>p'
let g:vim_printer_print_above_keybinding = '<leader>P'


nmap <leader>ggr <Plug>SnipRun 
vmap g <Plug>SnipRun
nmap <leader>smc :SnipReplMemoryClean<CR>
