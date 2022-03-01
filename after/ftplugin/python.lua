-- " setlocal tabstop=4
-- " setlocal shiftwidth=4
-- " setlocal expandtab
-- " setlocal autoindent
-- " setlocal smarttab
-- " setlocal colorcolumn=90

-- """ Il figure a better way of doing this for now, just a decent way to load modules .
vim.cmd([[command! -nargs=*  PyRepl lua require"modules.lang.language_utils".python_repl()]])

local options = {
  tabstop = 4,
  shiftwidth = 4,
  expandtab = true,
  smarttab = true,
  colorcolumn = 90, -- Delimit text blocks to N columns
}

for k, v in pairs(options) do
  vim.o[k] = v
end

-- Enter the python virtual environment without having sourced the file before entering neovim
if vim.fn.exists("$VIRTUAL_ENV") == 1 then
  vim.g.python3_host_prog = vim.fn.substitute(vim.fn.system("which -a python | head -n2 | tail -n1"), "\n", "", "g")
else
  vim.g.python3_host_prog = vim.fn.substitute(vim.fn.system("which python"), "\n", "", "g")
end
