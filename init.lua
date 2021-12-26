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


vim.api.nvim_exec(
  [[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost *  lua vim.highlight.on_yank {higroup="IncSearch", timeout=1000}
augroup END
]],
  false
)

-- vim.api.nvim_exec(
--   [[
-- augroup AutoSaveFolds | autocmd!
--   autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
--   autocmd BufWinEnter ?* silent! loadview
-- augroup END

-- ]],
--   false
-- )
