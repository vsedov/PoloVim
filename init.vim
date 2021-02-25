runtime config/main.vim
runtime config/plugins.vim
runtime config/most_mappings.vim
runtime config/plugin_settings.vim
"runtime config/ale.vim
runtime config/dashboard.vim
runtime config/floatterm.vim
runtime config/markdow_multicurse.vim
runtime config/vimtex.vim
runtime config/templates.vim
runtime config/goyo.vim
runtime config/loading_java.vim



"ColorScheme"


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
hi Normal guibg=NONE ctermbg=NONE
"hi Normal ctermfg=252 ctermbg=none
hi Comment gui=italic

" configure nvcode-color-schemes
let g:nvcode_termcolors=256




if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif

syntax on

syntax enable
set termguicolors

hi Normal guibg=NONE ctermbg=NONE
hi CursorLineNr guifg=#50fa7b
hi Comment gui=italic

highlight clear ALEErrorSign
highlight clear ALEWarningSign

let mapleader = " " " Leader is the space key
let g:mapleader = " "
let maplocalleader = '\'
let g:maplocalleader = '\'

nnoremap <SPACE> <Nop>

"auto indent for brackets
nmap <leader>w :w!<cr>
nmap <leader>q :lcl<cr>:q<cr>
nnoremap <leader>h :nohlsearch<Bar>:echo<CR>


" path to your python
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'




augroup AutoRelativeLineNums
  autocmd!
  au InsertEnter * set norelativenumber
  au InsertLeave * set relativenumber
augroup END

"~~~~~~~~~~~~~~~~~~~~~~~~
let g:rainbow_active = 1




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

" theicfire .vimrc tips
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file





" " easy breakpoint python
" au FileType python map <silent> <leader>b ofrom ipdb import set_trace; set_trace()<esc>
" au FileType python map <silent> <leader>B Ofrom ipdb import set_trace; set_trace()<esc>

au FileType python map <silent> <leader>j ofrom pdb import set_trace; set_trace()<esc>
au FileType python map <silent> <leader>J Ofrom pdb import set_trace; set_trace()<esc>

hi self ctermfg=239

autocmd BufRead *.py set wrap
autocmd BufRead *.py set splitbelow
"autocmd BufRead *.py set go+=b
"
" Remove all trailing whitespace by pressing C-S
nnoremap <C-S> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
au BufEnter * if &buftype == 'terminal' | :startinsert | endif


map <F7> :let $VIM_DIR=expand('%:p:h')<CR>: vsplit term://zsh<CR>cd $VIM_DIR<CR>
nnoremap <silent> <F6> :Run <cr>


let g:run_cmd_python = ['ipython']

let g:run_cmd_java = [
                \ 'javac',
                \ '-g:none',
                \ run#defaults#fullfilepath(),
                \ '&&',
                \ 'java',
                \ run#defaults#basefilename()
                \ ]

augroup vimrc_python
  au!
  au FileType python let g:run_auto_close = 1
augroup END






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

command! What echo synIDattr(synID(line('.'), col('.'), 1), 'name')


augroup lens
  let g:lens#disabled_filetypes = ['CHADTree']
  let g:lens#height_resize_min = 5
  let g:lens#width_resize_max = 80


  let g:lens#enter_disabled = 0
  autocmd! WinNew * let g:lens#enter_disabled = 1

  autocmd! WinEnter * call lens#win_enter()
  autocmd! WinNew * let g:lens#enter_disabled = 0


augroup END

nnoremap <silent> <Up>    :call animate#window_delta_height(10)<CR>
nnoremap <silent> <Down>  :call animate#window_delta_height(-10)<CR>
nnoremap <silent> <Left>  :call animate#window_delta_width(10)<CR>
nnoremap <silent> <Right> :call animate#window_delta_width(-10)<CR>



"Ale Configs
let g:ale_completion_enabled = 0
let g:ale_python_pylint_options = '--rcfile ~/.config/pylintrc'
let g:ale_list_window_size =  4
let g:ale_sign_column_always = 1
let g:ale_open_list = 1



let g:ale_set_loclist = 0



let g:ale_set_quickfix = 1
let g:ale_keep_list_window_open = 1
let g:ale_list_vertical = 0

let g:ale_lint_on_save = 1

let g:ale_sign_error = '‼'
let g:ale_sign_warning = '∙'
let g:ale_lint_on_text_changed = 1

let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

nmap <silent> <C-M> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_next_wrap)

let g:ale_linters = {
  \   'markdown': ['mdl'],
  \   'dockerfile': ['dockerfile_lint'],
  \   'bib': ['bibclean'],
  \   'go': ['gofmt', 'golint', 'go vet', 'golangserver'],
  \   'tex': ['proselint', 'chktex', 'lacheck','texlab','latexindent','textlint'],
  \   'plaintex': ['proselint', 'chktex', 'lacheck','texlab'],
  \   'help': [],
  \   'python': ['black','pylint','mypy'],
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
      \ 'python': ['nayvy#ale_fixer', 'black', 'isort'],
      \'java':['google_java_format'],
      \ 'tex':['textlint']
      \ }


let g:ale_fix_on_save = 1
let g:ale_fix_on_insert_leave = 0
let g:ale_fix_on_text_changed = 'never'

nmap <F2> :ALEFix<CR>

let g:ale_set_balloons = 1
let g:ale_hover_cursor = 1
let g:ale_hover_to_preview = 1
let g:ale_float_preview = 1
let g:ale_virtualtext_cursor = 1

"This has to be set to zero for this to work
let g:ale_disable_lsp = 1

let g:ale_completion_enabled=0


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



"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction

" Highlight the symbol and its references when holding the cursor.


autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming Keep this 
nmap <leader>rn <Plug>(coc-rename)
"AutoPair Config
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'




" OutOfdate
" let g:rainbow_active = 1  " Rainbow brackets
let g:targets_aiAI = 'aiAI'



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




"nvim-hlslens




"Fold


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lua << EOF
  require('galaxy')
  require('lsp')
  require('nvim-bufferline')
  require('plugins.telescope')
  require('telescope').load_extension('octo')
EOF
"require('treesitter')


"Till i figure out how tf i do this , without making python scripting lag
"Like  a MF , i will be hardcoding using lua << EOF , as that seemed like the best method 
"require('treesitter')


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


"behaviour of the peekup window on keystroke
lua require('nvim-peekup.config').on_keystroke["delay"] = '100ms'
"
lua require('nvim-peekup.config').on_keystroke["autoclose"] = false
let g:peekup_open = '<leader>"'


"<C-j>, <C-k> to scroll with this its yank history rather nice jk"
"Tree sitter stufff  

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
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

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   indent = {
"     enable = true
"   }
" }
" EOF

" lua <<EOF
"   require'nvim-treesitter.configs'.setup {
"     incremental_selection = {
"         enable = true,
"         keymaps = {
"             init_selection      = "gi",
"             node_incremental    = "n",
"             node_decremental    = "N",
"             scope_incremental   = "b",
"         },
"     },
"   }

" EOF

"Repl and Debug Configs

lua <<EOF
  require('telescope').load_extension('dap')
  require('dap-python').setup('/usr/bin/python3')
  require('dap-python').test_runner = 'pytest'

EOF


"" leader dd is nice for running files .
nnoremap <silent> <leader>dd :lua require('dap').continue()<CR>

nnoremap <silent> <F4> :lua require'telescope'.extensions.dap.commands{}<CR>
nnoremap <silent> <leader>bb :lua require'telescope'.extensions.dap.list_breakpoints{}<CR>
nnoremap <silent> <leader>v :lua require'telescope'.extensions.dap.variables{}<CR>

"Need to figure out what i want to do with this 
nnoremap <silent> <leader>do :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>di :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>dO :lua require'dap'.step_out()<CR>


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
"nnoremap <silent> <S-D> :Lspsaga open_floaterm<CR>
"tnoremap <silent> <S-D> <C-\><C-n>:Lspsaga close_floaterm<CR>


nnoremap <silent>[b :BufferLineCycleNext<CR>
nnoremap <silent>b] :BufferLineCyclePrev<CR>
