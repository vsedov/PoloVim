setlocal colorcolumn=+1

nmap <space>gb :Gblame<cr>
nmap <space>gs :Gstatus<cr>
nmap <space>gc :Gcommit -v<cr>
nmap <space>ga :Git add -p<cr>
nmap <space>gm :Gcommit --amend<cr>
nmap <space>gpp :Gpush<cr>
nmap <space>gd :Gdiff<cr>
nmap <space>gw :Gwrite<cr>

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


"Git Blame"
autocmd BufEnter * EnableBlameLine

" Specify the highlight group used for the virtual text ('Comment' by default)
let g:blameLineVirtualTextHighlight = 'Question'

" Change format of virtual text ('%s' by default)
let g:blameLineVirtualTextFormat = '/* %s */'

" Customize format for git blame (Default format: '%an | %ar | %s')
let g:blameLineGitFormat = '%an - %s'
" Refer to 'git-show --format=' man pages for format options)




 ""   EnableBlameLine
  ""  DisableBlameLine
   "" ToggleBlameLine
    "" SingleBlameLine


nnoremap <silent><leader><leader>bb :ToggleBlameLine<CR>



"Description
"q 	Close the popup window
"o 	older. Back to older commit at the line
"O 	Opposite to o. Forward to newer commit at the line
"d 	Toggle unified diff hunks only in current file of the commit
"D 	Toggle all unified diff hunks of the commit
"r 	Toggle word diff hunks only in current file of the commit
"R 	Toggle all word diff hunks of current commit
"? 	Show mappings help

let g:git_messenger_date_format = "%Y %b %d %X"

hi gitmessengerPopupNormal term=None guifg=#eeeeee guibg=#333333 ctermfg=255 ctermbg=234
hi gitmessengerHeader term=None guifg=#88b8f6 ctermfg=111
hi gitmessengerHash term=None guifg=#f0eaaa ctermfg=229
hi gitmessengerHistory term=None guifg=#fd8489 ctermfg=210


let g:git_messenger_include_diff ="all"
nmap <Leader>gm <Plug>(git-messenger)