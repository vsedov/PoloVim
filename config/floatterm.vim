set autochdir

let g:floaterm_rootmarkers = []

let g:floaterm_height = 0.5
let g:floaterm_width = 0.45

let g:floaterm_position = 'bottomright'

nnoremap   <space>1    :FloatermNew <CR>
tnoremap   <space>2    <C-\><C-n>:FloatermNew<CR>
nnoremap   <space>3   :FloatermPrev<CR>
tnoremap   <space>4    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <space>5   :FloatermNext<CR>
tnoremap   <space>6   <C-\><C-n>:FloatermNext<CR>
nnoremap   <space>7  :FloatermToggle<CR>
tnoremap   <space>8 <C-\><C-n>:FloatermToggle<CR>
