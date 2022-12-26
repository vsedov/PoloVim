local cmp = require("cmp")
cmp.setup(require("modules.completion.cmp.config"))
local search_sources = {
    view = { entries = { name = "custom", selection_order = "near_cursor" } },
    sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
    }, {
        { name = "buffer" },
    }),
}

cmp.setup.cmdline("/", search_sources)
cmp.setup.cmdline("?", search_sources)
-- Regex that triggers on : but not on :q or :w
regex = [[^[:blank:]*(:)[^qw]$]]
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "cmdline", keyword_pattern = [=[^[:blank:]*(:)[^qw]$]=] },
        { name = "cmdline_history" },
        { name = "path" },
    }),
})

-- regex that ignore :q and :w

require("modules.completion.cmp.extra")
require("modules.completion.cmp.ui_overwrite")
