"Ale Configs
let g:ale_completion_enabled = 0
let g:ale_python_pylint_options = '--rcfile ~/.config/pylintrc'
let g:ale_python_mypy_options = ''
let g:ale_list_window_size =  4
let g:ale_sign_column_always = 0
let g:ale_open_list = 1


let g:ale_set_loclist = 0


let g:ale_set_quickfix = 1
let g:ale_keep_list_window_open = 1
let g:ale_list_vertical = 0

let g:ale_lint_on_save = 1

let g:ale_sign_error = '‼'
let g:ale_sign_warning = '∙'
let g:ale_lint_on_text_changed = 1

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

nmap <silent> <C-M> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_next_wrap)

"Add mypy when required sometimes a complete pain to deal with . "
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
  \   'mail': ['proselint', 'write-good'],
  \   'prolog':['swipl']
\}

let g:ale_fixers = {
      \ 'python': ['nayvy#ale_fixer', 'black', 'isort'],
      \'java':['google_java_format','remove_trailing_lines'],
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

let g:ale_floating_window_border = []
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']