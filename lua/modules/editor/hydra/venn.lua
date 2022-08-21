local Hydra = require("hydra")

local hint = [[
 Arrow^^^^^^   Select region with <C-v>
 ^ ^ _<up>_ ^ ^   _f_: surround it with box
 _<left>_ ^ ^ _<right>_
 ^ ^ _<down>_ ^ ^           _<Esc>_
]]

Hydra({
    name = "Draw Diagram",
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom",
            border = "single",
        },

        on_enter = function()
            vim.cmd([[packadd venn.nvim]])
            vim.o.virtualedit = "all"
            local venn_enabled = vim.inspect(vim.b.venn_enabled)
            if venn_enabled == "nil" then
                vim.b.venn_enabled = true
                vim.cmd([[setlocal ve=all]])
            end
        end,
        on_exit = function()
            vim.cmd([[setlocal ve=]])
            vim.cmd([[mapclear <buffer>]])
            vim.b.venn_enabled = nil
        end,
    },
    mode = "n",
    body = "<localleader>ve",
    heads = {
        { "<left>", "<C-v>h:VBox<CR>" },
        { "<down>", "<C-v>j:VBox<CR>" },
        { "<up>", "<C-v>k:VBox<CR>" },
        { "<right>", "<C-v>l:VBox<CR>" },
        { "f", ":VBox<CR>", { mode = "v" } },
        { "<Esc>", nil, { exit = true } },
    },
})
