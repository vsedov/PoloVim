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

require("modules.completion.cmp.extra")
