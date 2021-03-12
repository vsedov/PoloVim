
source  $HOME/.config/nvim/config/execution.vim
source  $HOME/.config/nvim/config/main.vim
source  $HOME/.config/nvim/config/plugins.vim
source  $HOME/.config/nvim/config/most_mappings.vim
source  $HOME/.config/nvim/config/autogroup.vim
source  $HOME/.config/nvim/config/functions.vim

source  $HOME/.config/nvim/config/plugin_settings.vim
source  $HOME/.config/nvim/config/ale.vim
source  $HOME/.config/nvim/config/dashboard.vim
source  $HOME/.config/nvim/config/floatterm.vim

source  $HOME/.config/nvim/config/pythonmanualdebug.vim
source  $HOME/.config/nvim/config/markdow_multicurse.vim
source  $HOME/.config/nvim/config/vimtex.vim
source  $HOME/.config/nvim/config/templates.vim
source  $HOME/.config/nvim/config/goyo.vim

source  $HOME/.config/nvim/config/loading_java.vim
source  $HOME/.config/nvim/config/debug_test.vim
source  $HOME/.config/nvim/config/chadtree.vim
source  $HOME/.config/nvim/config/undotree.vim
source  $HOME/.config/nvim/config/gitfug.vim

source  $HOME/.config/nvim/config/indent.vim
source  $HOME/.config/nvim/config/vista.vim
source  $HOME/.config/nvim/config/Vimjup.vim
source  $HOME/.config/nvim/config/snipdebugger.vim

source  $HOME/.config/nvim/config/breakhabits.vim


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
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0


inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <NUL> coc#refresh()


" use <tab> for trigger completion and navigate to the next complete item


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" theicfire .vimrc tips
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file


"autocmd BufRead *.py set go+=b
"
" Remove all trailing whitespace by pressing C-S
nnoremap <C-S> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
au BufEnter * if &buftype == 'terminal' | :startinsert | endif


map <F7> :let $VIM_DIR=expand('%:p:h')<CR>: vsplit term://zsh<CR>cd $VIM_DIR<CR>
nnoremap <silent> <F6> :Run <cr>


nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

let g:previous_window = -1
au BufEnter * call SmartInsert()


command! What echo synIDattr(synID(line('.'), col('.'), 1), 'name')




nnoremap <silent> <Up>    :call animate#window_delta_height(10)<CR>
nnoremap <silent> <Down>  :call animate#window_delta_height(-10)<CR>
nnoremap <silent> <Left>  :call animate#window_delta_width(10)<CR>
nnoremap <silent> <Right> :call animate#window_delta_width(-10)<CR>


"This was causing sisues ? "
set omnifunc=coc#completion#OmniFunc

"#OmniFuncset omnifunc=coc#completion#OmniFunc


set statusline=
set statusline+=%m
set statusline+=\ %f
set statusline+=%=

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}




" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming Keep this 
nmap <leader>rn <Plug>(coc-rename)



"AutoPair Config
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'

" OutOfdate
let g:rainbow_active = 1  " Rainbow brackets
let g:targets_aiAI = 'aiAI'




if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif



nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>



" Configuration example
"<C-w><C-p> this is to move to the next windw



"Fold
"LUA CONFIG STARTS HERE WILL HAVE TO AUTOLOAD THIS AS WELL > "

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lua << EOF
  require('galaxy')
  require('lsp')
  require('nvim-bufferline')
  require('plugins.telescope')
  require('telescope').load_extension('octo')
  require('telescope').load_extension('dap')
  require('dap-python').setup('/usr/bin/python3')
  require('dap-python').test_runner = 'pytest'
  require('kommentary.config').use_extended_mappings()
  require('treesitter')
  require('sagastuff')
  require('quickfix-bar')
  require("telescope").load_extension("frecency")


EOF
" geometry configuration
lua require('nvim-peekup.config').geometry["height"] = 0.8
lua require('nvim-peekup.config').geometry["title"] = 'An awesome window title'


"behaviour of the peekup window on keystroke
lua require('nvim-peekup.config').on_keystroke["delay"] = '100ms'
"
lua require('nvim-peekup.config').on_keystroke["autoclose"] = false

hi TelescopeBorder         guifg=#8be9fd
hi TelescopePromptBorder   guifg=#50fa7b
hi TelescopePromptPrefix   guifg=#bd93f9

highlight BqfPreviewBorder guifg=#50a14f ctermfg=71
highlight link BqfPreviewRange IncSearch



"Lua Source Configs"
source  $HOME/.config/nvim/config/dapdebug.vim
source  $HOME/.config/nvim/config/telescopebinds.vim
source  $HOME/.config/nvim/config/saga.vim
source  $HOME/.config/nvim/config/peek.vim
source  $HOME/.config/nvim/config/bufferstuff.vim



""Help define what the bloody plugin value is
map <leader>hhi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

