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
    -- { name = "path", priority = 5 },
    -- { name = "calc", priority = 4 },
    -- { name = "cmdline", priority = 4 },
    { name = "neorg", priority = 6 },
    { name = "cmp_tabnine", keyword_length = 0, priority = 8 },
    -- { name = "treesitter", keyword_length = 2 },
    -- { name = "spell" },
    -- { name = "look", keyword_length = 2 },
    { name = "treesitter", keyword_length = 2 },
}
if vim.o.ft == "sql" then
    table.insert(sources, { name = "vim-dadbod-completion" })
end

if vim.o.ft == "norg" then
    table.insert(sources, { name = "latex_symbols" })
end
if vim.o.ft == "markdown" then
    table.insert(sources, { name = "spell" })
    table.insert(sources, { name = "look" })
    table.insert(sources, { name = "latex_symbols" })
end
if vim.o.ft == "gitcommit" then
    vim.cmd([[packadd cmp-git]])
    require("cmp_git").setup()
    table.insert(sources, { name = "cmp_git" })
end
if vim.o.ft == "lua" then
    table.insert(sources, { name = "nvim_lua" })
end
if vim.o.ft == "zsh" or vim.o.ft == "sh" or vim.o.ft == "fish" or vim.o.ft == "proto" then
    table.insert(sources, { name = "path" })
    table.insert(sources, { name = "calc" })
end

return sources
