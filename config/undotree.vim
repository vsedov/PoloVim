"UndoTree

let g:undotree_SplitWidth = 40



let UndotreePos = 'left'
if !exists('g:undotree_WindowLayout')
    let g:undotree_WindowLayout = 3
endif

  " diff window height
if !exists('g:undotree_DiffpanelHeight')
    let g:undotree_DiffpanelHeight = 8
endif

  " Highlight changed text
if !exists('g:undotree_HighlightChangedText')
    let g:undotree_HighlightChangedText = 1
endif

  " Highlight changed text using signs in the gutter
if !exists('g:undotree_HighlightChangedWithSign')
    let g:undotree_HighlightChangedWithSign = 1
endif

    " Highlight linked syntax type.
    " You may chose your favorite through ":hi" command
if !exists('g:undotree_HighlightSyntaxAdd')
    let g:undotree_HighlightSyntaxAdd = "DiffAdd"
endif
if !exists('g:undotree_HighlightSyntaxChange')
    let g:undotree_HighlightSyntaxChange = "DiffChange"
endif
if !exists('g:undotree_HighlightSyntaxDel')
    let g:undotree_HighlightSyntaxDel = "DiffDelete"
endif



"This covers allot "
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_SplitWidth = 40

let g:sidebars = {
  \ 'CHADTree': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'CHADTree'},
  \     'open': 'CHADopen',
  \     'close': 'CHADopen'
  \ },
  \ 'vista': {
  \     'position': 'left',
  \     'check_win': {nr -> bufname(winbufnr(nr)) =~ '__vista__'},
  \     'open': 'Vista nvim_lsp',
  \     'close': 'Vista'
  \ },
  \ 'undotree': {
  \     'position': 'left',
  \     'check_win': {nr -> getwinvar(nr, '&filetype') ==# 'undotree'},
  \     'open': 'UndotreeShow',
  \     'close': 'UndotreeHide'
  \ }
  \ }

noremap <silent> <M-1> :call sidebar#toggle('CHADTree')<CR>
noremap <silent> <M-2> :call sidebar#toggle('vista')<CR>
nnoremap <F9> :call sidebar#toggle('undotree')<CR>

