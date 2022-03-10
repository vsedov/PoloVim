local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
-- local map_args = bind.map_args

local loader = require("packer").loader
local K = {}
local function check_back_space()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

if vim.bo.filetype == "lua" then
    local luakeys = {
        [{ "n", "<Leader><Leader>r" }] = map_cmd("v:lua.run_or_test()"):with_expr(),
        [{ "v", "<Leader><Leader>r" }] = map_cmd("v:lua.run_or_test()"):with_expr(),
        [{ "n", "<F5>" }] = map_cmd("v:lua.run_or_test(v:true)"):with_expr(),
    }
    bind.nvim_load_mapping(luakeys)
end

local keys = {
    --
    [{ "n", "<Leader>tc" }] = map_cu("Clap colors"):with_noremap():with_silent(),
    [{ "n", "<Leader>bB" }] = map_cu("Clap buffers"):with_noremap():with_silent(),
    [{ "n", "<localleader>ff" }] = map_cu("Clap grep"):with_noremap():with_silent(),
    [{ "n", "<localleader>fb" }] = map_cu("Clap marks"):with_noremap():with_silent(),
    [{ "n", "<C-x><C-f>" }] = map_cu("Clap filer"):with_noremap():with_silent(),
    [{ "n", "<Leader>fF" }] = map_cu("Clap files ++finder=rg --ignore --hidden --files"):with_noremap():with_silent(),
    -- [{"n", "<M-g>"] = map_cu("Clap gfiles"):with_noremap():with_silent(),
    [{ "n", "<M-h>" }] = map_cu("Clap history"):with_noremap():with_silent(),

    [{ "n", "<Leader>fq" }] = map_cu("Clap grep ++query=<cword>"):with_noremap():with_silent(),

    [{ "n", "<Leader>fW" }] = map_cu("Clap windows"):with_noremap():with_silent(),
    -- [{"n", "<Leader>fl"] = map_cu("Clap loclist"):with_noremap():with_silent(),
    [{ "n", "<Leader>gd" }] = map_cu("Clap git_diff_files"):with_noremap():with_silent(),
    [{ "n", "<Leader>fv" }] = map_cu("Clap grep ++query=@visual"):with_noremap():with_silent(),

    -- Might use telescope ?
    [{ "n", "<Leader>fh" }] = map_cu("Clap command_history"):with_noremap():with_silent(),

    [{ "n", "<Leader>di" }] = map_cr("<cmd>lua require'dap.ui.variables'.hover()"):with_expr(),
    [{ "n", "<Leader>dw" }] = map_cr("<cmd>lua require'dap.ui.widgets'.hover()"):with_expr(), -- TODO: another key?
    [{ "v", "<Leader>di" }] = map_cr("<cmd>lua require'dap.ui.variables'.visual_hover()"):with_expr(),

    [{ "n", "<Leader><Leader>s" }] = map_cr("SplitjoinSplit"),
    [{ "n", "<Leader><Leader>j" }] = map_cr("SplitjoinJoin"),

    -- Plugin Vista
    [{ "n", "<Leader>v]" }] = map_cu("Vista!!"):with_noremap():with_silent(),

    -- clap --
    -- ["n", "<localleader-C>"] = map_cu("Clap | startinsert"),
    -- ["i", "<localleader-C>"] = map_cu("Clap | startinsert"):with_noremap():with_silent(),

    [{ "n", "<Leader>df" }] = map_cu("Clap dumb_jump ++query=<cword> | startinsert"),
    -- ["i", "<Leader>df"] = map_cu("Clap dumb_jump ++query=<cword> | startinsert"):with_noremap():with_silent(),

    -- Buffer Line
    [{ "n", "<localleader>bth" }] = map_cr("BDelete hidden"):with_silent():with_nowait():with_noremap(),
    [{ "n", "<localleader>btu" }] = map_cr("BDelete! nameless"):with_silent():with_nowait():with_noremap(),
    [{ "n", "<localleader>btc" }] = map_cr("BDelete! this"):with_silent():with_nowait():with_noremap(),

    [{ "n", "<Leader>b[" }] = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
    [{ "n", "<Leader>b]" }] = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),
    [{ "n", "<localleader>bg" }] = map_cr("BufferLinePick"):with_noremap():with_silent(),

    -- tshit
    [{ "o|m" }] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>"):with_silent(),
    [{ "v|m" }] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>"):with_noremap():with_silent(),

    -- ["n", "<d-f>"] = map_cu("Clap grep ++query=<cword> |  startinsert"),
    [{ "i", "<d-f>" }] = map_cu("Clap grep ++query=<cword> |  startinsert"):with_noremap():with_silent(),
    [{ "i", "<C-df>" }] = map_cu("Clap dumb_jump ++query=<cword> | startinsert"):with_noremap():with_silent(),

    -- Switch from local to Normal for M to test how it tis
    [{ "n", ";a" }] = map_cmd([[<cmd> lua require("harpoon.mark").add_file()<CR>]]):with_noremap(),
    [{ "n", ";n" }] = map_cmd([[<cmd> lua require("harpoon.mark").toggle_file()<CR>]]):with_noremap(),
    [{ "n", ";1" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(1)<CR>]]):with_noremap():with_silent(),
    [{ "n", ";2" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(2)<CR>]]):with_noremap():with_silent(),
    [{ "n", ";3" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(3)<CR>]]):with_noremap():with_silent(),
    [{ "n", ";4" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(4)<CR>]]):with_noremap():with_silent(),
    [{ "n", ";5" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(5)<CR>]]):with_noremap():with_silent(),
    [{ "n", ";6" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(6)<CR>]]):with_noremap():with_silent(),
    [{ "n", ";7" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(7)<CR>]]):with_noremap():with_silent(),
    [{ "n", ";8" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(8)<CR>]]):with_noremap():with_silent(),
    [{ "n", ";9" }] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(9)<CR>]]):with_noremap():with_silent(),

    [{ "n|;t" }] = map_cu([[Telescope harpoon marks]]):with_noremap():with_silent(),
    [{ "n|;;" }] = map_cmd([[<cmd> lua require("harpoon.ui").toggle_quick_menu()<CR>]]):with_noremap():with_silent(),
    [{ "n", "<Leader>n;" }] = map_cmd([[<cmd> lua require('harpoon.cmd-ui').toggle_quick_menu()<Cr>]])
        :with_noremap()
        :with_silent(),

    --- Refactoring
    [{ "v", "<Leader>re" }] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    [{ "v", "<Leader>rf" }] = map_cmd(
        [[<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]]
    )
        :with_noremap()
        :with_silent()
        :with_expr(),
    [{ "v", "<Leader>rv" }] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    [{ "v", "<Leader>ri" }] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    [{ "n", "<Leader>ri" }] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),

    [{ "v", "<Leader>rr" }] = map_cmd([[<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]]):with_noremap(),
    [{ "n", "<Leader>rp" }] = map_cmd([[lua require('refactoring').debug.printf({below = false})<CR>]]):with_noremap(),

    [{ "v", "<Leader>ro" }] = map_cmd([[<cmd> lua require('refactoring').debug.print_var({})<CR>]]):with_noremap(),
    [{ "n", "<Leader>rc" }] = map_cmd([[<cmd> lua require('refactoring').debug.cleanup({})<CR>]]):with_noremap(),

    [{ "v", "<Leader>gs" }] = map_cmd("<cmd>lua require('utils.git').qf_add()<cr>"),
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
    end
    if ft == "go" then
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
    end
end

-- Run DebugOpen and then you run Debug

vim.cmd([[command! -nargs=*  DuckStart lua require"modules.useless.config".launch_duck()]])

-- Load Test Case - it will recognise test file - and you can run Template test and a nice
-- Python test suit
vim.cmd([[command! -nargs=*  TestStart lua require"modules.lang.language_utils".testStart()]])
vim.cmd([[command! -nargs=*  DebugOpen lua require"modules.lang.dap".prepare()]])
vim.cmd([[command! -nargs=*  HpoonClear lua require"harpoon.mark".clear_all()]])
-- Use `git ls-files` for git files, use `find ./ *` for all files under work directory.

-- temp for the time being.
vim.cmd([[command! -nargs=*  Ytmnotify lua require("ytmmusic").notifyCurrentStats()]])

local plugmap = require("keymap").map
local merged = vim.tbl_extend("force", plugmap, keys)

bind.nvim_load_mapping(merged)
local key_maps = bind.all_keys

K.get_keymaps = function()
    local ListView = require("guihua.listview")
    local win = ListView:new({
        loc = "top_center",
        border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
        prompt = true,
        enter = true,
        rect = { height = 20, width = 90 },
        data = key_maps,
    })
end
vim.cmd([[command! -nargs=* Keymaps lua require('overwrite.mapping').get_keymaps()]])
vim.cmd([[command! -nargs=* ColourScheme lua require('utils.telescope').colorscheme()]])
vim.cmd([[
  iabbrev :rev: <c-r>=printf(&commentstring, ' REVISIT '.$USER.' ('.strftime("%d/%m/%y").'):')<CR>
  iabbrev :todo: <c-r>=printf(&commentstring, ' TODO(vsedov):')<CR>
  iabbrev funciton function
]])

-- Use `git ls-files` for git files, use `find ./ *` for all files under work directory.
--
return K
