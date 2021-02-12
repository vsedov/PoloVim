
set nocompatible
set encoding=utf-8
set title
set backspace=indent,eol,start
set wildoptions+=pum
set lazyredraw
set regexpengine=2
set shell=zsh
set signcolumn=yes

augroup redraw_on_refocus
  au FocusGained * :redraw!
augroup END

" Ignore annoying patterns
set wildignore=*.pyc,**/__pycache__/*,**/node_modules/*,.coverage.*,.eggs,*.egg-info/

" Ignore casing when performing completion
set wildignorecase



"-------- end vim-plug setup ----

call plug#begin('~/.vim/plugged')
"Local
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'meain/vim-printer'


"Tree
"Plug 'scrooloose/nerdtree'  " file list
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'jiangmiao/auto-pairs'


Plug 'liuchengxu/vista.vim'
Plug 'https://github.com/vwxyutarooo/nerdtree-devicons-syntax'
Plug 'Konfekt/FastFold'
"Plug 'Vimjas/vim-python-pep8-indent'  "better indenting for python
Plug 'kien/ctrlp.vim'  " fuzzy search files

Plug 'justinmk/vim-sneak'
Plug 'wsdjeg/FlyGrep.vim'  " awesome grep on the fly
Plug 'w0rp/ale'  " python linters

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'szymonmaszke/vimpyter' "vim-plug

"Color
Plug 'wadackel/vim-dogrun'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'Julpikar/night-owl.nvim'
Plug 'rockerBOO/boo-colorscheme-nvim'
Plug 'fneu/breezy'  " Exactly like breeze theme for ktexteditor

Plug 'sainnhe/edge'

Plug 'honza/vim-snippets'

Plug 'https://github.com/felipec/vim-felipec'
"LSP stuff
" Neovim's builtin LSP and treesitter impl. make it a very lightweight IDE

Plug 'neovim/nvim-lspconfig' " The most important plugin
Plug 'nvim-lua/lsp-status.nvim'  " lsp items in the statusbar
Plug 'nvim-treesitter/nvim-treesitter' " tree-sitter support
Plug 'nvim-lua/lsp_extensions.nvim'

Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
" Plug 'wellle/context.vim'
"Yank memorizer 

Plug 'https://github.com/p00f/nvim-ts-rainbow'
Plug 'gennaro-tedesco/nvim-peekup'


""Lua stuff
Plug 'glepnir/galaxyline.nvim'
Plug 'kyazdani42/nvim-web-devicons' " lua
Plug 'ryanoasis/vim-devicons' " vimscript
"Plug 'romgrk/barbar.nvim'

"Bugger

Plug 'romgrk/barbar.nvim'
"Plug 'akinsho/nvim-bufferline.lua'
Plug 'liuchengxu/vim-clap'


"Bracket for surround text
Plug 'tpope/vim-surround'  " Commands for matching pairs
Plug 'townk/vim-autoclose'  " Auto-match pairs in insert mode
Plug 'ConradIrwin/vim-bracketed-paste'  " Auto-sets paste



" Syntax highlighting
" ~~~~~~~~~~~~~~~~~
Plug 'mboughaba/i3config.vim', { 'for': 'i3config' }
Plug 'tikhomirov/vim-glsl'
Plug 'leafo/moonscript-vim'
Plug 'gpanders/vim-scdoc'
Plug 'https://tildegit.org/sloum/gemini-vim-syntax.git'
Plug 'cespare/vim-toml'
Plug 'euclidianAce/BetterLua.vim' " better lua syntax highlighting for 5.3/4
Plug 'norcalli/nvim-colorizer.lua' " Fastest color-code colorizer
Plug 'justinmk/vim-syntax-extra' " C and bison syntax highlighting
Plug 'KeitaNakamura/tex-conceal.vim', {'for': ['plaintex', 'tex', 'pandoc']}

Plug 'https://github.com/tmhedberg/SimpylFold'
Plug 'lervag/vimtex'


"FInder Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'glepnir/lspsaga.nvim'

"Debugging
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'theHamsta/nvim-dap-virtual-text'

Plug 'tpope/vim-sensible'

"ANimation
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'
Plug 'sbdchd/vim-run'

Plug 'psliwka/vim-smoothie'
Plug 'auxiliary/vim-layout'     " i3 like layout

Plug 'https://github.com/tpope/vim-fugitive'

"Better float?
Plug 'voldikss/vim-floaterm'



Plug 'jdhao/better-escape.vim'
Plug '/home/viv/.vim/plugged/dracula_pro/'

Plug 'kassio/neoterm'
Plug 'metakirby5/codi.vim'
Plug 'junegunn/goyo.vim'


Plug 'aperezdc/vim-template'
Plug 'psf/black', { 'branch': 'stable' }


Plug 'relastle/vim-nayvy'
Plug 'https://github.com/tpope/vim-sleuth'


Plug 'https://github.com/chiedo/vim-case-convert'
Plug 'https://github.com/nikersify/dracula-vim'
Plug 'https://github.com/tmhedberg/SimpylFold'


Plug 'junegunn/vim-easy-align'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'francoiscabrol/ranger.vim'
Plug 'stsewd/isort.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'rbgrouleff/bclose.vim'
Plug 'airblade/vim-gitgutter'  " show git changes to files in gutter
Plug 'https://tildegit.org/sloum/gemini-vim-syntax.git'

"sdsd

" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
"Plug 'https://github.com/vim-python/python-syntax'
"Plug 'jeetsukumaran/vim-pythonsense' "Moving functions

" (Optional) Multi-entry selection UI.
"Plug 'junegunn/fzf'
Plug 'Chiel92/vim-autoformat'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'wellle/targets.vim'
Plug 'https://github.com/machakann/vim-sandwich/'
Plug 'https://github.com/mbbill/undotree'
Plug 'wsdjeg/FlyGrep.vim'  " awesome grep on the fly
Plug 'tpope/vim-commentary'  "comment-out by gc
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"Plug 'epheien/termdbg'

"Repl
Plug 'tpope/vim-repeat'
Plug 'pappasam/nvim-repl'



"Plug 'neomake/neomake'
" looking

Plug 'glepnir/dashboard-nvim'


"Plug 'https://github.com/glepnir/indent-guides.nvim'
"Plug 'Yggdroot/indentLine'
"Lua Plugin for Indent Line
"Plug 'https://github.com/lukas-reineke/indent-blankline.nvim.git',{'branch': 'lua'}


Plug 'ryanoasis/vim-devicons'
Plug 'myusuf3/numbers.vim'

Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }

call plug#end()
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

let g:vista#renderer#enable_icon = 1


" path to your python
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'



if has('transparency')
  set transparency=10
endif


filetype on
filetype plugin on
filetype plugin indent on
syntax on

set cmdheight=2
set updatetime=100

set fileformat=unix
set shortmess+=c

set mouse=a  " change cursor per mode
set number  " always show current line number
set smartcase  " better case-sensitivity when searching
set wrapscan  " begin search from top of file when nothing is found anymore


set expandtab
set tabstop=4
set shiftwidth=4
set fillchars+=vert:\  " remove chars from seperators
set softtabstop=4

set history=1000  " remember more commands and search history

set noswapfile  " swap files give annoying warning

set breakindent  " preserve horizontal whitespace when wrapping
set showbreak=..
set lbr  " wrap words


" set nowrap  " i turn on wrap manually when needed

set scrolloff=3 " keep three lines between the cursor and the edge of the screen

set undodir=~/.vim/undodir
set undofile  " save undos
set undolevels=10000  " maximum number of changes that can be undone
set undoreload=100000  " maximum number lines to save for undo on a buffer reload

set noshowmode  " keep command line clean
set noshowcmd

set splitright  " i prefer splitting right and below
set splitbelow

set hlsearch  " highlight search and search while typing
set incsearch
set cpoptions+=x  " stay at seach item when <esc>

set noerrorbells  " remove bells (i think this is default in neovim)
set visualbell
set t_vb=
set relativenumber number
set viminfo='20,<1000  " allow copying of more than 50 lines to other applications



" easy split movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" tabs:
nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>


" mapping Esc
imap <F13> <Esc>
cnoremap <Esc> <C-c>
inoremap <c-c> <ESC>
nnoremap <C-z> <Esc>  " disable terminal ctrl-z

" map S to replace current word with pasteboard
nnoremap S diw"0P
nnoremap cc "_cc
nnoremap q: :q<CR>
nnoremap w: :w<CR>

" map paste, yank and delete to named register so the content
" will not be overwritten (I know I should just remember...)
nnoremap x "_x
vnoremap x "_x

set clipboard=unnamedplus

" toggle nerdtree on ctrl+n


map <C-n> :CHADopen<CR>
map <C-t> :Vista nvim_lsp<CR>





let g:tagbar_horizontal = 15
let g:undotree_SplitWidth = 40

let UndotreePos = 'left'

let g:formatters_vue = ['black']
let g:run_all_formatters_vue = 1

noremap <F8> :Autoformat<CR>
nnoremap <F3> :Black<CR>
set pumheight=8



"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <silent> <expr> <CR> (pumvisible() && empty(v:completed_item)) ?  "\<c-y>\<cr>" : "\<CR>"


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







let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'



let g:airline_powerline_fonts = 1
let g:airline_section_y = ""

" Airline settings
" do not show error/warning section
let g:airline_section_error = ""
let g:airline_section_warning = ""

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" theicfire .vimrc tips
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " " " Leader is the space key
let g:mapleader = " "
let maplocalleader = '\'
let g:maplocalleader = '\'

nnoremap <SPACE> <Nop>

"auto indent for brackets
nmap <leader>w :w!<cr>
nmap <leader>q :lcl<cr>:q<cr>
nnoremap <leader>h :nohlsearch<Bar>:echo<CR>

" FlyGrep settings
nnoremap <leader>s :FlyGrep<cr>

" " easy breakpoint python
" au FileType python map <silent> <leader>b ofrom ipdb import set_trace; set_trace()<esc>
" au FileType python map <silent> <leader>B Ofrom ipdb import set_trace; set_trace()<esc>

au FileType python map <silent> <leader>j ofrom pdb import set_trace; set_trace()<esc>
au FileType python map <silent> <leader>J Ofrom pdb import set_trace; set_trace()<esc>

" ale options
let g:ale_completion_enabled = 0


let g:ale_python_pylint_options = '--rcfile ~/.config/pylintrc'
let g:ale_python_mypy_executable = '--ignore-missing-imports'
let g:ale_list_window_size =  2
let g:ale_sign_column_always = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0

let g:ale_lint_on_save = 1

" Options are in .pylintrc!
highlight VertSplit ctermbg=253

let g:ale_sign_error = '‼'
let g:ale_sign_warning = '∙'
let g:ale_lint_on_text_changed = 'never'

let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0



nmap <silent> <C-M> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_next_wrap)


" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
   if &wrap
      return "g" . a:movement
   else
      return a:movement
   endif
endfunction

onoremap <silent> <expr> j ScreenMovement("j")
onoremap <silent> <expr> k ScreenMovement("k")
onoremap <silent> <expr> 0 ScreenMovement("0")
onoremap <silent> <expr> ^ ScreenMovement("^")
onoremap <silent> <expr> $ ScreenMovement("$")
nnoremap <silent> <expr> j ScreenMovement("j")
nnoremap <silent> <expr> k ScreenMovement("k")
nnoremap <silent> <expr> 0 ScreenMovement("0")
nnoremap <silent> <expr> ^ ScreenMovement("^")
nnoremap <silent> <expr> $ ScreenMovement("$")





highlight self ctermfg=239



let g:lens#disabled_filetypes = ['nerdtree','chadtree']
autocmd BufRead *.py set wrap
autocmd BufRead *.py set splitbelow
autocmd BufRead *.py set go+=b



" Remove all trailing whitespace by pressing C-S
nnoremap <C-S> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>


au BufEnter * if &buftype == 'terminal' | :startinsert | endif
nnoremap <C-a> <Esc>
nnoremap <C-x> <Esc>

" vimgutter options
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_map_keys = 0


let g:ctrlp_custom_ignore = '\v\.(npy|jpg|pyc|so|dll)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Plugin settings
  " Airline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline_powerline_fonts = 1
    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif


  " EasyAlign
    xmap ga <Plug>(LiveEasyAlign)
    nmap ga <Plug>(LiveEasyAlign)
  " EasyMotion
    hi EasyMotionTarget ctermfg=9 guifg=red
    hi EasyMotionTarget2First ctermfg=9 guifg=red
    hi EasyMotionTarget2Second ctermfg=9 guifg=lightred
    hi link EasyMotionShade Comment
  " Emmet
    let g:user_emmet_leader_key = ',z'
  " ESearch
    let g:esearch = {
      \ 'adapter':    'ack',
      \ 'backend':    'nvim',
      \ 'out':        'win',
      \ 'batch_size': 1000,
      \ 'use':        ['visual', 'hlsearch', 'last'],
      \}
  " IndentLine




  " Markdown_preview (a plugin in nyaovim)
    let g:markdown_preview_eager = 1
    let g:markdown_preview_auto = 1
  " Multi_cursor
    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_start_key='<c-n>'
    let g:multi_cursor_next_key='<tab>'
    let g:multi_cursor_prev_key='b'
    let g:multi_cursor_skip_key='x'
    let g:multi_cursor_quit_key='q'

  " Neoterm
    let g:neoterm_size=20
    let g:neoterm_repl_command= 'zsh'
    let g:neoterm_default_mod = 'horizontal'

    " toogle the terminal
    " kills the current job (send a <c-c>)
    nnoremap <silent> tc :call neoterm#kill()<cr>
  " Notes
    let g:notes_directories = ['~/Dev/notes-in-vim']

let g:dashboard_default_executive ='clap'

let g:dashboard_default_executive ='telescope'


nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>


 let g:dashboard_custom_shortcut={
      \ 'last_session'       : 'SPC s l',
      \ 'find_history'       : 'SPC f h',
      \ 'find_file'          : 'SPC f f',
      \ 'new_file'           : 'SPC c n',
      \ 'change_colorscheme' : 'SPC t c',
      \ 'find_word'          : 'SPC f a',
      \ 'book_marks'         : 'SPC f b',
      \ }


  " Supertab
    let g:SuperTabMappingForward = '<s-tab>'
    let g:SuperTabMappingBackward = '<tab>'
  " Tagbar
    let g:tagbar_width=30
  " Taglist
    let Tlist_Show_One_File=1
    let Tlist_Exit_OnlyWindow=1
    let Tlist_File_Fold_Auto_Close=1
    let Tlist_WinWidth=30
    let Tlist_Use_Right_Window=1

"Vim dashboard

    let g:dashboard_custom_shortcut={
      \ 'last_session'       : 'SPC s l',
      \ 'find_history'       : 'SPC f h',
      \ 'find_file'          : 'SPC f f',
      \ 'new_file'           : 'SPC c n',
      \ 'change_colorscheme' : 'SPC t c',
      \ 'find_word'          : 'SPC f a',
      \ 'book_marks'         : 'SPC f b',
      \ }


map <F7> :let $VIM_DIR=expand('%:p:h')<CR>: vsplit term://zsh<CR>cd $VIM_DIR<CR>

nnoremap <silent> <F6> :Run <cr>

nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

let g:previous_window = -1
function SmartInsert()
  if &buftype == 'term://*'
    if g:previous_window != winnr()
      startinsert
    endif
    let g:previous_window = winnr()
  else
    let g:previous_window = -1
  endif
endfunction

au BufEnter * call SmartInsert()

" https://stackoverflow.com/questions/18948491/running-python-code-in-vim
function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    " setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
    if (line('$') == 1 && getline(1) == '')
      q!
    endif
    silent execute 'wincmd p'
endfunction



let g:dracula_bold = 1
let g:dracula_bold = 1
let g:dracula_underline = 1
let g:dracula_undercurl = 1
let g:dracula_inverse = 1
let g:dracula_colorterm = 1

hi Comment gui=italic

if !has('gui_running')
  " Use terminal emulator's background
  hi Normal guibg=NONE
endif


"hi Normal guibg=NONE ctermbg=NONE
hi Normal ctermfg=252 ctermbg=none


syntax enable
set termguicolors

"lua require('night-owl')

lua require'boo-colorscheme'.use{}

"colorscheme dracula_pro_van_helsing
"colorscheme felipec

autocmd ColorScheme dracula_pro* hi CursorLine cterm=underline term=underline

  " General misc colors
  "hi LineNr       guibg=#282a36 guifg=#44475a
  hi CursorLineNr guifg=#50fa7b


  " vim-gitgutter
  hi GitGutterAdd    guifg=#50fa7b
  hi GitGutterChange guifg=#8be9fd
  hi GitGutterDelete guifg=#ff5555

" function MyCustomHighlights()


"     hi semshiLocal           ctermfg=209 guifg=#FFB86C
"     hi semshiGlobal          ctermfg=214 guifg=#BD93F9

"     hi semshiImported        ctermfg=214 guifg=#ffaf00 cterm=bold gui=bold

"     hi semshiParameter       ctermfg=75  guifg=#A4FFFF
"     hi semshiParameterUnused ctermfg=117 guifg=#8BE9FD cterm=underline gui=underline
"     hi semshiFree            ctermfg=218 guifg=#FF79C6
"     hi semshiBuiltin         ctermfg=207 guifg=#ff5fff
"     hi semshiAttribute       ctermfg=49  guifg=#50FA7B
"     hi semshiSelf            ctermfg=249 guifg=#b2b2b2
"     hi semshiUnresolved      ctermfg=226 guifg=#F1FA8C cterm=underline gui=underline



"     hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f

"     hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
"     hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
"     sign define semshiError text=E> texthl=semshiErrorSign




" endfunction

" autocmd FileType python call MyCustomHighlights()









"let g:airline_theme='dracula_pro'



command! What echo synIDattr(synID(line('.'), col('.'), 1), 'name')


let g:sandwich#recipes = [
    \   {'buns': ["`",                "'"],                 'nesting': 1, 'input': [ "u'" ]  },
    \   {'buns': ['“',                '”'],                 'nesting': 1, 'input': [ 'u"' ]  },
    \   {'buns': ['„',                '“'],                 'nesting': 1, 'input': [ 'U"', 'ug' ]  },
    \   {'buns': ['«',                '»'],                 'nesting': 1, 'input': [ 'u<', 'uf' ]  },
    \   {'buns': ["'''",              "'''"],               'nesting': 0, 'input': [ "3'" ], 'filetype': ['python'] },
    \   {'buns': ['"""',              '"""'],               'nesting': 0, 'input': [ '3"' ], 'filetype': ['python'] },
    \   {'buns': ["`",                "'"],                 'nesting': 1, 'input': [ "l'", "l`" ], 'filetype': ['tex', 'plaintex'] }]

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)+g:sandwich#recipes




let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'



" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"



"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)






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


" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.


let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }


function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction


set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc



autocmd VimEnter * call vista#RunForNearestMethodOrFunction()


let g:ale_linters = {
  \   'markdown': ['mdl'],
  \   'dockerfile': ['dockerfile_lint'],
  \   'bib': ['bibclean'],
  \   'go': ['gofmt', 'golint', 'go vet', 'golangserver'],
  \   'tex': ['proselint', 'chktex', 'lacheck','texlab','latexindent','textlint'],
  \   'plaintex': ['proselint', 'chktex', 'lacheck','texlab'],
  \   'help': [],
  \   'python': ['black','pylint','pyright'],
  \   'ruby': ['solargraph', 'rubocop', 'ruby'],
  \   'groovy': ['android'],
  \   'xml': ['android'],
  \   'java': ['javalsp'],
  \   'kotlin': ['ktlint', 'languageserver'],
  \   'javascript': ['eslint'],
  \   'text': ['proselint', 'write-good'],
  \   'vim': ['vint'],
  \   'yaml': ['yamllint'],
  \   'openapi': ['yamllint', 'ibm-validator'],
  \   'mail': ['proselint', 'write-good']
\}

let g:ale_fixers = {
      \ 'python': ['nayvy#ale_fixer', 'black', 'isort','add_blank_lines_for_python_control_statements','trim_whitespace'],
      \'java':['google_java_format'],
      \ 'tex':['textlint']
      \ }


let g:ale_fix_on_save = 1
nmap <F2> :ALEFix<CR>

let g:ale_set_balloons = 1
let g:ale_hover_cursor = 1
let g:ale_hover_to_preview = 1
let g:ale_float_preview = 1
let g:ale_virtualtext_cursor = 1

"This has to be set to zero for this to work 
let g:ale_disable_lsp = 0


function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? '✨ all good ✨' : printf(
        \   '😞 %dW %dE',
        \   all_non_errors,
        \   all_errors
        \)
endfunction

set statusline=
set statusline+=%m
set statusline+=\ %f
set statusline+=%=
set statusline+=\ %{LinterStatus()}


set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}




let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'



let g:ale_completion_enabled=0
set omnifunc=coc#completion#OmniFunc

let g:rainbow_active = 1  " Rainbow brackets

let g:targets_aiAI = 'aiAI'

let g:Tex_MultipleCompileFormats='pdf'


let g:Tex_CompileRule_pdf = 'pdflatex -output-directory=output '
  \. '-synctex=-1 -src-specials -interaction=nonstopmode $*; '
  \. 'pdflatex -output-directory=output '
  \. '-synctex=-1 -src-specials -interaction=nonstopmode $*'

let g:templates_no_autocmd = 1


let g:email = 'viv.sedov@hotmail.com'
let g:user = 'Viv Sedov'

"autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab





" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']


let g:markdown_fenced_languages = [
      \ 'vim',
      \ 'help'
      \]

set statusline^=%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}
autocmd User CocGitStatusChange {command}



let g:doge_doc_standard_python = 'google'
:let g:doge_python_settings = {
\  'single_quotes': 0
\}

map <F1> :DogeGenerate<CR>
map <C-]> :TemplateHere<CR>




let g:nayvy_import_config_path = '$HOME/nayvy.py'
let g:nayvy_coc_enabled =1


if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

setlocal colorcolumn=+1


nmap <space>gb :Gblame<cr>
nmap <space>gs :Gstatus<cr>
nmap <space>gc :Gcommit -v<cr>
nmap <space>ga :Git add -p<cr>
nmap <space>gm :Gcommit --amend<cr>
nmap <space>gpp :Gpush<cr>
nmap <space>gd :Gdiff<cr>
nmap <space>gw :Gwrite<cr>


nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>



" Configuration example
"<C-w><C-p> this is to move to the next windw


"          y - stage this hunk
"          n - do not stage this hunk
"          q - quit; do not stage this hunk nor any of the remaining ones
"          a - stage this hunk and all later hunks in the file
"          d - do not stage this hunk nor any of the later hunks in the file
"          g - select a hunk to go to
"          / - search for a hunk matching the given regex
"          j - leave this hunk undecided, see next undecided hunk
"          J - leave this hunk undecided, see next hunk
"          k - leave this hunk undecided, see previous undecided hunk
"          K - leave this hunk undecided, see previous hunk
"          s - split the current hunk into smaller hunks
"          e - manually edit the current hunk
"          ? - print help





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





let g:SimpylFold_docstring_preview = 1
let b:SimpylFold_fold_import = 1
let b:SimpylFold_fold_import = 1


let g:neoterm_autoinsert=1
let g:neoterm_size=16

nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>


 nnoremap <F9> :NumbersToggle<CR>

let g:indentLine_defaultGroup = 'Constant'
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_color_gui = '#755faa'

let g:indentLine_faster = 1 

let g:is_pythonsense_alternate_motion_keymaps = 1


let g:sneak#label = 1
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S

map t <Plug>Sneak_t
map T <Plug>Sneak_T


autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>


augroup lens
  let g:lens#enter_disabled = 0
  autocmd! WinNew * let g:lens#enter_disabled = 1
  autocmd! WinEnter * call lens#win_enter()
  autocmd! WinNew * let g:lens#enter_disabled = 0
augroup END

let g:run_split = 'right'


au BufLeave * silent! wall



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



nnoremap <leader>l <cmd>call setqflist([])<cr>

let g:chadtree_settings = {
    \ "theme.text_colour_set": "env",
    \  "theme.icon_colour_set":"github",
    \  "theme.icon_glyph_set":"devicons",
    \ "ignore.name_glob":['.*'],
    \  "view.width":10,
    \ }

autocmd FileType CHADtree setlocal number relativenumber
nnoremap <leader>l <cmd>call setqflist([])<cr>


" nmap <silent> <leader>ee :Semshi error<CR>
" nmap <silent> <leader>ge :Semshi goto error<CR>


function! LoadJavaContent(uri)
     setfiletype java
     let content = CocRequest('java', 'java/classFileContents', {'uri': 'jdt:/' . a:uri})
     call setline(1, split(content, "\n"))
     setl nomod
     setl readonly
endfunction
autocmd! BufReadPre,BufReadCmd,FileReadCmd,SourceCmd *.class call LoadJavaContent(expand("<amatch>"))<CR>





" Starting to use vimtex and it needs several configurations to work correctly
let g:vimtex_fold_enabled = 1
let g:vimtex_indent_enabled = 1
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_view_method = 'zathura'
let g:vimtex_complete_close_braces = 1
let g:vimtex_quickfix_mode = 2
let g:vimtex_quickfix_open_on_warning = 1

let g:vimtex_view_general_options = '-reuse-instance @pdf'

let g:vimtex_delim_changemath_autoformat = 1

call vimtex#imaps#add_map({
  \ 'lhs' : '<m-i>',
  \ 'rhs' : '\item ',
  \ 'leader' : '',
  \ 'wrapper' : 'vimtex#imaps#wrap_environment',
  \ 'context' : ["itemize", "enumerate", "compactitem"],
  \})




lua << EOF
  require('treesitter')
  require('plugins.telescope')
  require('galaxy')
  require('lsp')
EOF


" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fl <cmd>Telescope git_files<cr>



"lua stuff 
" geometry configuration
lua require('nvim-peekup.config').geometry["height"] = 0.8
lua require('nvim-peekup.config').geometry["title"] = 'An awesome window title'
" behaviour of the peekup window on keystroke
lua require('nvim-peekup.config').on_keystroke["delay"] = '300ms'
lua require('nvim-peekup.config').on_keystroke["autoclose"] = false

let g:peekup_open = '<leader>"'



"<C-j>, <C-k> to scroll with this its yank history rather nice jk"
"Tree sitter stufff  
lua <<EOF
 playground = {
    enable = true,
    disable = {},
    updatetime = 5, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false 
}

EOF

lua << EOF
require'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true
  }
}
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  refactor = {
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
  },
}
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  refactor = {
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
  },
}
EOF


lua <<EOF
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
EOF

lua <<EOF
  require'nvim-treesitter.configs'.setup {
  textobjects = {
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}
EOF




"Repl and Debug Configs

lua <<EOF
  require('telescope').load_extension('dap')
  require('dap-python').setup('/usr/bin/python3')
  require('dap-python').test_runner = 'pytest'

EOF






nnoremap <silent> <F4> :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>dd :lua require('dap').continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.repl.run_last()<CR>`
nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>



let g:dap_virtual_text = v:true
nnoremap <leader><leader>e :ReplToggle<CR>
nmap <silent><leader>e <Plug>ReplSendLine
vmap <silent><leader>e <Plug>ReplSendVisual



nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>


let g:SnipRun_repl_behavior_enable = ["Python3_jupyter"]
let g:SnipRun_select_interpreters = ["Python3_jupyter"]


"Mini Debugging Mode
let g:vim_printer_print_below_keybinding = '<leader>p'
let g:vim_printer_print_above_keybinding = '<leader>P'



nmap <leader>g <Plug>SnipRun
vmap g <Plug>SnipRun


let g:repl_filetype_commands = {
    \ 'javascript': 'node',
    \ 'python': 'ipython',
    \ }



hi TelescopeBorder         guifg=#8be9fd
hi TelescopePromptBorder   guifg=#50fa7b
hi TelescopePromptPrefix   guifg=#bd93f9




"-- or use command LspSagaFinder
nnoremap <silent> gh :Lspsaga lsp_finder<CR>


"-- code action
nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>


"-- show hover doc
nnoremap <silent>K :Lspsaga hover_doc<CR>

"-- scroll down hover doc
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>
"-- scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>

"-- show signature help
nnoremap <silent> gs :Lspsaga signature_help<CR>

"-- preview definition
nnoremap <silent> gd :Lspsaga preview_definition<CR>



"-- show
nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>


"-- jump diagnostic
nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>


"-- float terminal also you can pass the cli command in open_float_terminal function
"nnoremap <silent> <S-d> :Lspsaga open_floaterm<CR>
"tnoremap <silent> <S-d> <C-\><C-n>:Lspsaga close_floaterm<CR>



"This is just for rust but hope we can have a python version soon 
nnoremap <Leader>C :lua require'lsp_extensions'.inlay_hints()

" NOTE: This variable doesn't exist before barbar runs. Create it before
"    

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



let bufferline = get(g:, 'bufferline', {})

" Enable/disable animations
let bufferline.animation = v:true

" Enable/disable auto-hiding the tab bar when there is a single buffer
let bufferline.auto_hide = v:false

" Enable/disable icons
" if set to 'numbers', will show buffer index in the tabline
" if set to 'both', will show buffer index and icons in the tabline
let bufferline.icons = v:true

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


"Add this in the future 
"lua require('indent_guides').setup()

call bufferline#highlight#setup()