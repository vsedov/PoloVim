local user = {}
local conf = require("modules.user.config")


user["max397574/tomato.nvim"]={
	opt = true,
	config = function()
		require("tomato").setup()
	end
}
return user
