require("core")

vim.cmd([[
function! Vtip()
  echomsg system('curl -s -m 3 https://vtip.43z.one')
endfunction
noremap ,v :call Vtip()<CR>
]])
