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
hi def link pythonTodo			Todo

setlocal conceallevel=1



if !exists("python_no_exception_highlight")
  " builtin base exceptions (used mostly as base classes for other exceptions)
  syn keyword pythonExceptions	BaseException Exception
  syn keyword pythonExceptions	ArithmeticError BufferError LookupError
  " builtin exceptions (actually raised)
  syn keyword pythonExceptions	AssertionError AttributeError EOFError
  syn keyword pythonExceptions	FloatingPointError GeneratorExit ImportError
  syn keyword pythonExceptions	IndentationError IndexError KeyError
  syn keyword pythonExceptions	KeyboardInterrupt MemoryError
  syn keyword pythonExceptions	ModuleNotFoundError NameError
  syn keyword pythonExceptions	NotImplementedError OSError OverflowError
  syn keyword pythonExceptions	RecursionError ReferenceError RuntimeError
  syn keyword pythonExceptions	StopAsyncIteration StopIteration SyntaxError
  syn keyword pythonExceptions	SystemError SystemExit TabError TypeError
  syn keyword pythonExceptions	UnboundLocalError UnicodeDecodeError
  syn keyword pythonExceptions	UnicodeEncodeError UnicodeError
  syn keyword pythonExceptions	UnicodeTranslateError ValueError
  syn keyword pythonExceptions	ZeroDivisionError
  " builtin exception aliases for OSError
  syn keyword pythonExceptions	EnvironmentError IOError WindowsError
  " builtin OS exceptions in Python 3
  syn keyword pythonExceptions	BlockingIOError BrokenPipeError
  syn keyword pythonExceptions	ChildProcessError ConnectionAbortedError
  syn keyword pythonExceptions	ConnectionError ConnectionRefusedError
  syn keyword pythonExceptions	ConnectionResetError FileExistsError
  syn keyword pythonExceptions	FileNotFoundError InterruptedError
  syn keyword pythonExceptions	IsADirectoryError NotADirectoryError
  syn keyword pythonExceptions	PermissionError ProcessLookupError TimeoutError
  " builtin warnings
  syn keyword pythonExceptions	BytesWarning DeprecationWarning FutureWarning
  syn keyword pythonExceptions	ImportWarning PendingDeprecationWarning
  syn keyword pythonExceptions	ResourceWarning RuntimeWarning
  syn keyword pythonExceptions	SyntaxWarning UnicodeWarning
  syn keyword pythonExceptions	UserWarning Warning
endif

if exists("python_space_error_highlight")
  " trailing whitespace
  syn match   pythonSpaceError	display excludenl "\s\+$"
  " mixed tabs and spaces
  syn match   pythonSpaceError	display " \+\t"
  syn match   pythonSpaceError	display "\t\+ "
endif


" Do not spell doctests inside strings.
" Notice that the end of a string, either ''', or """, will end the contained
" doctest too.  Thus, we do *not* need to have it as an end pattern.
if !exists("python_no_doctest_highlight")
  if !exists("python_no_doctest_code_highlight")
    syn region pythonDoctest
	  \ start="^\s*>>>\s" end="^\s*$"
	  \ contained contains=ALLBUT,pythonDoctest,pythonFunction,@Spell
    syn region pythonDoctestValue
	  \ start=+^\s*\%(>>>\s\|\.\.\.\s\|"""\|'''\)\@!\S\++ end="$"
	  \ contained
  else
    syn region pythonDoctest
	  \ start="^\s*>>>" end="^\s*$"
	  \ contained contains=@NoSpell
  endif
endif
let b:current_syntax = "python"
" vim:set sw=2 sts=2 ts=8 noet:
