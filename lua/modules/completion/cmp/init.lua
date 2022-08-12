local cmp = require("cmp")

require("modules.completion.snippets")

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
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
--     { name = 'cmdline_history' },
--     { name = 'path' },
--   }),
-- })

require("modules.completion.cmp.extra")
require("modules.completion.cmp.ui_overwrite")
