-- https://github.com/max397574/NeovimConfig/blob/master/clipboard_neorg.vim
vim.o.shiftwidth = 2
vim.o.conceallevel = 2
vim.o.concealcursor = "nv"

vim.bo.commentstring = "#%s"
vim.cmd([[source ~/.config/nvim/clipboard_neorg.vim]])
vim.cmd([[ Lazy load nvim-treesitter]])

-- Not sure if this needs to be on or not
-- vim.o.spell = 1

-- wait till norg is fixed

local neorg = require("neorg")
local function load_completion()
    neorg.modules.load_module("core.norg.completion", nil, {
        engine = "nvim-cmp",
    })
end
if neorg.is_loaded() then
    load_completion()
else
    neorg.callbacks.on_event("core.started", load_completion)
end
