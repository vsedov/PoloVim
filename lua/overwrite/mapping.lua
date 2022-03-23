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

    ["n|<Leader><Leader>r"] = map_cmd("v:lua.run_or_test()"):with_expr(),
    ["v|<Leader><Leader>r"] = map_cmd("v:lua.run_or_test()"):with_expr(),
    ["n|<F5>"] = map_cmd("v:lua.run_or_test(v:true)"):with_expr(),




    ["n|<Leader>bB"] = map_cu("Clap buffers"):with_noremap():with_silent(),
    ["n|<localleader>ff"] = map_cu("Clap grep"):with_noremap():with_silent(),
    ["n|<localleader>fb"] = map_cu("Clap marks"):with_noremap():with_silent(),
    ["n|<C-x><C-f>"] = map_cu("Clap filer"):with_noremap():with_silent(),
    ["n|<Leader>fF"] = map_cu("Clap files ++finder=rg --ignore --hidden --files"):with_noremap():with_silent(),
    ["n|<Leader>fq"] = map_cu("Clap grep ++query=<cword>"):with_noremap():with_silent(),
    ["n|<Leader>fW"] = map_cu("Clap windows"):with_noremap():with_silent(),
    ["n|<Leader>gd"] = map_cu("Clap git_diff_files"):with_noremap():with_silent(),
    ["n|<Leader>fv"] = map_cu("Clap grep ++query=@visual"):with_noremap():with_silent(),

    -- Might use telescope ?
    ["n|<Leader>fh"] = map_cu("Clap command_history"):with_noremap():with_silent(),

    ["n|<Leader>di"] = map_cr("<cmd>lua require'dap.ui.variables'.hover()"):with_expr(),
    ["n|<Leader>dw"] = map_cr("<cmd>lua require'dap.ui.widgets'.hover()"):with_expr(), -- TODO: another key?
    ["v|<Leader>di"] = map_cr("<cmd>lua require'dap.ui.variables'.visual_hover()"):with_expr(),

    ["n|<Leader><Leader>s"] = map_cr("SplitjoinSplit"),
    ["n|<Leader><Leader>j"] = map_cr("SplitjoinJoin"),

    -- Plugin Vista
    ["n|<Leader>v]"] = map_cu("Vista!!"):with_noremap():with_silent(),

    -- clap --
    -- ["n|<localleader-C>"] = map_cu("Clap | startinsert"),
    -- ["i|<localleader-C>"] = map_cu("Clap | startinsert"):with_noremap():with_silent(),

    ["n|<Leader>df"] = map_cu("Clap dumb_jump ++query=<cword> | startinsert"),
    -- ["i|<Leader>df"] = map_cu("Clap dumb_jump ++query=<cword> | startinsert"):with_noremap():with_silent(),

    -- Buffer Line
    ["n|<leader>bdh"] = map_cr("BDelete hidden"):with_silent():with_nowait():with_noremap(),
    ["n|<leader>bdu"] = map_cr("BDelete! nameless"):with_silent():with_nowait():with_noremap(),
    ["n|<leader>bD"] = map_cr("BDelete! this"):with_silent():with_nowait():with_noremap(),

    ["n|<Leader>b["] = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
    ["n|<Leader>b]"] = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),
    ["n|<leader>bg"] = map_cr("BufferLinePick"):with_noremap():with_silent(),
    ["n|<localleader>1"] = map_cr("BufferLineGoToBuffer 1 "):with_silent(),
    ["n|<localleader>2"] = map_cr("BufferLineGoToBuffer 2"):with_silent(),
    ["n|<localleader>3"] = map_cr("BufferLineGoToBuffer 3 "):with_silent(),
    ["n|<localleader>4"] = map_cr("BufferLineGoToBuffer 4 "):with_silent(),
    ["n|<localleader>5"] = map_cr("BufferLineGoToBuffer 5 "):with_silent(),
    ["n|<localleader>6"] = map_cr("BufferLineGoToBuffer 6 "):with_silent(),
    ["n|<localleader>7"] = map_cr("BufferLineGoToBuffer 7 "):with_silent(),
    ["n|<localleader>8"] = map_cr("BufferLineGoToBuffer 8 "):with_silent(),
    ["n|<localleader>9"] = map_cr("BufferLineGoToBuffer 9 "):with_silent(),
    ["n|<localleader>q"] = map_cr("BufferLinePickClose"):with_silent(),

    -- tshit
    ["o|m"] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>"):with_silent(),
    ["v|m"] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>"):with_noremap():with_silent(),

    -- clap --

    -- ["n|<d-C>"] = map_cu("Clap | startinsert"),
    -- ["i|<d-C>"] = map_cu("Clap | startinsert"):with_noremap():with_silent(),
    -- -- ["n|<d-p>"] = map_cu("Clap files | startinsert"),
    -- -- ["i|<d-p>"] = map_cu("Clap files | startinsert"):with_noremap():with_silent(),
    -- -- ["n|<d-m>"] = map_cu("Clap files | startinsert"),
    -- -- ["n|<M-m>"] = map_cu("Clap maps +mode=n | startinsert"),
    -- -- ["i|<M-m>"] = map_cu("Clap maps +mode=i | startinsert"),
    -- -- ["v|<M-m>"] = map_cu("Clap maps +mode=v | startinsert"),

    -- ["n|<d-f>"] = map_cu("Clap grep ++query=<cword> |  startinsert"),
    ["i|<d-f>"] = map_cu("Clap grep ++query=<cword> |  startinsert"):with_noremap():with_silent(),
    ["i|<C-df>"] = map_cu("Clap dumb_jump ++query=<cword> | startinsert"):with_noremap():with_silent(),
    -- -- ["n|<F2>"] = map_cr(""):with_expr(),
    -- ["n|<F5>"] = map_cmd("v:lua.run_or_test(v:true)"):with_expr(),
    -- ["n|<F9>"] = map_cr("GoBreakToggle"),
    -- -- session
    -- Switch from local to Normal for M to test how it tis
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

    ["n|;t"] = map_cu([[Telescope harpoon marks]]):with_noremap():with_silent(),
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
    ["n|<Leader>rp"] = map_cmd([[lua require('refactoring').debug.printf({below = false})<CR>]]):with_noremap(),

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

vim.api.nvim_add_user_command("DuckStart", function()
    require("modules.useless.config").launch_duck()
end, { force = true })

vim.api.nvim_add_user_command("TestStart", function()
    require("modules.lang.language_utils").testStart()
end, { force = true })

vim.api.nvim_add_user_command("DebugOpen", function()
    require("modules.lang.dap").prepare()
end, { force = true })

vim.api.nvim_add_user_command("HpoonClear", function()
    require("harpoon.mark").clear_all()
end, { force = true })

vim.api.nvim_add_user_command("HpoonClear", function()
    require("harpoon.mark").clear_all()
end, { force = true })

vim.api.nvim_add_user_command("Hashbang", function()
    local shells = {
        sh = { "#! /usr/bin/env bash" },
        py = { "#! /usr/bin/env python3" },
        scala = { "#! /usr/bin/env scala" },
        tcl = { "#! /usr/bin/env tclsh" },
        lua = {
            "#! /bin/sh",
            "_=[[",
            'exec lua "$0" "$@"',
            "]]",
        },
    }

    local extension = vim.fn.expand("%:e")

    if shells[extension] then
        local hb = shells[extension]
        hb[#hb + 1] = ""

        vim.api.nvim_buf_set_lines(0, 0, 0, false, hb)
        vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = 0,
            once = true,
            command = "silent !chmod u+x %",
        })
    end
end, { force = true })

vim.api.nvim_add_user_command("Keymaps", function()
    require("overwrite.mapping").get_keymaps()
end, { force = true })

vim.api.nvim_add_user_command("ColourScheme", function()
    require("utils.telescope").colorscheme()
end, { force = true })

vim.cmd([[
  iabbrev :rev: <c-r>=printf(&commentstring, ' REVISIT '.$USER.' ('.strftime("%d/%m/%y").'):')<CR>
  iabbrev :todo: <c-r>=printf(&commentstring, ' TODO(vsedov):')<CR>
  iabbrev funciton function
]])

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

-- Use `git ls-files` for git files, use `find ./ *` for all files under work directory.
--
return K
