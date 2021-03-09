call plug#begin('~/.vim/plugged')
"Local
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'meain/vim-printer'


"Tree
Plug 'scrooloose/nerdtree'  " file list
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'jiangmiao/auto-pairs'
Plug 'liuchengxu/vista.vim'


Plug 'https://github.com/vwxyutarooo/nerdtree-devicons-syntax'

Plug 'Konfekt/FastFold'
Plug 'Vimjas/vim-python-pep8-indent'  "better indenting for python
Plug 'kien/ctrlp.vim'  " fuzzy search files
Plug 'justinmk/vim-sneak'
Plug 'wsdjeg/FlyGrep.vim'  " awesome grep on the fly

Plug 'w0rp/ale'  " python linters

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

"Need to relearn how to use this dam thing again . "
Plug 'szymonmaszke/vimpyter' "vim-plug

"Color Leave me alone ok , i like colours . 
Plug 'wadackel/vim-dogrun'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'Julpikar/night-owl.nvim'
Plug 'rockerBOO/boo-colorscheme-nvim', { 'branch': 'main' }
Plug 'glepnir/zephyr-nvim'
Plug 'fneu/breezy'  " Exactly like breeze theme for ktexteditor
Plug 'sainnhe/edge'
Plug 'https://github.com/felipec/vim-felipec'

"LSP stuff
" Neovim's builtin LSP and treesitter impl. make it a very lightweight IDE


Plug 'neovim/nvim-lspconfig' " The most important plugin
Plug 'nvim-lua/lsp-status.nvim'  " lsp items in the statusbar
Plug 'nvim-lua/lsp_extensions.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'luochen1990/rainbow'
Plug 'honza/vim-snippets'

"Yank memorizer 
Plug 'gennaro-tedesco/nvim-peekup'


""Lua stuff
Plug 'glepnir/galaxyline.nvim'
Plug 'kyazdani42/nvim-web-devicons' " lua
Plug 'ryanoasis/vim-devicons' " vimscript

"Bugger

"Plug 'romgrk/barbar.nvim'
Plug 'akinsho/nvim-bufferline.lua'
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


"For some reason you need this Indent line for the aut
"Plug 'Yggdroot/indentLine'
Plug 'https://github.com/tmhedberg/SimpylFold'
Plug 'lervag/vimtex'


"FInder Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'pwntester/octo.nvim'
Plug 'glepnir/lspsaga.nvim'


""Neuron Note taking didint work ,. 
Plug 'oberblastmeister/neuron.nvim'
Plug 'nvim-lua/popup.nvim'


""Vim be good game ? 
Plug 'ThePrimeagen/vim-be-good' 

"AutoSession

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

"Github Plugins"
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'tveskag/nvim-blame-line'



"Better float?
Plug 'voldikss/vim-floaterm'

"Discord rpc"

Plug 'jdhao/better-escape.vim'
Plug '/home/viv/.vim/plugged/dracula_pro/'

"Plug 'kassio/neoterm'
Plug 'metakirby5/codi.vim'
Plug 'junegunn/goyo.vim'


Plug 'aperezdc/vim-template'
Plug 'psf/black', { 'branch': 'stable' }


Plug 'relastle/vim-nayvy'
Plug 'https://github.com/tpope/vim-sleuth'

Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'https://github.com/chiedo/vim-case-convert'
"Plug 'https://github.com/nikersify/dracula-vim'
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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'Chiel92/vim-autoformat'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'wellle/targets.vim'
Plug 'https://github.com/machakann/vim-sandwich/'
Plug 'https://github.com/mbbill/undotree'
Plug 'wsdjeg/FlyGrep.vim'  " awesome grep on the fly

"This is outdata and moving it Komentary lua scripted"
"Plug 'tpope/vim-commentary'  "comment-out by gc
Plug 'b3nj5m1n/kommentary'


Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"Plug 'epheien/termdbg'

"Repl
Plug 'tpope/vim-repeat'
Plug 'pappasam/nvim-repl'

"waka"
Plug 'wakatime/vim-wakatime'

"Plug 'neomake/neomake'
" looking
"Plug 'andweeb/presence.nvim' - i honestly prefer the coc extention . 
Plug 'kevinhwang91/nvim-bqf'
Plug 'glepnir/dashboard-nvim'


"Plug 'https://github.com/glepnir/indent-guides.nvim'
"Lua Plugin for Indent Line
Plug 'https://github.com/lukas-reineke/indent-blankline.nvim.git',{'branch': 'lua'}
Plug 'ryanoasis/vim-devicons'




Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }


""Side bar Manager - looks cool 
Plug 'https://github.com/brglng/vim-sidebar-manager'


"Because im lazy , i want sudo acccess sometimes 
Plug 'https://github.com/lambdalisue/suda.vim.git'


"Unit Testing"
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'janko/vim-test'
Plug 'rcarriga/vim-ultest'

"Vim Conceal "
Plug  'KeitaNakamura/tex-conceal.vim', {'for': 'tex'} " for VimPlug
"Multi Curser like Sublime test "
"Plug 'mg979/vim-visual-multi', {'branch': 'master'}

"I think this just makes everything just laggy and annoying "
"Plug 'nathunsmitty/nvim-ale-diagnostic'


call plug#end()

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif



