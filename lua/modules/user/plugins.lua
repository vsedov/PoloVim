local user = {}
local conf = require("modules.user.config")

user["~/GitHub/ytmmusic.lua"] = {
  opt = true,
  require = { "rcarriga/nvim-notify", "nvim-lua/plenary.nvim" },
  config = function()
    require("ytmmusic")
  end,
}

user["nanotee/luv-vimdocs"] = {
  opt = true,
  ft = { "lua" },
}
-- builtin lua functions
user["milisims/nvim-luaref"] = {
  opt = true,
  ft = { "lua" },
}

-- your plugin config
return user
