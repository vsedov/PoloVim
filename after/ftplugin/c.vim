setlocal exrc
setlocal secure

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal noexpandtab

setlocal makeprg=gcc\ % 


setlocal colorcolumn=110

let b:ale_fixers = ['clang-format']



"Overriding some keybinds that are not needed . "
"With and without save . "
" automatically open quickfix window when AsyncRun command is executed
" set the quickfix window 6 lines height.
" Using line continuation here.


let s:cpo_save = &cpo
setlocal cpo-=C

let b:undo_ftplugin = "setl fo< com< ofu< cms< def< inc< | if has('vms') | setl isk< | endif"

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croql

" These options have the right value as default, but the user may have
" overruled that.
setlocal commentstring& define& include&

" Set completion with CTRL-X CTRL-O to autoloaded function.
if exists('&ofu')
  setlocal ofu=ccomplete#Complete
endif

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

" In VMS C keywords contain '$' characters.
if has("vms")
  setlocal iskeyword+=$
endif

" When the matchit plugin is loaded, this makes the % command skip parens and
" braces in comments properly.
let b:match_words = '^\s*#\s*if\(\|def\|ndef\)\>:^\s*#\s*elif\>:^\s*#\s*else\>:^\s*#\s*endif\>'
let b:match_skip = 's:comment\|string\|character\|special'


let &cpo = s:cpo_save
unlet s:cpo_save

"" personal code for runnign C Code : 

""-- If ale wants to go fuck boy yon you .
let g:ale_disable_lsp = 1
