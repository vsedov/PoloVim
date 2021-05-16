
nnoremap   <space>1    :FloatermNew <CR>
tnoremap   <space>2    <C-\><C-n>:FloatermNew<CR>
nnoremap   <space>3   :FloatermPrev<CR>
tnoremap   <space>4    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <space>5   :FloatermNext<CR>
tnoremap   <space>6   <C-\><C-n>:FloatermNext<CR>
nnoremap   <space>7  :FloatermToggle<CR>
tnoremap   <space>8 <C-\><C-n>:FloatermToggle<CR>

let g:floaterm_rootmarkers = []



let g:floaterm_wintype ='vsplit'

let g:floaterm_width = 20
let g:floaterm_autohide = 1

hi Floaterm guibg=clear
hi FloatermBorder guibg=clear guifg=clear



function s:floatermSettings()
    setlocal scrolloff=0
    autocmd BufLeave <buffer> ++once set scrolloff=3
endfunction
autocmd FileType floaterm call s:floatermSettings() 