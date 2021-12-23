
"Add mypy when required sometimes a complete pain to deal with . "
let g:ale_linters = {
  \   'python': [],
\}

let g:ale_fixers = {
  \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['nayvy#ale_fixer','black','isort'],
\ }
