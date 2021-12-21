
local loader = require("packer").loader
_G.PLoader = loader
function Lazyload()
  --
  math.randomseed(os.time())
  local themes = {

    "tokyonight.nvim",
    -- TODO Add more themes 
    

  }

  local v = math.random(1, #themes)
  local loading_theme = themes[v]

  loader(loading_theme)
  --
  if vim.wo.diff then
    -- loader(plugins)
    lprint("diffmode")
    vim.cmd([[packadd nvim-treesitter]])
    require("nvim-treesitter.configs").setup({ highlight = { enable = true, use_languagetree = false } })
    vim.cmd([[syntax on]])
    return
  end

  lprint("I am lazy")

  local disable_ft = {
    "NvimTree",
    "guihua",
    "guihua_rust",
    "clap_input",
    "clap_spinner",
    "TelescopePrompt",
    "csv",
    "txt",
    "defx",
    "sidekick",
  }

  local syn_on = not vim.tbl_contains(disable_ft, vim.bo.filetype)
  if syn_on then
    vim.cmd([[syntax on]])
  else
    vim.cmd([[syntax manual]])
  end

  -- local fname = vim.fn.expand("%:p:f")
  local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f"))
  if fsize == nil or fsize < 0 then
    fsize = 1
  end

  local load_lsp = true
  local load_ts_plugins = true

  if fsize > 1024 * 1024 then
    load_ts_plugins = false
    load_lsp = false
  end
  if fsize > 6 * 1024 * 1024 then
    vim.cmd([[syntax off]])
    return
  end

  local plugins = "plenary.nvim" -- nvim-lspconfig navigator.lua   guihua.lua navigator.lua  -- gitsigns.nvim
  loader("plenary.nvim")


  if vim.bo.filetype == "lua" then
    loader("lua-dev.nvim")
  end

  vim.g.vimsyn_embed = "lPr"

  local gitrepo = vim.fn.isdirectory(".git/index")
  if gitrepo then
    loader("gitsigns.nvim") -- neogit vgit.nvim
  end

  if load_lsp then
    loader("nvim-lspconfig") -- null-ls.nvim
    loader("lsp_signature.nvim")
    loader("null-ls.nvim")
    -- loader("code_runner.nvim")
    loader("neo-runner.nvim")
    loader("jaq-nvim")
  end

  require("vscripts.cursorhold")
  require("vscripts.tools")
  if load_ts_plugins then
    -- print('load ts plugins')
    loader("nvim-treesitter")
  end

  if load_lsp or load_ts_plugins then
    loader("guihua.lua")
    loader("Comment.nvim")
    loader("paperplanes.nvim")

    -- loader("navigator.lua")
  end

  -- local bytes = vim.fn.wordcount()['bytes']
  if load_ts_plugins then
    plugins =
      "nvim-treesitter-textobjects  nvim-treesitter-refactor nvim-ts-autotag nvim-ts-context-commentstring nvim-treesitter-textsubjects" 
    loader(plugins)
    lprint(plugins)
    -- nvim-treesitter-textobjects should be autoloaded
    loader("refactoring.nvim")
    loader("indent-blankline.nvim")
  end

  -- if load_ts_plugins and vim.bo.filetype == "python" then
  --   loader("nvim-treesitter-pyfold")
  -- end

  -- if bytes < 2 * 1024 * 1024 and syn_on then
  --   vim.cmd([[setlocal syntax=on]])
  -- end

  vim.cmd([[autocmd FileType vista,guihua setlocal syntax=on]])
  vim.cmd(
    [[autocmd FileType * silent! lua if vim.fn.wordcount()['bytes'] > 2048000 then print("syntax off") vim.cmd("setlocal syntax=off") else lprint('setlocal syntax=on') vim.cmd("setlocal syntax=on") end]]
  )
  -- local cmd = [[au VimEnter * ++once lua require("packer.load")({']] .. loading_theme
  --                 .. [['}, { event = "VimEnter *" }, _G.packer_plugins)]]
  -- vim.cmd(cmd)
  -- loader('windline.nvim')
  -- require("modules.ui.eviline")
  -- require('wlfloatline').setup()
end

vim.cmd([[autocmd User LoadLazyPlugin lua Lazyload()]])
vim.cmd("command! Gram lua require'modules.tools.config'.grammcheck()")
vim.cmd("command! Spell call spelunker#check()")

local lazy_timer = 50
if _G.packer_plugins == nil or _G.packer_plugins["packer.nvim"] == nil then
  print("recompile")
  vim.cmd([[PackerCompile]])
  vim.defer_fn(function()
    print("Packer recompiled, please restart nvim")
  end, 1000)
  return
end

vim.defer_fn(function()
  vim.cmd([[doautocmd User LoadLazyPlugin]])
end, lazy_timer)

vim.defer_fn(function()
  -- lazyload()
  local cmd = "TSEnableAll highlight " .. vim.o.ft
  vim.cmd(cmd)
  vim.cmd(
    [[autocmd BufEnter * silent! lua vim.fn.wordcount()['bytes'] < 2048000 then vim.cmd('set syntax=on') local cmd= "TSBufEnable "..vim.o.ft vim.cmd(cmd) lprint(cmd, vim.o.ft, vim.o.syntax) end]]
  )
  -- vim.cmd([[doautocmd ColorScheme]])
  -- vim.cmd(cmd)
end, lazy_timer + 20)

vim.cmd([[hi LineNr guifg=#505068]])

vim.defer_fn(function()
  local loader = require("packer").loader
  loader("telescope.nvim telescope-zoxide project.nvim nvim-neoclip.lua")
  loader("harpoon")
  loader("windline.nvim")
  require("modules.ui.eviline")
  require("wlfloatline").setup()
  loader("nui.nvim fine-cmdline.nvim")
  loader("FTerm.nvim")
end, lazy_timer + 100)
