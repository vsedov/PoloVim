
function! LoadJavaContent(uri)
     setfiletype java
     let content = CocRequest('java', 'java/classFileContents', {'uri': 'jdt:/' . a:uri})
     call setline(1, split(content, "\n"))
     setl nomod
     setl readonly
endfunction
autocmd! BufReadPre,BufReadCmd,FileReadCmd,SourceCmd *.class call LoadJavaContent(expand("<amatch>"))<CR>



