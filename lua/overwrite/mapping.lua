local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
-- local map_args = bind.map_args
local loader = require("packer").loader
local K = {}
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local run_or_test = function(debug)
    local ft = vim.bo.filetype
    t([[<cmd>tcd %:p:h<cr><cmd>pwd<cr>]])
    if ft == "lua" then
        return ":Jaq internal<CR>"
    else
        return ":Jaq<CR>"
    end
end
local keys = { --
    ["n|<leader>r"] = map_cmd(run_or_test, "jaq run"):with_expr(),
    ["n|<F6>"] = map_cu("Jaq quickfix", "jaq run"):with_noremap():with_silent(),
    ["o|M"] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>", "tsht search"):with_silent(),
    ["v|M"] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>", "tsht search"):with_noremap():with_silent(),

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

    ["n|;t"] = map_cmd([[Telescope harpoon marks]], "Harpoon Marks"):with_noremap():with_silent(),
    ["n|;;"] = map_cmd([[<cmd> lua require("harpoon.ui").toggle_quick_menu()<CR>]], "toggle harpoon ui")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>n;"] = map_cmd([[<cmd> lua require('harpoon.cmd-ui').toggle_quick_menu()<Cr>]], "Harpoon cmd ui")
        :with_noremap()
        :with_silent(),

    --- Refactoring
    ["v|<Leader>re"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], "Refactor Extract Function")
        :with_noremap()
        :with_silent(),

    ["v|<Leader>rf"] = map_cmd(
            [[<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
            "Refactor Extract Function to File"
        )
        :with_noremap()
        :with_silent(),
    ["v|<Leader>rv"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], "Refactor Extract Variable")
        :with_noremap()
        :with_silent(),
    ["v|<Leader>ri"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], "Refactor Inline Variable")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>ri"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], "Refactor Inline Variable")
        :with_noremap()
        :with_silent(),

    ["v|<Leader>rr"] = map_cmd(
        [[<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]],
        "Telescope Refactor"
    ):with_noremap(),
    ["n|<Leader>rp"] = map_cmd([[<cmd>lua require('refactoring').debug.printf({below = false})<CR>]], "Quick debug"):with_noremap(),

    ["v|<Leader>ro"] = map_cmd([[<cmd> lua require('refactoring').debug.print_var({})<CR>]], "quick debug"):with_noremap(),
    ["n|<Leader>rc"] = map_cmd([[<cmd> lua require('refactoring').debug.cleanup({})<CR>]], "debug cleanup"):with_noremap(),

    ["v|<Leader>gs"] = map_cmd("<cmd>lua require('utils.git').qf_add()<cr>", "git utils"),
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
