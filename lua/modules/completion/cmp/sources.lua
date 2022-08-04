local sources = {
    { name = "nvim_lsp_signature_help", priority = 10 },
    { name = "nvim_lsp", priority = 9 },
    { name = "luasnip", priority = 8 },
    {
        name = "buffer",
        priority = 7,
        keyword_length = 4,
        options = {
            get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
            end,
        },
    },
    { name = "path", priority = 5 },
    { name = "calc", priority = 4 },
    { name = "neorg", priority = 6 },

    -- { name = "treesitter", keyword_length = 2 },
    -- { name = "spell" },
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
if vim.bo.ft == "gitcommit" then
    vim.cmd([[packadd cmp-git]])
    require("cmp_git").setup()
    table.insert(sources, { name = "cmp_git" })
end
if vim.bo.ft == "lua" then
    table.insert(sources, { name = "nvim_lua" })
end
return sources
