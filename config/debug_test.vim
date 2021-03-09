
let test#strategy = "floaterm"
let test#python#pytest#options = "--disable-warnings --color=yes"

let g:ultest_virtual_text = 1
let g:ultest_output_cols = 120
let g:ultest_max_threads = 5

let test#python#runner = 'pytest'
nmap <silent> t<C-d> :call DebugNearest()<CR>

" Testing functions
nmap <silent><leader>tn :TestNearest<CR>
nmap <silent><leader>tf :TestFile<CR>
nmap <silent><leader>tt :TestSuite<CR>
nmap <silent><leader>tl :TestLast<CR>
nmap <silent><leader>tv :TestVisit<CR>
nmap <silent><leader>tm :make test<CR>
nmap <silent><leader>to :!firefox coverage/index.html<CR>



nmap <leader>vf <Plug>(ultest-run-file)
nmap <leader>vn <Plug>(ultest-run-nearest)
nmap <leader>vj <Plug>(ultest-next-fail)
nmap <leader>vk <Plug>(ultest-prev-fail)
nmap <leader>vg <Plug>(ultest-output-jump)
nmap <leader>vo <Plug>(ultest-output-show)
nmap <leader>vs <Plug>(ultest-summary-toggle)
nmap <leader>vS <Plug>(ultest-summary-jump)
nmap <leader>va <Plug>(ultest-attach)
nmap <leader>vc <Plug>(ultest-stop-nearest)
nmap <leader>vx <Plug>(ultest-stop-file)


inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files --hidden')
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})
inoremap <expr> <c-x><c-l> fzf#vim#complete#line()
