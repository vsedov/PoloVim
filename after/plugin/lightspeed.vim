


nnoremap <expr> g/ '/<C-u>\%>'.(col(".")-v:count1).'v\%<'.(col(".")+v:count1).'v'
nnoremap <expr> g? '?<C-u>\%>'.(col(".")-v:count1).'v\%<'.(col(".")+v:count1).'v'