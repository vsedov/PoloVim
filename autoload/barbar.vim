nnoremap <silent>    <S-,> :BufferPrevious<CR>
nnoremap <silent>    <S-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <S-<> :BufferMovePrevious<CR>
nnoremap <silent>    <S->> :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <S-1> :BufferGoto 1<CR>
nnoremap <silent>    <S-2> :BufferGoto 2<CR>
nnoremap <silent>    <S-3> :BufferGoto 3<CR>
nnoremap <silent>    <S-4> :BufferGoto 4<CR>
nnoremap <silent>    <S-5> :BufferGoto 5<CR>

" Close buffer
nnoremap <silent>    <S-c> :BufferClose<CR>



let bufferline = {}

" Enable/disable animations
let bufferline.animation = v:true

" Enable/disable auto-hiding the tab bar when there is a single buffer
let bufferline.auto_hide = v:false

" Enable/disable icons
" if set to 'numbers', will show buffer index in the tabline
" if set to 'both', will show buffer index and icons in the tabline
let bufferline.icons = v:true

" Configure icons on the bufferline.
let bufferline.icon_separator_active = '▎'
let bufferline.icon_separator_inactive = '▎'
"et bufferline.icon_close_tab = ''
let bufferline.icon_close_tab_modified = '●'

" Enable/disable close button
let bufferline.closable = v:false

" Enables/disable clickable tabs
"  - left-click: go to buffer
"  - middle-click: delete buffer
let bufferline.clickable = v:true

" If set, the letters for each buffer in buffer-pick mode will be
" assigned based on their name. Otherwise or in case all letters are
" already assigned, the behavior is to assign letters in order of
" usability (see order below)
let bufferline.semantic_letters = v:true

" New buffer letters are assigned in this order. This order is
" optimal for the qwerty keyboard layout but might need adjustement
" for other layouts.
let bufferline.letters =
  \ 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP'

" Sets the maximum padding width with which to surround each tab
let bufferline.maximum_padding = 4


let fg_target = 'red'



