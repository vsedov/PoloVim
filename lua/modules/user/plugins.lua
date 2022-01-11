local user = {}
local conf = require("modules.user.config")

user["~/GitHub/ytmmusic.lua"] = {
  opt = true,
  require = { "rcarriga/nvim-notify", "nvim-lua/plenary.nvim" },
  config = function()
    require("ytmmusic")
  end,
}

-- your plugin config
return user


-- vim.api.nvim_set_keymap(mode:sub(i, i), keymap, rhs, options) 93
-- vim.api.nvim_set_keymap(mode:sub(i, i), keymap, value, {}) 95
