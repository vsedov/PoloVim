local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
-- local map_args = bind.map_args
local loader = require("packer").loader
local K = {}

--- @usage : Run :cd or <leader>cd -> <leader>r
---@param debug Debug is idk , idk why i have this here tbh
local run_or_test = function(debug)
    local ft = vim.bo.filetype
    -- t([[<cmd>tcd %:p:h<cr><cmd>pwd<cr>]])
    if ft == "lua" then
        return ":Jaq internal<CR>"
    else
        return ":Jaq<CR>"
    end
end
local keys = { --
    ["n|<leader>R"] = map_cmd(run_or_test, "jaq run"):with_expr(),
    ["n|<F6>"] = map_cu("Jaq quickfix", "jaq run"):with_noremap():with_silent(),

    ["n|;a"] = map_cmd([[<cmd> lua require("harpoon.mark").add_file()<CR>]], "Harppon Add file"):with_noremap(),
    ["n|;n"] = map_cmd([[<cmd> lua require("harpoon.mark").toggle_file()<CR>]], "Harpoon Toggle File"):with_noremap(),

    ["n|;1"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(1)<CR>]], "Harpoon Nav file 1")
        :with_noremap()
        :with_silent(),
    ["n|;2"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(2)<CR>]], "Harpoon Nav file 2")
        :with_noremap()
        :with_silent(),
    ["n|;3"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(3)<CR>]], "Harpoon Nav file 3")
        :with_noremap()
        :with_silent(),
    ["n|;4"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(4)<CR>]], "Harpoon Nav file 4")
        :with_noremap()
        :with_silent(),
    ["n|;5"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(5)<CR>]], "Harpoon Nav file 5")
        :with_noremap()
        :with_silent(),
    ["n|;6"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(6)<CR>]], "Harpoon Nav file 6")
        :with_noremap()
        :with_silent(),
    ["n|;7"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(7)<CR>]], "Harpoon Nav file 7")
        :with_noremap()
        :with_silent(),
    ["n|;8"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(8)<CR>]], "Harpoon Nav file 8")
        :with_noremap()
        :with_silent(),
    ["n|;9"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(9)<CR>]], "Harpoon Nav file 9")
        :with_noremap()
        :with_silent(),

    ["n|;t"] = map_cmd([[<cmd>Telescope harpoon marks<cr>]], "Harpoon Marks"):with_noremap():with_silent(),
    ["n|;;"] = map_cmd([[<cmd> lua require("harpoon.ui").toggle_quick_menu()<CR>]], "toggle harpoon ui")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>n;"] = map_cmd([[<cmd> lua require('harpoon.cmd-ui').toggle_quick_menu()<Cr>]], "Harpoon cmd ui")
        :with_noremap()
        :with_silent(),
}

--
vim.cmd([[vnoremap  <leader>y  "+y]])
vim.cmd([[nnoremap  <leader>Y  "+yg_]])
-- vim.cmd([[vnoremap  <M-c>  "+y]])
-- vim.cmd([[nnoremap  <M-c>  "+yg_]])

vim.cmd([[vnoremap  <localleader>c  *+y]])
vim.cmd([[nnoremap  <localleader>c  *+yg_]])
-- No need to use local leader in insert mode
-- vim.cmd([[inoremap  <localleader>v <C-r>*]])

--
bind.nvim_load_mapping(keys)

require("overwrite.cmd")
require("overwrite.autocmd")
