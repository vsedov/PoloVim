local cmp = require("cmp")
cmp.setup(require("modules.completion.cmp.config"))

cmp.mapping(function()
    if cmp.get_active_entry() then
        cmp.confirm()
    else
        require("ultimate-autopair.maps.cr").cmpnewline()
    end
end)

lambda.highlight.plugin("Cmp", {
    { CmpItemKindVariable = { link = "Variable" } },
    { CmpItemAbbrMatchFuzzy = { inherit = "comment", italic = true } },
    { CmpItemAbbrDeprecated = { strikethrough = true, inherit = "Comment" } },
    { CmpItemMenu = { inherit = "Comment", italic = true } },
})

cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "cmdline" },
        { name = "cmdline_history" },
    }),
})

require("modules.completion.cmp.extra")
cmp.setup.cmdline(":", {
    -- mapping = cmp.mapping.preset.cmdline(),
    completion = { completeopt = "menu,menuone,noselect" },
    sources = cmp.config.sources({
        { { name = "path" } },
        { { name = "cmdline" } },
    }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    completion = { completeopt = "menu,menuone,noselect" },
    sources = {
        { name = "buffer" },
    },
})

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
