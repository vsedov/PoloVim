-- Load Modules:
local g, o, cmd = vim.g, vim.o, vim.cmd

-- -- Tmux support
g["&t_8f"] = "<Esc>[38;2;%lu;%lu;%lum]"
g["&t_8b"] = "<Esc>[48;2;%lu;%lu;%lum]"

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

vim.api.nvim_command("nnoremap <esc> :noh<return><esc>")
vim.api.nvim_command("nnoremap <esc>^[ <esc>^[")

----------------------------------------------------
----------------------------------------------------
require("core")
----------------------------------------------------
----------------------------------------------------

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
augroup hybrid_line_number
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END
]],
	false
)

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "LspDiagnosticsSignError" })
vim.fn.sign_define("DiagnosticSignWarning", { text = "", texthl = "LspDiagnosticsSignWarning" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "LspDiagnosticsSignInformation" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "LspDiagnosticsSignHint" })

vim.api.nvim_exec(
	[[
    augroup VimStartup
        autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
    augroup END
]],
	false
) -- restore cursor position (" -- mark of last cursor position)

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

vim.api.nvim_exec(
	[[
" Setting FileType:
augroup ensureFileType
  " Make sure all markdown files have the correct filetype set
  au BufRead,BufNewFile *.{md,md.erb,markdown,mdown,mkd,mkdn,txt} set filetype=markdown
  au BufNewFile,BufRead .flake8 set filetype=ini
  au BufNewFile,BufRead cronfile set filetype=sh
  au BufNewFile,BufRead *.{sh,txt,env*,flaskenv} set filetype=sh
  au BufNewFile,BufRead *aliases set filetype=zsh
  au BufNewFile,BufRead *.nix set filetype=nix
  au BufNewFile,BufRead .gitconfig set filetype=conf
  au BufNewFile,BufRead *.conf set filetype=config
  au BufNewFile,BufRead *.{kubeconfig,yml,yaml} set filetype=yaml syntax=on
augroup end
" Generic:
augroup generic
  au Filetype gitcommit setlocal spell textwidth=72
  au FileType git setlocal foldlevel=20  " open all unfolded
  au Filetype vim setlocal tabstop=2 foldmethod=marker
  au FileType *.ya?ml setlocal shiftwidth=2 tabstop=2 softtabstop=2
  au FileType sh,zsh setlocal foldmethod=marker foldlevel=10
  au FileType markdown setlocal wrap wrapmargin=2 textwidth=140 spell
  au FileType lua setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
augroup end
" EdgeDB
augroup edgeql
  au BufNewFile,BufRead *.edgeql setf edgeql
  au BufNewFile,BufRead *.esdl setf edgeql
  au FileType edgeql setlocal commentstring=#%s
augroup end

" Frontend:
augroup frontend
  " HTML
  autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
  autocmd FileType html setlocal foldmethod=syntax nowrap foldlevel=4
  " JSON
  autocmd FileType json setlocal foldmethod=syntax foldlevel=20
  " JS / TS / Vue
  autocmd FileType vue,typescript setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
augroup end
]],
	false
)

vim.api.nvim_exec(
	[[

autocmd CmdlineLeave /,\? lua require('highlight_current_n')['/,?']()
nmap * *N

" Some QOL autocommands
augroup ClearSearchHL
  autocmd!
  " You may only want to see hlsearch /while/ searching, you can automatically
  " toggle hlsearch with the following autocommands
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
  " this will apply similar n|N highlighting to the first search result
  " careful with escaping ? in lua, you may need \\?
  autocmd CmdlineLeave /,\? lua require('highlight_current_n')['/,?']()
augroup END

]],
	false
)
