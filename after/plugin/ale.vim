
"Add mypy when required sometimes a complete pain to deal with . "
let g:ale_linters = {
  \   'python': [],
\}

let g:ale_fixers = {
    \ 'python': ['nayvy#ale_fixer','yapf','isort'],
\ }
