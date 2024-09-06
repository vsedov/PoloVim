local conf = require("plugins.completion.config")

-- ----
conf.cmp()
conf.luasnip()
conf.snippet()
conf.neotab()
conf.autopair()
require'luasnip-latex-snippets'.setup()
require("luasnip").config.setup { enable_autosnippets = true }
