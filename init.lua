-- Load Modules:
local g, o, cmd = vim.g, vim.o, vim.cmd


-- Tmux support
g["&t_8f"] = "<Esc>[38;2;%lu;%lu;%lum]"
g["&t_8b"] = "<Esc>[48;2;%lu;%lu;%lum]"


-- Highlight yank'd text after yankin'
cmd([[ augroup YankHighlight ]])
cmd([[  autocmd! ]])
cmd([[  autocmd TextYankPost *  lua vim.highlight.on_yank {higroup="IncSearch", timeout=1000} ]])
cmd([[ augroup END ]])




-- I like relative numbers and the other ones both , so i have this instead .
vim.api.nvim_command('augroup AutoRelativeLineNums')
vim.api.nvim_command('autocmd!')
vim.api.nvim_command('au InsertEnter * set norelativenumber')
vim.api.nvim_command('au InsertLeave * set relativenumber')
vim.api.nvim_command('augroup END')

--Do not use smart case in command line mode
vim.api.nvim_command('augroup dynamic_smartcase')
vim.api.nvim_command('autocmd!')
vim.api.nvim_command('autocmd CmdLineEnter :set nosmartcase')
vim.api.nvim_command('autocmd CmdLineLeave :set smartcase')
vim.api.nvim_command('augroup END')

vim.api.nvim_command('augroup UltestRunner')
vim.api.nvim_command('au!')
vim.api.nvim_command('au BufWritePost * UltestNearest')
vim.api.nvim_command('augroup END')


require("core")
