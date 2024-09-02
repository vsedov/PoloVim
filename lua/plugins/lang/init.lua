--
-- -- -- Inline functions dont seem to work .
-- lang({
--     "ThePrimeagen/refactoring.nvim",
--     lazy = true,
--     dependencies = {
--         { "nvim-lua/plenary.nvim" },
--         { "nvim-treesitter/nvim-treesitter" },
--     },
--     config = conf.refactor,
-- })
--
-- -- -- -- -- OPTIM(vsedov) (01:01:25 - 14/08/22): If this gets used more, i will load this
-- -- -- -- on startup, using lazy.lua
-- lang({
--     "andrewferrier/debugprint.nvim",
--     lazy = true,
--     keys = {
--         { "g?p", mode = "n" },
--         { "g?P", mode = "n" },
--         { "g?v", mode = "n" },
--         { "g?V", mode = "n" },
--         { "g?l", mode = "n" },
--         { "g?L", mode = "n" },
--         { "g?V", mode = "v" },
--         { "g?v", mode = "v" },
--         { "g?o", mode = "x" },
--         { "g?O", mode = "x" },
--     },
--     cmd = "DeleteDebugPrints",
--     config = true,
-- })

-- lang({ "yardnsm/vim-import-cost", cmd = "ImportCost", config = true })
-- lang({ "nanotee/luv-vimdocs", ft = "lua" })
-- lang({ "milisims/nvim-luaref", ft = "lua" })

-- lang({
--     "Weissle/persistent-breakpoints.nvim",
--     lazy = true,
--     config = true,
-- })
--
-- lang({
--     "mfussenegger/nvim-dap",
--     lazy = true,
--     dependencies = {
--         {
--             "rcarriga/nvim-dap-ui",
--             lazy = true,
--             opts = {},
--             config = function(_, opts)
--                 -- setup dap config by vscode launch.json file
--                 -- require("dap.ext.vscode").load_launchjs()
--                 local dap = require("dap")
--                 local dapui = require("dapui")
--                 dapui.setup(opts)
--                 dap.listeners.after.event_initialized["dapui_config"] = function()
--                     dapui.open({})
--                 end
--                 dap.listeners.before.event_terminated["dapui_config"] = function()
--                     dapui.close({})
--                 end
--                 dap.listeners.before.event_exited["dapui_config"] = function()
--                     dapui.close({})
--                 end
--             end,
--         },
--         {
--             "thehamsta/nvim-dap-virtual-text",
--             lazy = true,
--             opts = {
--                 enabled = true, -- enable this plugin (the default)
--             },
--         },
--         { "liadoz/nvim-dap-repl-highlights", config = true, lazy = true },
--         { "ofirgall/goto-breakpoints.nvim", lazy = true },
--         { "rcarriga/cmp-dap" },
--         {
--             "jay-babu/mason-nvim-dap.nvim",
--
--             dependencies = "mason.nvim",
--             lazy = true,
--             cmd = { "dapinstall", "dapuninstall" },
--             opts = {
--                 -- makes a best effort to setup the various debuggers with
--                 -- reasonable debug configurations
--                 automatic_installation = true,
--
--                 -- you can provide additional configuration to the handlers,
--                 -- see mason-nvim-dap readme for more information
--                 handlers = {},
--
--                 -- you'll need to check that you have the required things installed
--                 -- online, please don't ask me how to install them :)
--                 ensure_installed = {
--                     -- update this to ensure that you have the debuggers for the langs you want
--                     "debugpy",
--                 },
--             },
--         },
--     },
--     config = conf.dap_config,
-- })
--