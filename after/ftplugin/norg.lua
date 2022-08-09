-- https://github.com/max397574/NeovimConfig/blob/master/clipboard_neorg.vim
vim.o.shiftwidth = 2
vim.o.conceallevel = 2
vim.o.concealcursor = "nv"

vim.bo.commentstring = "#%s"
vim.cmd([[source ~/.config/nvim/clipboard_neorg.vim]])
vim.cmd([[packadd nvim-treesitter]])

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

-- little auto gtd workspace changer to put into after/ftplugin/norg.lua until it gets implemented. works just fine for me
local dirman = require("neorg.modules.core.norg.dirman.module")
local gtd = require("neorg.modules.core.gtd.base.module")
local function physical_workspace()
    return dirman.public.get_current_workspace()[1]
end
local function change_gtd_workspace()
    gtd.config.public["workspace"] = physical_workspace()
end
local function reload_gtd()
    return neorg.modules.load_module("core.gtd.base")
end
change_gtd_workspace()
reload_gtd()
