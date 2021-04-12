if exists('syntax_on') | syntax reset | endif
set background=dark


syntax on
syntax enable
set termguicolors
set t_Co=256

highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE


hi GitGutterAdd    guifg=#50fa7b
hi GitGutterChange guifg=#8be9fd
hi GitGutterDelete guifg=#ff5555

hi EasyMotionTarget ctermfg=9 guifg=red
hi EasyMotionTarget2First ctermfg=9 guifg=red
hi EasyMotionTarget2Second ctermfg=9 guifg=lightred
hi link EasyMotionShade Comment

"autocmd ColorScheme dracula_pro* hi CursorLine cterm=underline term=underline
" General misc colors

hi htmlArg gui=italic
hi Type    gui=italic
hi htmlArg cterm=italic



" configure nvcode-color-schemes
let g:nvcode_termcolors=256


" Transparent Background (For i3 and compton)



"hi Normal ctermfg=252 ctermbg=none

hi Comment gui=italic

highlight clear ALEErrorSign
highlight clear ALEWarningSign


"~~~~~~~~~~~~~~~~~~~~~~~~
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
