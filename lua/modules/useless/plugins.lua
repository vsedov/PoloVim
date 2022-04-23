local useless = {}
local conf = require("modules.useless.config")
-- This needs to be loaded

-- True emotional Support
useless["rtakasuke/vim-neko"] = {
    cmd = "Neko",
    opt = true,
}
useless["kwakzalver/duckytype.nvim"] = {
    cmd = { "DuckType" },
    opt = true,
    config = conf.duck_type,
}
-- Call :DuckStart then to stop the duck Call DuckKill
useless["tamton-aquib/duck.nvim"] = {
    cmd = { "DuckStart", "DuckKill" },
    opt = true,
    config = conf.launch_duck,
}

-- your plugin config
return useless
