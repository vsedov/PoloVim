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

-- your plugin config
return useless
