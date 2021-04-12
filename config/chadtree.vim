"ChadTree
map <C-n> :NERDTreeToggle<CR>

nnoremap <leader><C-n> :CHADopen<CR>


let g:chadtree_settings = {
\ "theme.text_colour_set": "env",
\  "theme.icon_colour_set":"github",
\  "theme.icon_glyph_set":"devicons",
\ "ignore.name_glob":['.*'],
\  "view.width":10,
\ }

autocmd FileType CHADtree setlocal number relativenumber

let g:NERDTreeWinSize=10