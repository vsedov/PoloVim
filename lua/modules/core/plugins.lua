local core = {}
local conf = require("modules.core.config")

core["nvim-lua/plenary.nvim"] = {
    module = "plenary",
}

core["mjlbach/projects.nvim"] = {
    after = "nvim-lspconfig",
    config = conf.projects,
}

return core
