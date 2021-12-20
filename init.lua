-- Load Modules:
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




-- after everythign i called call utest runner
vim.api.nvim_exec(
	[[
augroup UltestRunner
    au!
    au BufWritePost * UltestNearest
augroup END
]],
	false
)

vim.api.nvim_exec(
	[[
augroup matchup_matchparen_highlight
    autocmd!
    autocmd ColorScheme * hi MatchParen guifg=purple
augroup END
]],
	false
)

vim.api.nvim_exec(
	[[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost *  lua vim.highlight.on_yank {higroup="IncSearch", timeout=1000}
augroup END
]],
	false
)

vim.api.nvim_exec(
	[[
augroup AutoSaveFolds | autocmd!
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup END

]],
	false
)

vim.api.nvim_exec(
	[[
augroup pythondebug
  autocmd!
  autocmd FileType python map <buffer> <Leader><C-S> :update<CR>:exec '!python' shellescape(@%, 1)<CR>
  autocmd FileType python map <buffer> <Leader>dk :update<CR>:sp term://python -m pdb %<CR>
augroup END
]],
	false
)

