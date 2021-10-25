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

-- Using blugins using hlsearch and some other plugins on teh side .
vim.api.nvim_exec(
	[[
augroup ClearSearchHL
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
  autocmd CmdlineLeave /,\? lua require('highlight_current_n')['/,?']()
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
