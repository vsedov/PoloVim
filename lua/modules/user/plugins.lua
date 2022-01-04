local user = {}
local conf = require("modules.user.config")

user["~/GitHub/ytmmusic.lua"] = {
  opt = true,
  require = { "rcarriga/nvim-notify", "nvim-lua/plenary.nvim" },
  config = function()
    require("ytmmusic")
  end,
}

-- user["Willy-JL/nvim-cursorline"]={
-- opt = true,
-- -- require = {"xiyaowong/nvim-cursorword"},
-- event = "BufWinEnter",

-- }
-- your plugin config
return user
