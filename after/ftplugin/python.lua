vim.treesitter.start()
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
vim.cmd([[
filetype plugin on
setlocal include=^\\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
]])
local keys = {
    {
        "<M-CR>",
        function()
            require("python_import.api").add_import_current_word_and_notify()
        end,
        mode = { "i", "n" },
        silent = true,
        desc = "Add python import",
        ft = "python",
    },
    {
        "<M-CR>",
        function()
            require("python_import.api").add_import_current_selection_and_notify()
        end,
        mode = "x",
        silent = true,
        desc = "Add python import",
        ft = "python",
    },
    {
        "<space>i",
        function()
            require("python_import.api").add_import_current_word_and_move_cursor()
        end,
        mode = "n",
        silent = true,
        desc = "Add python import and move cursor",
        ft = "python",
    },
    {
        "<space>i",
        function()
            require("python_import.api").add_import_current_selection_and_move_cursor()
        end,
        mode = "x",
        silent = true,
        desc = "Add python import and move cursor",
        ft = "python",
    },
    {
        "<space>tr",
        function()
            require("python_import.api").add_rich_traceback()
        end,
        silent = true,
        desc = "Add rich traceback",
        ft = "python",
        mode = { "n", "x" },
    },
}

for _, key in ipairs(keys) do
    vim.keymap.set(key.mode, key[1], key[2], {
        silent = key.silent,
        desc = key.desc,
        buffer = 0,
        expr = key.expr,
        remap = key.remap,
    })
end
