local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local loader = require("packer").loader
K = {}
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
    ["n|<Leader><Leader>r"] = map_cmd("v:lua.run_or_test()"):with_expr(),
    ["v|<Leader><Leader>r"] = map_cmd("v:lua.run_or_test()"):with_expr(),
    ["n|<F5>"] = map_cmd("v:lua.run_or_test(v:true)"):with_expr(),
  }
  bind.nvim_load_mapping(luakeys)
end

local keys = {
  -- pack?
  -- ["n|<Leader>tr"]     = map_cr("call dein#recache_runtimepath()"):with_noremap():with_silent(),
  -- ["n|<Leader>tf"]     = map_cu('DashboardNewFile'):with_noremap():with_silent(),

  -- Lsp mapp work when insertenter and lsp start
  --
  ["n|<Leader>tc"] = map_cu("Clap colors"):with_noremap():with_silent(),
  ["n|<Leader>bB"] = map_cu("Clap buffers"):with_noremap():with_silent(),
  ["n|<localleader>ff"] = map_cu("Clap grep"):with_noremap():with_silent(),
  ["n|<localleader>fb"] = map_cu("Clap marks"):with_noremap():with_silent(),
  ["n|<C-x><C-f>"] = map_cu("Clap filer"):with_noremap():with_silent(),
  ["n|<Leader>fF"] = map_cu("Clap files ++finder=rg --ignore --hidden --files"):with_noremap():with_silent(),
  -- ["n|<M-g>"] = map_cu("Clap gfiles"):with_noremap():with_silent(),
  ["n|<M-h>"] = map_cu("Clap history"):with_noremap():with_silent(),

  ["n|<Leader>fq"] = map_cu("Clap grep ++query=<cword>"):with_noremap():with_silent(),

  ["n|<Leader>fW"] = map_cu("Clap windows"):with_noremap():with_silent(),
  -- ["n|<Leader>fl"] = map_cu("Clap loclist"):with_noremap():with_silent(),
  ["n|<Leader>fu"] = map_cu("Clap git_diff_files"):with_noremap():with_silent(),
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
  ["n|<localleader>bth"] = map_cr("BDelete hidden"):with_silent():with_nowait():with_noremap(),
  ["n|<localleader>btu"] = map_cr("BDelete! nameless"):with_silent():with_nowait():with_noremap(),
  ["n|<localleader>btc"] = map_cr("BDelete! this"):with_silent():with_nowait():with_noremap(),

  ["n|<Leader>b["] = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
  ["n|<Leader>b]"] = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),
  ["n|<localleader>bg"] = map_cr("BufferLinePick"):with_noremap():with_silent(),

  -- These are nice -- cant have these me
  ["n|<A-a>"] = map_cr("HopWord"):with_silent(),
  ["n|<A-w>"] = map_cr("HopWordBC"):with_silent(),
  ["n|<A-W>"] = map_cr("HopWordAC"):with_silent(),

  ["n|g/"] = map_cr("HopLine"),
  ["n|g<"] = map_cr("HopLineStartAC"),
  ["n|g>"] = map_cr("HopLineStartBC"),

  -- clap --

  -- ["xon|f"] = map_cmd("<cmd>lua  Line_ft('f')<cr>"),
  -- ["xon|F"] = map_cmd("<cmd>lua  Line_ft('F')<cr>"),
  -- ["xon|t"] = map_cmd("<cmd>lua  Line_ft('t')<cr>"),
  -- ["xon|T"] = map_cmd("<cmd>lua  Line_ft('T')<cr>"),
  -- ["n|s"] = map_cmd("<cmd>lua hop1(1)<CR>"):with_silent(),
  -- ["n|S"] = map_cmd("<cmd>lua hop1()<CR>"):with_silent(),
  -- ["x|s"] = map_cmd("<cmd>lua hop1(1)<CR>"):with_silent(),
  -- ["x|S"] = map_cmd("<cmd>lua hop1()<CR>"):with_silent(),
  -- -- ["v|<M-s>"] = map_cmd("<cmd>lua require'hop'.hint_char1()<cr>"):with_silent():with_expr(),
  -- -- ["n|<Space>s"] = map_cr("HopChar2"),
  -- ["n|<M-s>"] = map_cr("HopChar2AC"),
  -- ["n|<M-S>"] = map_cr("HopChar2BC"),
  -- ["xv|<M-s>"] = map_cmd("<cmd>HopChar2AC<CR>"):with_silent(),
  -- ["xv|<M-S>"] = map_cmd("<cmd>HopChar2BC<CR>"):with_silent(),
  -- ["n|<Space>F"] = map_cr("HopPattern"),
  -- ["n|<Space>]"] = map_cr("HopPatternAC"),
  -- ["n|<Space>["] = map_cr("HopPatternBC"),
  -- -- clap --
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

  ["n|<Leader>sd"] = map_cu("DeleteSession"):with_noremap(),

  ["n|<localleader>M"] = map_cmd([[<cmd> lua require("harpoon.mark").toggle_file()<CR>]]),
  ["n|<localleader>m1"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(1)<CR>]]),
  ["n|<localleader>m2"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(2)<CR>]]),
  ["n|<localleader>m3"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(3)<CR>]]),
  ["n|<localleader>m4"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(4)<CR>]]),
  ["n|<localleader>m"] = map_cmd([[<cmd> Telescope harpoon marks <CR>]]),

  --- Use commands for this .
  ["v|<Leader>re"] = map_cmd("<esc><cmd>lua require('refactoring').refactor('Extract Function')<cr>")
    :with_noremap()
    :with_silent()
    :with_expr(),
  ["v|<Leader>rf"] = map_cmd("<esc><cmd>lua require('refactoring').refactor('Extract Function To File')<cr>")
    :with_noremap()
    :with_silent()
    :with_expr(),
  ["v|<Leader>rt"] = map_cmd("<esc><cmd>lua require('refactoring').refactor()<cr>")
    :with_noremap()
    :with_silent()
    :with_expr(),

  ["v|<Leader>gs"] = map_cmd("<cmd>lua require('utils.git').qf_add()<cr>"),
}

--
vim.cmd([[vnoremap  <leader>y  "+y]])
vim.cmd([[nnoremap  <leader>Y  "+yg_]])
-- vim.cmd([[vnoremap  <M-c>  "+y]])
-- vim.cmd([[nnoremap  <M-c>  "+yg_]])

vim.cmd([[vnoremap  <D-c>  *+y]])
vim.cmd([[nnoremap  <D-c>  *+yg_]])
vim.cmd([[inoremap  <D-c>  *+yg_]])
vim.cmd([[inoremap  <D-v>  <CTRL-r>*]])

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

-- for the time have this

return K
