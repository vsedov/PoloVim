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


"Vista
map <C-t> :Vista nvim_lsp<CR>
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



" FlyGrep settings
nnoremap <leader>s :FlyGrep<cr>

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



"ChadTree
map <C-n> :CHADopen<CR>
let g:chadtree_settings = {
\ "theme.text_colour_set": "env",
\  "theme.icon_colour_set":"github",
\  "theme.icon_glyph_set":"devicons",
\ "ignore.name_glob":['.*'],
\  "view.width":10,
\ }

autocmd FileType CHADtree setlocal number relativenumber
nnoremap <leader>l <cmd>call setqflist([])<cr>

"I Dont know what this does , but if i remove it , it breaks the code ...
let g:run_split = 'right'




"Lens
let g:lens#disabled_filetypes = ['nerdtree','chadtree']
augroup lens
  let g:lens#enter_disabled = 0
  autocmd! WinNew * let g:lens#enter_disabled = 1
  autocmd! WinEnter * call lens#win_enter()
  autocmd! WinNew * let g:lens#enter_disabled = 0
augroup END


"Ipynb Vimpyter
autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>

"Sneak Plugin 
let g:sneak#label = 1
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S

map t <Plug>Sneak_t
map T <Plug>Sneak_T


"Vim GitGutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_map_keys = 0

hi GitGutterAdd    guifg=#50fa7b
hi GitGutterChange guifg=#8be9fd
hi GitGutterDelete guifg=#ff5555


"Ctrlp
let g:ctrlp_custom_ignore = '\v\.(npy|jpg|pyc|so|dll)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']


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
"
" ESearch
let g:esearch = {
  \ 'adapter':    'ack',
  \ 'backend':    'nvim',
  \ 'out':        'win',
  \ 'batch_size': 1000,
  \ 'use':        ['visual', 'hlsearch', 'last'],
  \}

  " Neoterm
let g:neoterm_size=20
let g:neoterm_repl_command= 'zsh'
let g:neoterm_default_mod = 'horizontal'
let g:neoterm_autoinsert=1
let g:neoterm_size=16
nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>

  " toogle the terminal
  " kills the current job (send a <c-c>)
nnoremap <silent> tc :call neoterm#kill()<cr>

"Fold And Number Toggle
let g:SimpylFold_docstring_preview = 1
let b:SimpylFold_fold_import = 1
let b:SimpylFold_fold_import = 1
nnoremap <F9> :NumbersToggle<CR>



"Vim Sandwich Configs
let g:sandwich#recipes = [
    \   {'buns': ["`",                "'"],                 'nesting': 1, 'input': [ "u'" ]  },
    \   {'buns': ['“',                '”'],                 'nesting': 1, 'input': [ 'u"' ]  },
    \   {'buns': ['„',                '“'],                 'nesting': 1, 'input': [ 'U"', 'ug' ]  },
    \   {'buns': ['«',                '»'],                 'nesting': 1, 'input': [ 'u<', 'uf' ]  },
    \   {'buns': ["'''",              "'''"],               'nesting': 0, 'input': [ "3'" ], 'filetype': ['python'] },
    \   {'buns': ['"""',              '"""'],               'nesting': 0, 'input': [ '3"' ], 'filetype': ['python'] },
    \   {'buns': ["`",                "'"],                 'nesting': 1, 'input': [ "l'", "l`" ], 'filetype': ['tex', 'plaintex'] }]

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)+g:sandwich#recipes


"Doge and Nayvy Configs Using Custom Nayvy.py
let g:doge_doc_standard_python = 'google'
let g:nayvy_import_config_path = '$HOME/nayvy.py'
let g:nayvy_coc_enabled =1


"Indent Line 
let g:indentLine_fileType = ["tex",".tex"]
let g:indentLine_fileTypeExclude= [".py","py"]
let g:indentLine_faster = 1


