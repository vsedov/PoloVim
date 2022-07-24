vim.g.navic_silence = true
vim.cmd("autocmd BufRead,BufNewFile *.jl set filetype=julia")
vim.cmd("autocmd BufRead,BufNewFile *.jl let g:did_load_filetypes=1")
vim.cmd("autocmd BufRead,BufNewFile *.jl let g:do_filetype_lua=0")

local options = {
    textwidth = 92,
    expandtab = true,
    smarttab = true,
}

for k, v in pairs(options) do
    vim.o[k] = v
end
