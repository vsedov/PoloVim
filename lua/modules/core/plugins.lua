-- local core = {}
local conf = require("modules.core.config")
local package = require("core.pack").package

package({ "nvim-lua/plenary.nvim", module = "plenary" })

package({ "mjlbach/projects.nvim", after = "nvim-lspconfig", config = conf.projects })

-- return core
