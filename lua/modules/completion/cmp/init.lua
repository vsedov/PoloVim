local cmp = require("cmp")
cmp.setup(require("modules.completion.cmp.config"))

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline_history" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" },
            },
        },
    }),
})
cmp.setup.filetype({ "dap-repl", "dapui_watches" }, { sources = { { name = "dap" } } })
-- regex that ignore :q and :w

require("modules.completion.cmp.extra")
lambda.highlight.plugin("Cmp", {
    { CmpItemKindVariable = { link = "Variable" } },
    { CmpItemAbbrMatchFuzzy = { inherit = "CmpItemAbbrMatch", italic = true } },
    { CmpItemAbbrDeprecated = { strikethrough = true, inherit = "Comment" } },
    { CmpItemMenu = { inherit = "Comment", italic = true } },
})
