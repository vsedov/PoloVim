setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal go+=b

filetype indent on
filetype on
filetype plugin on
setlocal colorcolumn=90



let g:runner_python_ex = 'python3'
let g:runner_python_options = ''
let g:SuperTabDefaultCompletionType='context'


let g:test#strategy = "dispatch"


let g:test#python#pytest#options = "--disable-warnings --color=yes"
let g:test#python#runner = "pytest"


nnoremap <silent>       <Leader>ai :MagmaInit<CR>

nnoremap <expr><silent> <Leader>a  nvim_exec('MagmaEvaluateOperator', v:true)
nnoremap <silent>       <Leader>ar :MagmaEvaluateLine<CR>
xnoremap <silent>       <Leader>a :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <Leader>ac :MagmaReevaluateCell<CR>

nnoremap <silent> <Leader>ad :MagmaDelete<CR>
nnoremap <silent> <Leader>ao :MagmaShowOutput<CR>

