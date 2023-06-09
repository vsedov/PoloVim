local options = {
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smarttab = true,
    conceallevel = 2,
    colorcolumn = "150",
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

vim.g.magma_automatically_open_output = false
vim.g.magma_image_provider = "kitty"
