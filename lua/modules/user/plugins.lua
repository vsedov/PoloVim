local user = {}
local conf = require("modules.user.config")

user["~/GitHub/ytmmusic.lua"]={
	require = {"rcarriga/nvim-notify", "nvim-lua/plenary.nvim"},
	config = function()
		require("ytmmusic")
 	end
}



-- your plugin config
return user
