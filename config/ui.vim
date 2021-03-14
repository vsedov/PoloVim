

"ColorScheme"
if (has("termguicolors"))
  set termguicolors
  hi LineNr ctermbg=NONE guibg=NONE
endif



syntax on
syntax enable
set termguicolors

hi GitGutterAdd    guifg=#50fa7b
hi GitGutterChange guifg=#8be9fd
hi GitGutterDelete guifg=#ff5555

hi EasyMotionTarget ctermfg=9 guifg=red
hi EasyMotionTarget2First ctermfg=9 guifg=red
hi EasyMotionTarget2Second ctermfg=9 guifg=lightred
hi link EasyMotionShade Comment

"autocmd ColorScheme dracula_pro* hi CursorLine cterm=underline term=underline
" General misc colors

hi CursorLineNr guifg=#50fa7b

hi htmlArg gui=italic
hi Comment gui=italic
hi Type    gui=italic
hi htmlArg cterm=italic
hi Comment cterm=italic
hi Type    cterm=italic



" configure nvcode-color-schemes
let g:nvcode_termcolors=256


hi Normal guibg=NONE ctermbg=NONE
"hi Normal ctermfg=252 ctermbg=none

hi CursorLineNr guifg=#50fa7b
hi Comment gui=italic

highlight clear ALEErrorSign
highlight clear ALEWarningSign


"~~~~~~~~~~~~~~~~~~~~~~~~
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
