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

local ts_utils = require("nvim-treesitter.ts_utils")

local toggle_fstring = function()
    local winnr = 0
    local cursor = vim.api.nvim_win_get_cursor(winnr)
    local node = ts_utils.get_node_at_cursor()

    while (node ~= nil) and (node:type() ~= "string") do
        node = node:parent()
    end
    if node == nil then
        print("f-string: not in string node :(")
        return
    end

    local srow, scol, ecol, erow = ts_utils.get_vim_range({ node:range() })
    vim.fn.setcursorcharpos(srow, scol)
    local char = vim.api.nvim_get_current_line():sub(scol, scol)
    local is_fstring = (char == "f")

    if is_fstring then
        vim.cmd("normal mzx")
        -- if cursor is in the same line as text change
        if srow == cursor[1] then
            cursor[2] = cursor[2] - 1 -- negative offset to cursor
        end
    else
        vim.cmd("normal mzif")
        -- if cursor is in the same line as text change
        if srow == cursor[1] then
            cursor[2] = cursor[2] + 1 -- positive offset to cursor
        end
    end
    vim.api.nvim_win_set_cursor(winnr, cursor)
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

local map = vim.keymap.set
map("n", "<Leader>mi", "<cmd>MagmaInit Python3<CR>")
map("n", "<Leader>mr", "<cmd>MagmaEvaluateLine<CR>")
map("x", "<Leader>mr", ":<C-u>MagmaEvaluateVisual<CR>")
map("n", "<Leader>mrr", "<cmd>MagmaReevaluateCell<CR>")
map("n", "<Leader>mo", "<cmd>MagmaShowOutput<CR>")
map("n", "<Leader>moo", "<cmd>MagmaEnterOutput<CR>")
map("n", "<Leader>mc", "<cmd>MagmaInterrupt<CR>")
map("n", "<Leader>mrs", "<cmd>MagmaRestart<CR>")
map("n", "<Leader>mrst", "<cmd>MagmaRestart!<CR>")
map("n", "<Leader>md", "<cmd>MagmaDelete<CR>")
map("n", "<Leader>mq", "<cmd>MagmaDeinit<CR>")
map("n", "<localleader>R", ":up<cr>:echo trim(system('python\"' . expand('%') . '\"'))<cr>")
map("n", "<leader><leader>a", "<cmd>BlockMarkerToggle<cr>")
map("n", ";f", toggle_fstring, { noremap = true })
map("n", "<leader>im", function()
    current_path = vim.fn.expand("%:p")
    vim.fn.system("cd " .. current_path)
    vim.cmd([[NayvyImports]])
end, { noremap = true })

vim.g.magma_automatically_open_output = false
vim.g.magma_image_provider = "kitty"
