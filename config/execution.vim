
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'


" Disable Python2 support
let g:loaded_python_provider=0

let mapleader = " " " Leader is the space key
let g:mapleader = " "
let maplocalleader = '\'
let g:maplocalleader = '\'

nnoremap <SPACE> <Nop>

"auto indent for brackets
nmap <leader>w :w!<cr>
nmap <leader>q :lcl<cr>:q<cr>
nnoremap <leader>h :nohlsearch<Bar>:echo<CR>


" path to your python
"let g:python3_host_prog = '/usr/bin/python3'
"let g:python_host_prog = '/usr/bin/python2'


"set encoding to utf8
if &encoding != 'utf-8'
    set encoding=utf-8              "Necessary to show Unicode glyphs
endif
