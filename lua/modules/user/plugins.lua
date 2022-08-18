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
-- TODO(vsedov) (00:11:22 - 13/08/22): Temp plugin
user({
    event = "BufEnter",
    "vim-scripts/vim-cursorword",
})
