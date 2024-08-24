local cmp = require("cmp")
cmp.setup(require("plugins.completion.cmp.config"))

lambda.highlight.plugin("Cmp", {
    { CmpItemKindVariable = { link = "Variable" } },
    { CmpItemAbbrMatchFuzzy = { inherit = "comment", italic = true } },
    { CmpItemAbbrDeprecated = { strikethrough = true, inherit = "Comment" } },
    { CmpItemMenu = { inherit = "Comment", italic = true } },
})

require("plugins.completion.cmp.extra")

vim.api.nvim_create_autocmd("CmdWinEnter", {
    callback = function()
        require("cmp").close()
    end,
})

cmp.setup.filetype({ "markdown", "pandoc", "text", "latex" }, {
    sources = {
        {
            name = "nvim_lsp",
            keyword_length = 8,
            group_index = 1,
            max_item_count = 20,
        },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
        { name = "dictionary", keyword_length = 2 },
        { name = "latex_symbols" },
    },
})
