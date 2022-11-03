local api = vim.api
-- default sources
local sources = {
    { name = "nvim_lsp", priority = 9 },
    { name = "luasnip", priority = 8 },
    -- { name = "neorg", priority = 6 },
    { name = "nvim_lsp_signature_help", priority = 10 },

    { name = "path" },
    {
        name = "buffer",
        options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end,
        },
    },
    { name = "nvim_lua" },
}
local filetype = {
    sql = function()
        table.insert(sources, { name = "vim-dadbod-completion" })
    end,
    norg = function()
        table.insert(sources, { name = "latex_symbols" })
    end,
    markdown = function()
        table.insert(sources, { name = "latex_symbols" })
    end,
}

if filetype[vim.bo.ft] then
    filetype[vim.bo.ft]()
end

for _, source in pairs(require("modules.completion.cmp.options")) do
    if source.enable then
        table.insert(sources, source.options)
    end
end

return sources
