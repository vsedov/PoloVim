if &encoding != 'utf-8'
    setlocal encoding=utf-8              "Necessary to show Unicode glyphs
endif

setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal go+=b



highlight ColorColumn guibg=Black
hi Normal guibg=NONE ctermbg=NONE


let b:ale_fixers = { 'java':['google_java_format','remove_trailing_lines']}

