local Hydra = require("hydra")

local hint = [[
 Arrow^^^^^^   Select region with <C-v> 
 ^ ^ _K_ ^ ^   _f_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
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
        { "H", "<C-v>h:VBox<CR>" },
        { "J", "<C-v>j:VBox<CR>" },
        { "K", "<C-v>k:VBox<CR>" },
        { "L", "<C-v>l:VBox<CR>" },
        { "f", ":VBox<CR>", { mode = "v" } },
        { "<Esc>", nil, { exit = true } },
    },
})
