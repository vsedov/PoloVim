local cmp = require("cmp")
cmp.setup(require("modules.completion.cmp.config"))

cmp.setup.filetype({ "dap-repl", "dapui_watches" }, { sources = { { name = "dap" } } })
cmp.mapping(function()
    if cmp.get_active_entry() then
        cmp.confirm()
    else
        require("ultimate-autopair.maps.cr").cmpnewline()
    end
end)

lambda.highlight.plugin("Cmp", {
    { CmpItemKindVariable = { link = "Variable" } },
    { CmpItemAbbrMatchFuzzy = { inherit = "CmpItemAbbrMatch", italic = true } },
    { CmpItemAbbrDeprecated = { strikethrough = true, inherit = "Comment" } },
    { CmpItemMenu = { inherit = "Comment", italic = true } },
})

cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "cmdline" },
        { name = "cmdline_history" },
    }),
})

vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    contents = vim.lsp.util._normalize_markdown(contents, {
        width = vim.lsp.util._make_floating_popup_size(contents, opts),
    })
    print(vim.inspect(contents))

    vim.bo[bufnr].filetype = "markdown"
    vim.treesitter.start(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    return contents
end

require("modules.completion.cmp.extra")
