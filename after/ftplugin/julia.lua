vim.g.navic_silence = true

local options = {
    textwidth = 92,
    expandtab = true,
    smarttab = true,
}

for k, v in pairs(options) do
    vim.o[k] = v
end
