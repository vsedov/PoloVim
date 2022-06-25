local cmp = require("cmp")
require("modules.completion.snippets")
require("modules.completion.cmp.ui_overwrite")

cmp.setup(require("modules.completion.cmp.config"))
require("modules.completion.cmp.extra")
