local useless = {}
local conf = require("modules.useless.config")
-- This needs to be loaded

-- True emotional Support
useless["rtakasuke/vim-neko"] = {
  cmd = "Neko",
  opt = true,
}

-- Call :DuckStart then to stop the duck Call DuckKill
useless["tamton-aquib/duck.nvim"] = {
  opt = true,
}


-- useless["raghavdoescode/nvim-owoifier"] = {
--   cmd = "OWOify",
--   opt = true,
--   run = ":UpdateRemotePlugins",
-- }

-- your plugin config
return useless
