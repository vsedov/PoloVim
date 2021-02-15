local api = vim.api
local configs = require 'nvim-treesitter.configs'
local parsers = require 'nvim-treesitter.parsers'

require 'nvim-treesitter.configs'.setup {
    ensure_installed = "all",       -- one of "all", "language", or a list of languages

  
}


-- turn on treesitter folding for supported languages
-- TODO: submit a patch that enables folding as a nvim-treesitter module
local ft_str = ""
local autocmd_fold_str = ""

for _, ft in pairs(parsers.available_parsers()) do
    if (ft == "c_sharp") then
        ft_str = ft_str..'cs'..','
    else
        ft_str = ft_str..ft..','
    end
end

autocmd_fold_str = 'autocmd Filetype '..ft_str..' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()'
api.nvim_command(autocmd_fold_str)


