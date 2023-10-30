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

require("modules.completion.cmp.extra")
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
        {
            name = "buffer",
            keyword_length = 3,
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
            },
        },
    }),
})
