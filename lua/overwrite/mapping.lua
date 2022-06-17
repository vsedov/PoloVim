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

local keys = { --
    ["n|<Leader>r"] = map_cmd("v:lua.run_or_test()"):with_expr(),
    ["n|<F5>"] = map_cmd("v:lua.run_or_test(v:true)"):with_expr(),
    ["n|<F6>"] = map_cu("Jaq qf"):with_noremap():with_silent(),

    ["n|<Leader>di"] = map_cr("<cmd>lua require'dap.ui.variables'.hover()"):with_expr(),
    ["n|<Leader>dw"] = map_cr("<cmd>lua require'dap.ui.widgets'.hover()"):with_expr(), -- TODO: another key?
    ["v|<Leader>di"] = map_cr("<cmd>lua require'dap.ui.variables'.visual_hover()"):with_expr(),

    -- tshit
    ["o|m"] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>"):with_silent(),
    ["v|M"] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>"):with_noremap():with_silent(),

    ["n|;a"] = map_cmd([[<cmd> lua require("harpoon.mark").add_file()<CR>]]):with_noremap(),
    ["n|;n"] = map_cmd([[<cmd> lua require("harpoon.mark").toggle_file()<CR>]]):with_noremap(),

    ["n|;1"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(1)<CR>]]):with_noremap():with_silent(),
    ["n|;2"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(2)<CR>]]):with_noremap():with_silent(),
    ["n|;3"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(3)<CR>]]):with_noremap():with_silent(),
    ["n|;4"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(4)<CR>]]):with_noremap():with_silent(),
    ["n|;5"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(5)<CR>]]):with_noremap():with_silent(),
    ["n|;6"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(6)<CR>]]):with_noremap():with_silent(),
    ["n|;7"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(7)<CR>]]):with_noremap():with_silent(),
    ["n|;8"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(8)<CR>]]):with_noremap():with_silent(),
    ["n|;9"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(9)<CR>]]):with_noremap():with_silent(),

    ["n|;t"] = map_cmd([[Telescope harpoon marks]]):with_noremap():with_silent(),
    ["n|;;"] = map_cmd([[<cmd> lua require("harpoon.ui").toggle_quick_menu()<CR>]]):with_noremap():with_silent(),
    ["n|<Leader>n;"] = map_cmd([[<cmd> lua require('harpoon.cmd-ui').toggle_quick_menu()<Cr>]])
        :with_noremap()
        :with_silent(),

    --- Refactoring
    ["v|<Leader>re"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["v|<Leader>rf"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["v|<Leader>rv"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["v|<Leader>ri"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["n|<Leader>ri"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),

    ["v|<Leader>rr"] = map_cmd([[<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]]):with_noremap(),
    ["n|<Leader>rp"] = map_cmd([[<cmd>lua require('refactoring').debug.printf({below = false})<CR>]]):with_noremap(),

    ["v|<Leader>ro"] = map_cmd([[<cmd> lua require('refactoring').debug.print_var({})<CR>]]):with_noremap(),
    ["n|<Leader>rc"] = map_cmd([[<cmd> lua require('refactoring').debug.cleanup({})<CR>]]):with_noremap(),

    ["v|<Leader>gs"] = map_cmd("<cmd>lua require('utils.git').qf_add()<cr>"),
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

_G.run_or_test = function(debug)
    local ft = vim.bo.filetype
    local fn = vim.fn.expand("%")
    fn = string.lower(fn)
    if fn == "[nvim-lua]" then
        if not packer_plugins["nvim-luadev"].loaded then
            loader("nvim-luadev")
        end
        return t("<Plug>(Luadev-Run)")
    end
    if ft == "lua" then
        local f = string.find(fn, "spec")
        if f == nil then
            -- let run lua test
            return t("<cmd>luafile %<CR>")
        end
        return t("<Plug>PlenaryTestFile")
    elseif ft == "go" then
        local f = string.find(fn, "test.go")
        if f == nil then
            -- let run lua test
            if debug then
                return t("<cmd>GoDebug <CR>")
            else
                return t("<cmd>GoRun <CR>")
            end
        end

        if debug then
            return t("<cmd>GoDebug nearest<CR>")
        else
            return t("<cmd>GoTestFile <CR>")
        end
    else
        return t("<cmd>Jaq<CR>")
    end
end

require("overwrite.cmd")
require("overwrite.autocmd")
