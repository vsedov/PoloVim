" " easy breakpoint python
" au FileType python map <silent> <leader>b ofrom ipdb import set_trace; set_trace()<esc>
" au FileType python map <silent> <leader>B Ofrom ipdb import set_trace; set_trace()<esc>

au FileType python map <silent> <leader>j o__import__('ipdb').set_trace()<esc>
au FileType python map <silent> <leader>J O__import__('ipdb').set_trace()<esc>

autocmd BufRead *.py set wrap
autocmd BufRead *.py set splitbelow