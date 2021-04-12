
set nocompatible
set encoding=utf-8
set title


set wildoptions+=pum
set lazyredraw

set shell=zsh
set signcolumn=yes

augroup redraw_on_refocus
  au FocusGained * :redraw!
augroup END

" Ignore annoying patterns
set wildignore=*.pyc,**/__pycache__/*,**/node_modules/*,.coverage.*,.eggs,*.egg-info/

" Ignore casing when performing completion
set wildignorecase




filetype on
filetype plugin on
filetype plugin indent on
syntax on


" Settings for popup menu
set pumheight=15  " Maximum number of items to show in popup menu
set pumblend=5  " Pesudo blend effect for popup menu


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

"After 
set clipboard=unnamedplus


set list
set listchars+=trail:•
set listchars+=nbsp:_

" Show hostname, full path of file and last-mod time on the window title.
" The meaning of the format str for strftime can be found in
" http://tinyurl.com/l9nuj4a. The function to get lastmod time is drawn from
" http://tinyurl.com/yxd23vo8
set title
set titlestring=
set titlestring+=%(%{hostname()}\ \ %)
set titlestring+=%(%{expand('%:p')}\ \ %)
set titlestring+=%{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}


" Virtual edit is useful for visual block edit
set virtualedit=block



" Changing fillchars for folding, so there is no garbage charactes
set fillchars=fold:\ ,vert:\|


" Set matching pairs of characters and highlight matching brackets
set matchpairs+=<:>,「:」

autocmd Filetype gitcommit setlocal spell textwidth=72