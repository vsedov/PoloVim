if &encoding != 'utf-8'
    setlocal encoding=utf-8              "Necessary to show Unicode glyphs
endif


setlocal encoding=utf-8
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal go+=b
setlocal conceallevel=1
filetype indent on
filetype on
filetype plugin on
setlocal colorcolumn=90
hi Comment gui=italic

setlocal foldexpr=nvim_treesitter#foldexr()  " disabled until it works
"setlocal foldmethod=expr


"highlight ColorColumn guibg=Blackhi Normal guibg=NONE ctermbg=NONE

let g:runner_python_ex = 'python3'
let g:runner_python_options = ''

let b:ale_fixers = ['nayvy#ale_fixer', 'black', 'isort']
let b:ale_linters = ['black', 'pylint']






