
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


nnoremap <Leader>ppp :lua require'telescope.builtin'.planets{}<cr>
nnoremap <Leader>lbi :lua require'telescope.builtin'.builtin{}<cr>
"Some reason this command doesnt work will figure out why for now we use this . "

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


"Repl and Debug Configs




"" leader dd is nice for running files .
nnoremap <silent> <leader>dd :lua require('dap').continue()<CR>

nnoremap <silent> <F4> :lua require'telescope'.extensions.dap.commands{}<CR>
nnoremap <silent> <leader>bb :lua require'telescope'.extensions.dap.list_breakpoints{}<CR>
"This has broken for some reason . "
"nnoremap <silent> <leader>v :lua require'telescope'.extensions.dap.variables{}<CR>

"This actually seems quite nice "
nnoremap <Leader>v :lua require'plugins.telescope'.treesitter()<cr>"

"Need to figure out what i want to do with this 
nnoremap <silent> <leader>do :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>di :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>dO :lua require'dap'.step_out()<CR>


nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>drr :lua require'dap'.repl.toggle({width = 50}, "belowright vsplit")<cr>

nnoremap <silent> <leader>dl :lua require'dap'.repl.run_last()<CR>`
nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>

let g:dap_virtual_text = v:true
let g:dap_virtual_text = "all_frames"


"Some issue with all of this for some reason . "
nnoremap <leader><leader>e :ReplToggle<CR>
" Send the text of a motion to the REPL
nmap <leader>rs  :ReplSend <CR>
" Send the current line to the REPL
nmap <leader>rss :ReplSendLine<CR>
nmap <leader>rs_ :ReplSendLine<CR>
" Send the selected text to the REPL
vmap <leader>rs  :ReplSend<CR>


let g:repl_filetype_commands = {
    \ 'javascript': 'node',
    \ 'python': 'ipython',
    \ }


inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files --hidden')
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})
inoremap <expr> <c-x><c-l> fzf#vim#complete#line()







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
let g:bufferline = { "closable" : 0  }



lua << EOF
require("lspsaga").init_lsp_saga {
  use_saga_diagnostic_sign = false,
  finder_action_keys = {
    vsplit = "v",
    split = "s",
    quit = {"q", "<ESC>"}
  }
}
EOF





highlight BqfPreviewBorder guifg=#50a14f ctermfg=71
highlight link BqfPreviewRange IncSearch

lua <<EOF
require('bqf').setup({
    auto_enable = true,
    preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
       
        auto_preview = false
        
        },
        
    func_map = {
        vsplit = '',
        ptoggleauto = "p"
    },
    filter = {
        fzf = {
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
        }
    }
})
EOF
