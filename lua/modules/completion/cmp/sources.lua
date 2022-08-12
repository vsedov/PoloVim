local sources =
    {
        { name = "nvim_lsp_signature_help", priority = 10 },

        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "cmp_tabnine", priority = 8 },
    }, {
        {
            name = "buffer",
            options = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(api.nvim_list_wins()) do
                        bufs[api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
            },
        },
        { name = "spell" },
        { name = "neorg", priority = 6 },
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
