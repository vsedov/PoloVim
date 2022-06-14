local user = {}
local conf = require("modules.user.config")
local package = require("core.pack").package
package({
    "max397574/tomato.nvim",
    opt = true,
    config = function()
        require("tomato").setup()
    end,
})
-- return user
