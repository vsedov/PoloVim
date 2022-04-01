vim.cmd([[
    if exists('g:no_vim_conceal') || !has('conceal') || &enc != 'utf-8'
        finish
    endif
    
    " math related
    syntax match pyOperator " / " conceal cchar=÷
    syntax match pyOperator " \* " conceal cchar=×
    syntax match pyOperator "\<\%(math\.\)\?sqrt\>" conceal cchar=√
    syntax match pyOperator "\<\%(math\.\)\?prod\>" conceal cchar=∏
    syntax match pyOperator "\( \|\)\*\*\( \|\)2\>" conceal cchar=²
    syntax match pyOperator "\( \|\)\*\*\( \|\)3\>" conceal cchar=³
    " keywords
    syntax keyword pyOperator product conceal cchar=∏
    syntax keyword pyOperator sum conceal cchar=∑
    syntax keyword pyStatement lambda conceal cchar=λ
    hi link pyOperator Operator
    hi link pyStatement Statement
    hi link pyKeyword Keyword
    hi! link Conceal Operator
    setlocal conceallevel=2
]])
