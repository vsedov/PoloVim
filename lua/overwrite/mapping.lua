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
  ["n|<localleader>bth"] = map_cr("BDelete hidden"):with_silent():with_nowait():with_noremap(),
  ["n|<localleader>btu"] = map_cr("BDelete! nameless"):with_silent():with_nowait():with_noremap(),
  ["n|<localleader>btc"] = map_cr("BDelete! this"):with_silent():with_nowait():with_noremap(),

  ["n|<Leader>b["] = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
  ["n|<Leader>b]"] = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),
  ["n|<localleader>bg"] = map_cr("BufferLinePick"):with_noremap():with_silent(),

  -- These are nice but pointless if you have lightspeed
  -- ["n|<A-a>"] = map_cr("HopWord"):with_silent(),
  -- ["n|<A-w>"] = map_cr("HopWordBC"):with_silent(),
  -- ["n|<A-W>"] = map_cr("HopWordAC"):with_silent(),

  -- -- Broken
  -- ["n|g/"] = map_cmd("<cmd>HopLineStartAC<cr>"):with_silent(),
  -- ["n|g,"] = map_cmd("<cmd>HopLineStartBC<cr>"):with_silent(),

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

  -- Switch from local to Normal for M to test how it tis
  ["n|<Leader>M"] = map_cmd([[<cmd> lua require("harpoon.mark").toggle_file()<CR>]]),
  ["n|<Leader>m1"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(1)<CR>]]),
  ["n|<Leader>m2"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(2)<CR>]]),
  ["n|<Leader>m3"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(3)<CR>]]),
  ["n|<Leader>m4"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(4)<CR>]]),
  ["n|<Leader>m"] = map_cmd([[<cmd> Telescope harpoon marks <CR>]]),

  --- Refactoring
  ["v|<Leader>re"] = map_cmd("<esc><cmd>lua require('refactoring').refactor('Extract Function')<cr>"):with_noremap(),

  ["v|<Leader>rf"] = map_cmd("<esc><cmd>lua require('refactoring').refactor('Extract Function To File')<cr>"):with_noremap(),

  ["v|<Leader>rt"] = map_cmd("<esc><cmd>lua require('refactoring').refactor()<cr>"):with_noremap(),

  ["v|<Leader>rp"] = map_cmd("<cmd>lua require('refactoring').debug.printf({below = false})<CR>"):with_noremap(),

  ["v|<Leader>rv"] = map_cmd("<cmd>lua require('refactoring').debug.print_var({})<CR>"):with_noremap(),

  ["v|<Leader>rc"] = map_cmd("<cmd>lua require('refactoring').debug.cleanup({})<CR>"):with_noremap(),

  ["v|<Leader>gs"] = map_cmd("<cmd>lua require('utils.git').qf_add()<cr>"),
}

--
vim.cmd([[vnoremap  <leader>y  "+y]])
vim.cmd([[nnoremap  <leader>Y  "+yg_]])
-- vim.cmd([[vnoremap  <M-c>  "+y]])
-- vim.cmd([[nnoremap  <M-c>  "+yg_]])

vim.cmd([[vnoremap  <localleader>c  *+y]])
vim.cmd([[nnoremap  <localleader>c  *+yg_]])
vim.cmd([[inoremap  <localleader>c  *+yg_]])
vim.cmd([[inoremap  <localleader>v <C-r>*]])

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
vim.cmd([[command! -nargs=* CustColour lua require('utils.telescope').colorscheme()]])

-- Use `git ls-files` for git files, use `find ./ *` for all files under work directory.
--
return K
