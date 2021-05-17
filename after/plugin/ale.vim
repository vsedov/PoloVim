
"Add mypy when required sometimes a complete pain to deal with . "
let g:ale_linters = {
  \   'markdown': ['mdl'],
  \   'dockerfile': ['dockerfile_lint'],
  \   'bib': ['bibclean'],
  \   'go': ['gofmt', 'golint', 'go vet', 'golangserver'],
  \   'tex': ['proselint', 'chktex', 'lacheck','texlab','latexindent','textlint'],
  \   'plaintex': ['proselint', 'chktex', 'lacheck','texlab'],
  \   'help': [],
  \   'python': [''], 
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
  \   'mail': ['proselint', 'write-good'],
  \   'lua': [''],
  \   'c':['']
\}

let g:ale_fixers = {
  \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['nayvy#ale_fixer','black'],
\ }




"highlight clear ALEErrorSign
highlight clear ALEWarningSign

command! Nani echo synIDattr(synID(line('.'), col('.'), 1), 'name')

