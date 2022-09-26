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
local function toggle_block_markers()
    local ns_id = vim.api.nvim_create_namespace("bmark")

    if #vim.api.nvim_buf_get_extmarks(0, ns_id, 0, -1, {}) > 0 then
        if lambda.config.lsp.python.toggle_block_master then
            vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
            return
        end
    end

    local language = "python"
    local bufnr = vim.fn.bufnr("%")

    local language_tree = vim.treesitter.get_parser(bufnr, language)
    local syntax_tree = language_tree:parse()
    local root = syntax_tree[1]:root()

    local query_template = "((%s) @capture (#offset! @capture))"
    local params_t = {
        func = { target = "function_definition", marker = string.rep("~", 100) },
        decofunc = { target = "decorated_definition", marker = string.rep("~", 100) },
        class = { target = "class_definition", marker = string.rep("#", 100) },
    }

    for _, params in pairs(params_t) do
        local query = vim.treesitter.parse_query(language, string.format(query_template, params.target))

        for _, _, metadata in query:iter_matches(root, bufnr) do
            line_num = metadata[1].range[1] - 1

            -- make sure there is no text on that line already
            if #vim.filetype.getlines(bufnr, line_num + 1) == 0 then
                local opts = {
                    end_line = line_num,
                    id = line_num,
                    virt_text = { { params.marker, "Comment" } },
                    virt_text_pos = "overlay",
                }

                -- Add virtual line: https://jdhao.github.io/2021/09/09/nvim_use_virtual_text/
                vim.api.nvim_buf_set_extmark(0, ns_id, line_num, 0, opts)
            end
        end
    end
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

lambda.augroup("PythonBlock", {
    {
        -- don't execute silently in case of errors
        event = { "BufWritePost" },
        pattern = "*.py",
        command = function()
            toggle_block_markers()
        end,
    },
})
