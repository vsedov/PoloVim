local options = {
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smarttab = true,
    conceallevel = 2,
    colorcolumn = "130",
    foldmethod = "syntax",
}

for k, v in pairs(options) do
    vim.o[k] = v
end

local switch_definitions = [[
  let b:switch_custom_definitions = [
    {
      'print\s\+\(.*\)': 'print(\1)',
      'print(\([^)]*\))': 'print \1',
      'is\s\(not\)\@!': 'is not ',
      'is\snot': 'is',
    }
  ]
]]
vim.cmd(switch_definitions:gsub("\n", ""))

local success, wk = pcall(require, "which-key")
if not success then
    return
end

wk.register({
    ["<leader>2"] = { '0/TODO<cr><cmd>nohlsearch<cr>"_c4l', "Replace next TODO" },
    ["[i"] = { "?def __init__<cr><cmd>nohlsearch<cr>", "Goto previous __init__" },
    ["]i"] = { "/def __init__<cr><cmd>nohlsearch<cr>", "Goto next __init__" },
}, { buffer = vim.api.nvim_get_current_buf() })

vim.g.magma_automatically_open_output = false
vim.g.magma_image_provider = "kitty"
