function! s:goyo_enter()
  set noshowmode
  set noshowcmd
  set nonumber
  set norelativenumber
  set scrolloff=999
  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
endfunction

function! s:goyo_leave()
  set showmode
  set showcmd
  set scrolloff=5
    if g:use_line_numbers
      set number
      set relativenumber
    endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()