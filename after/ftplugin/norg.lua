-- https://github.com/max397574/NeovimConfig/blob/master/clipboard_neorg.vim
vim.bo.shiftwidth = 2
vim.o.conceallevel = 2
vim.bo.commentstring = "#%s"
vim.cmd([[source ~/.config/nvim/clipboard_neorg.vim]])

-- Not sure if this needs to be on or not
-- vim.o.spell = 1

-- wait till norg is fixed

local neorg = require("neorg")
local function load_completion()
    neorg.modules.load_module("core.norg.completion", nil, {
        engine = "nvim-cmp", -- Choose your completion engine here
    })
end

if neorg.is_loaded() then
    load_completion()
else -- Otherwise wait until Neorg gets started and load the completion module then
    neorg.callbacks.on_event("core.started", load_completion)
end
