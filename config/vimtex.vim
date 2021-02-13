
" Starting to use vimtex and it needs several configurations to work correctly
let g:vimtex_fold_enabled = 1
let g:vimtex_indent_enabled = 1
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_view_method = 'zathura'
let g:vimtex_complete_close_braces = 1
let g:vimtex_quickfix_mode = 2
let g:vimtex_quickfix_open_on_warning = 1

let g:vimtex_view_general_options = '-reuse-instance @pdf'

let g:vimtex_delim_changemath_autoformat = 1

call vimtex#imaps#add_map({
  \ 'lhs' : '<m-i>',
  \ 'rhs' : '\item ',
  \ 'leader' : '',
  \ 'wrapper' : 'vimtex#imaps#wrap_environment',
  \ 'context' : ["itemize", "enumerate", "compactitem"],
  \})

let g:Tex_MultipleCompileFormats='pdf'
let g:Tex_CompileRule_pdf = 'pdflatex -output-directory=output '
  \. '-synctex=-1 -src-specials -interaction=nonstopmode $*; '
  \. 'pdflatex -output-directory=output '
  \. '-synctex=-1 -src-specials -interaction=nonstopmode $*'
