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
    "andrewferrier/debugprint.nvim",
    config = function()
        -- use icecream for python debugging
        local python = {
            left = 'ic("',
            right = '")',
            mid_var = "{",
            right_var = '}")',
        }
        require("debugprint").setup({
            create_keymaps = false,
        })

        vim.keymap.set("n", "dQP", function()
            require("debugprint").debugprint({ above = true })
        end, { desc = "Debug print above" })
        vim.keymap.set("n", "dQp", function()
            require("debugprint").debugprint()
        end, { desc = "Debug print" })

        vim.keymap.set("n", "dqp", function()
            require("debugprint").debugprint({ variable = true })
        end, { desc = "debug print variable" })
        vim.keymap.set("n", "dqP", function()
            require("debugprint").debugprint({ above = true, variable = true })
        end, { desc = "Debug print var above" })

        vim.keymap.set("n", "dql", function()
            require("debugprint").debugprint({ ignore_treesitter = true, variable = true })
        end, { desc = "debug print var" })
        vim.keymap.set("n", "dqL", function()
            require("debugprint").debugprint({ ignore_treesitter = true, above = true, variable = true })
        end, { desc = "debug print var above" })
    end,
    opt = true,
    keys = {
        "dQP",
        "dQp",
        "dqp",
        "dqP",
        "dql",
        "dqL",
    },
})
