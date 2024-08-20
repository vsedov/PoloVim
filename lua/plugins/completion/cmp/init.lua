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
require("cmdline")({
    window = {
        matchFuzzy = true,
        offset = 1, -- depending on 'cmdheight' you might need to offset
        debounceMs = 10,
    },

    hl = {
        default = "Pmenu",
        selection = "PmenuSel",
        directory = "Directory",
        substr = "LineNr",
    },

    column = {
        maxNumber = 6,
        minWidth = 20,
    },

    binds = {
        next = "<Tab>",
        back = "<S-Tab>",
    },
})
