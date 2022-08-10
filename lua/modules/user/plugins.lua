local conf = require("modules.user.config")
local user = require("core.pack").package

-- True emotional Support
user({ "rtakasuke/vim-neko", cmd = "Neko", opt = true })

-- Competitive programming
-- user {
-- "nullchilly/cpeditor.nvim",
-- opt = true,
-- config = function()
--     require "config.cpeditor"
-- end,
-- setup = function()
--     lazy "cpeditor.nvim"
-- end,
-- }

