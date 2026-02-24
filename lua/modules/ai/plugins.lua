local ai = require("core.pack").package
local conf = require("modules.ai.config")
-- ai({

--
--   "zbirenbaum/copilot.lua",
--   event = "InsertEnter",
--   requires = {
--     "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
--     init = function()
--       vim.g.copilot_nes_debounce = 500
--     end,
--   },
--   config = function()
--   require('copilot').setup()
--   end,
-- })

ai({
  "zbirenbaum/copilot.lua",
  requires = {
    "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  },
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({})
  end,
})


