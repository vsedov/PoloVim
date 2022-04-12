-- """ Il figure a better way of doing this for now, just a decent way to load modules .
vim.cmd([[command! -nargs=*  PyRepl lua require"modules.lang.language_utils".python_repl()]])

local options = {
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smarttab = true,
    -- colorcolumn = 90, -- Delimit text blocks to N columns
    conceallevel = 2,
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

vim.cmd([[
inoreabbrev <buffer> forr for :<left>
inoreabbrev <buffer> iff if :<left>
]])

local ts_utils = require("nvim-treesitter.ts_utils")

local toggle_fstring = function()
    local winnr = 0
    local cursor = vim.api.nvim_win_get_cursor(winnr)
    local node = ts_utils.get_node_at_cursor()

    while (node ~= nil) and (node:type() ~= "string") do
        node = node:parent()
    end
    if node == nil then
        log:info("f-string: not in string node :(")
        return
    end

    local srow, scol, ecol, erow = ts_utils.get_vim_range({ node:range() })
    vim.fn.setcursorcharpos(srow, scol)
    local char = vim.api.nvim_get_current_line():sub(scol, scol)
    local is_fstring = (char == "f")

    if is_fstring then
        vim.cmd("normal x")
        -- if cursor is in the same line as text change
        if srow == cursor[1] then
            cursor[2] = cursor[2] - 1 -- negative offset to cursor
        end
    else
        vim.cmd("normal if")
        -- if cursor is in the same line as text change
        if srow == cursor[1] then
            cursor[2] = cursor[2] + 1 -- positive offset to cursor
        end
    end
    vim.api.nvim_win_set_cursor(winnr, cursor)
end

vim.keymap.set("n", "F", toggle_fstring, { noremap = true })
