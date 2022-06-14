local conf = require("modules.user.config")
local user = require("core.pack").package
user({
    "max397574/tomato.nvim",
    opt = true,
    config = function()
        require("tomato").setup()
    end,
})
