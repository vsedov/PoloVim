scriptencoding utf-8

if exists('g:no_vim_fancy_text') || !has('conceal') || &enc != 'utf-8'
  finish
endif

syntax match pyFancyOperator "=\@<!===\@!" conceal cchar=≡
syntax match pyFancyOperator "<=" conceal cchar=≤
syntax match pyFancyOperator ">=" conceal cchar=≥
syntax match pyFancyOperator "\<\%(\%(math\|np\|numpy\)\.\)\?sqrt\>" conceal cchar=√
syntax match pyFancyKeyword "\<\%(\%(math\|np\|numpy\)\.\)\?pi\>" conceal cchar=π
syntax match pyFancyOperator "\<\%(\%(math\|np\|numpy\)\.\)\?ceil\>" conceal cchar=⌈
syntax match pyFancyOperator "\<\%(\%(math\|np\|numpy\)\.\)\?floor\>" conceal cchar=⌊
syntax match pyFancyOperator " \* " conceal cchar=∙
syntax match pyFancyOperator " / " conceal cchar=÷
syntax match pyFancyOperator "\( \|\)\*\*\( \|\)2\>" conceal cchar=²
syntax match pyFancyOperator "\( \|\)\*\*\( \|\)3\>" conceal cchar=³
syntax match pyFancyOperator "\( \|\)\*\*\( \|\)n\>" conceal cchar=ⁿ

syntax keyword pyFancyStatement int conceal cchar=ℤ
syntax keyword pyFancyStatement float conceal cchar=ℝ
syntax keyword pyFancyStatement complex conceal cchar=ℂ
syntax keyword pyFancyStatement lambda conceal cchar=λ
syntax keyword pyFancyOperator in conceal cchar=∈
syntax keyword pyFancyOperator or conceal cchar=∨
syntax keyword pyFancyOperator and conceal cchar=∧
syntax keyword pyFancySpecial True  conceal cchar=𝐓
syntax keyword pyFancySpecial False conceal cchar=𝐅
syntax keyword pyFancySpecial bool conceal cchar=𝔹

syntax keyword pyFancyOperator sum conceal cchar=∑
syntax keyword pyFancyBuiltin all conceal cchar=∀
syntax keyword pyFancyBuiltin any conceal cchar=∃
syntax keyword pyFancyBuiltin not conceal cchar=¬

hi link pyFancyStatement Statement
hi link pyFancyKeyword Keyword
hi link pyFancyBuiltin Builtin
hi link pyFancySpecial Keyword
hi link pyFancyOperator Operator

hi! link Conceal Operator

setlocal conceallevel=1
