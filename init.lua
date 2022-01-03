require("core")
require("overwrite")

vim.api.nvim_exec(
  [[
augroup dynamic_smartcase
  autocmd!
  autocmd CmdLineEnter :set nosmartcase
  autocmd CmdLineLeave :set smartcase
augroup END
]],
  false
)

-- show cursor line only in active window
vim.cmd([[
  autocmd InsertLeave,WinEnter * set cursorline
  autocmd InsertEnter,WinLeave * set nocursorline
]])

vim.api.nvim_exec(
  [[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost *  lua vim.highlight.on_yank {higroup="IncSearch", timeout=1000}
augroup END
]],
  false
)

-- For now, this is some next level btec fix .
-- vim.api.nvim_exec(
--   [[
-- autocmd BufEnter * silent! lcd %:p:h
-- ]],
--   false
-- )

-- -- Nice ot have for now .
-- vim.cmd([[autocmd! BufWinEnter COMMIT_EDITMSG set filetype=gitcommit]], false)
-- vim.cmd([[autocmd! BufWinEnter *.cpp set filetype=cpp]], false)
-- -- cmd [[autocmd! BufWritePost *.lua !stylua %]]

-- -- windows to close with "q"
-- vim.cmd(
--   [[autocmd FileType help,startuptime,qf,lspinfo nnoremap <buffer><silent> q :close<CR>]]
-- )
-- vim.cmd([[autocmd FileType man nnoremap <buffer><silent> q :quit<CR>]])

-- vim.cmd([[au FocusGained * :checktime]])

-- vim.cmd(
--   "autocmd User TelescopeFindPre lua vim.opt.laststatus=0; vim.cmd[[autocmd BufWinLeave * ++once lua vim.opt.laststatus=2]]"
-- )
