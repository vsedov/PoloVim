"This is just for me being lazy btw "
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



let g:run_split = 'right'

let g:run_cmd_python = ['ipython']

let g:run_cmd_java = [
                \ 'javac',
                \ '-g:none',
                \ run#defaults#fullfilepath(),
                \ '&&',
                \ 'java',
                \ run#defaults#basefilename()
                \ ]



"Sneak Plugin 
let g:sneak#label = 1
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S

map t <Plug>Sneak_t
map T <Plug>Sneak_T


"Vim GitGutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_map_keys = 0




"Ctrlp
let g:ctrlp_custom_ignore = '\v\.(npy|jpg|pyc|so|dll)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']


" EasyAlign

xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)
" EasyMotion

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
"let g:neoterm_size=20
"let g:neoterm_repl_command= 'zsh'
"let g:neoterm_default_mod = 'horizontal'
"let g:neoterm_autoinsert=1
"let g:neoterm_size=16
"nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>

  " toogle the terminal
  " kills the current job (send a <c-c>)
"nnoremap <silent> tc :call neoterm#kill()<cr>"

"Fold And Number Toggle
let g:SimpylFold_docstring_preview = 1
let b:SimpylFold_fold_import = 1
let b:SimpylFold_fold_import = 1



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


let g:suda_smart_edit = 1

let g:formatters_vue = ['black']
let g:run_all_formatters_vue = 1
let g:rainbow_active = 1


noremap <F8> :Autoformat<CR>
nnoremap <F3> :Black<CR>