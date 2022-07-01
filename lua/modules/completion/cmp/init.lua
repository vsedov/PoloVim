local cmp = require("cmp")
require("modules.completion.snippets")
require("modules.completion.cmp.ui_overwrite")

cmp.setup(require("modules.completion.cmp.config"))
cmp.setup.cmdline(":", {
    sources = {
        { name = "cmdline", group_index = 1 },
    },
})

require("modules.completion.cmp.extra")
