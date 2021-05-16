
"Add mypy when required sometimes a complete pain to deal with . "
let g:ale_linters = {
  \   'markdown': ['mdl'],
  \   'dockerfile': ['dockerfile_lint'],
  \   'bib': ['bibclean'],
  \   'go': ['gofmt', 'golint', 'go vet', 'golangserver'],
  \   'tex': ['proselint', 'chktex', 'lacheck','texlab','latexindent','textlint'],
  \   'plaintex': ['proselint', 'chktex', 'lacheck','texlab'],
  \   'help': [],
  \   'python': ['pyright','flake8'], 
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
      \ 'python': ['nayvy#ale_fixer', 'black'],
      \'java':['google_java_format','remove_trailing_lines'],
      \ 'tex':['textlint']
      \ }


"This has to be set to zero for this to work
let g:ale_disable_lsp = 1


"highlight clear ALEErrorSign
highlight clear ALEWarningSign

command! Nani echo synIDattr(synID(line('.'), col('.'), 1), 'name')