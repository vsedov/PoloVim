scriptencoding utf-8

setlocal conceallevel=2
let g:tex_conceal="abdgm"

" Starting to use vimtex and it needs several configurations to work correctly
let g:vimtex_fold_enabled = 1
let g:vimtex_indent_enabled = 1
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_view_method = 'zathura'
let g:vimtex_complete_close_braces = 1
let g:vimtex_quickfix_mode = 2
let g:vimtex_quickfix_open_on_warning = 0

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


let g:vimtex_quickfix_latexlog = {
            \ 'default' : 1,
            \ 'fix_paths' : 0,
            \ 'general' : 1,
            \ 'references' : 1,
            \ 'overfull' : 1,
            \ 'underfull' : 1,
            \ 'font' : 1,
            \ 'packages' : {
            \   'default' : 1,
            \   'natbib' : 1,
            \   'biblatex' : 1,
            \   'babel' : 1,
            \   'hyperref' : 1,
            \   'scrreprt' : 1,
            \   'fixltx2e' : 1,
            \   'titlesec' : 1,
            \ },
            \}


let g:vimtex_log_ignore = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
        \ 'Token not allowed in a PDF string',
      \ ]

let g:tex_superscripts= "[0-9a-zA-W.,:;+-<>/()=]"
let g:tex_subscripts= "[0-9aehijklmnoprstuvx,+-/().]"

let g:tex_conceal_frac=1

