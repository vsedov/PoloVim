local sources = {
    -- i Kinda want all of this
    { name = "nvim_lsp_signature_help", priority = 10 },
    { name = "nvim_lsp", priority = 9 },
    { name = "luasnip", priority = 8 },
    -- {
    --     name = "buffer",
    --     priority = 7,
    --     keyword_length = 4,
    --     options = {
    --         get_bufnrs = function()
    --             local buf = vim.api.nvim_get_current_buf()
    --             local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
    --             if byte_size > 1024 * 1024 then -- 1 Megabyte max
    --                 return {}
    --             end
    --
    --             local bufs = {}
    --             for _, win in ipairs(vim.api.nvim_list_wins()) do
    --                 bufs[vim.api.nvim_win_get_buf(win)] = true
    --             end
    --             return vim.tbl_keys(bufs)
    --         end,
    --     },
    -- },
    -- path and treesitter for soem reason was causing lag, which im not sure why .
    -- { name = "path", priority = 5 },
    { name = "calc", priority = 4 },
    { name = "neorg", priority = 6 },
    -- { name = "spell" },

    -- { name = "treesitter", keyword_length = 2 },
    -- { name = "look", keyword_length = 2 },
}
if lambda.config.use_tabnine then
    table.insert(sources, { name = "cmp_tabnine", priority = 8 })
end

if vim.o.ft == "sql" then
    table.insert(sources, { name = "vim-dadbod-completion" })
end

if vim.bo.ft == "norg" then
    table.insert(sources, { name = "latex_symbols" })
end
if vim.bo.ft == "markdown" then
    table.insert(sources, { name = "spell" })
    table.insert(sources, { name = "look" })
    table.insert(sources, { name = "latex_symbols" })
end

if vim.bo.ft == "lua" then
    table.insert(sources, { name = "nvim_lua" })
end
return sources
