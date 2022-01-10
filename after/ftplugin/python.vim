setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal colorcolumn=90

""" Il figure a better way of doing this for now, just a decent way to load modules . 
command! -nargs=*  PyRepl lua require"modules.lang.language_utils".python_repl()

