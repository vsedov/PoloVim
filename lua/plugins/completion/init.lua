local conf = require("plugins.completion.config")

-- ----
conf.cmp()
conf.luasnip()
require'luasnip-latex-snippets'.setup()
require("luasnip").config.setup { enable_autosnippets = true }
conf.neotab()
conf.autopair()
