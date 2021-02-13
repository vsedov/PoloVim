
function! s:goyo_enter()
    let s:goyo_entered = 1
    set noshowmode
    set noshowcmd

    set scrolloff=999
    set wrap
    setlocal textwidth=0
    setlocal wrapmargin=0
endfunction

function! s:goyo_leave()

    let s:goyo_entered = 0
    set showmode
    set showcmd

    set scrolloff=5
    set textwidth=120
    set wrapmargin=8
endfunction


autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave
