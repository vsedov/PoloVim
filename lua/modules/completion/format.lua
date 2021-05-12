local lsp = vim.lsp

local function nvim_create_augroup(group_name,definitions)
  vim.api.nvim_command('augroup '..group_name)
  vim.api.nvim_command('autocmd!')
  for _, def in ipairs(definitions) do
    local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
    vim.api.nvim_command(command)
  end
  vim.api.nvim_command('augroup END')
end

