-- https://github.com/max397574/NeovimConfig/blob/master/clipboard_neorg.vim
vim.o.shiftwidth = 2
vim.o.conceallevel = 2
vim.o.concealcursor = "nv"

vim.bo.commentstring = "#%s"
-- local neorg = require("neorg")
-- local function load_completion()
--     neorg.modules.load_module("core.norg.completion", nil, {
--         engine = "nvim-cmp", -- Choose your completion engine here
--     })
-- end

-- -- If Neorg is loaded already then don't hesitate and load the completion
-- if neorg.is_loaded() then
--     load_completion()
-- else -- Otherwise wait until Neorg gets started and load the completion module then
--     neorg.callbacks.on_event("core.started", load_completion)
-- end
