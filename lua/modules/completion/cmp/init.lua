local cmp = require("cmp")
require("modules.completion.snippets")
require("modules.completion.cmp.ui_overwrite")

cmp.setup(require("modules.completion.cmp.config"))
local search_sources = {
    sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
    }, {
        { name = "buffer" },
    }),
}

cmp.setup.cmdline("/", search_sources)
cmp.setup.cmdline("?", search_sources)
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
        { name = "path" },
        { name = "cmdline_history" },
    }),
})
require("modules.completion.cmp.extra")
