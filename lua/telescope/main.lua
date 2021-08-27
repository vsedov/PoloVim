if not packer_plugins['trouble.nvim'].loaded then
  vim.cmd [[packadd folke/trouble.nvim]]
end
if not packer_plugins['plenary.nvim'].loaded then
  vim.cmd [[packadd plenary.nvim]]
  vim.cmd [[packadd popup.nvim]]
  vim.cmd [[packadd telescope-fzy-native.nvim]]
end



local telescope = require "telescope"
local themes = require "telescope.themes"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"

-- Some stuff were take from his confgs I changed them up a bit . 

local finders = require "telescope.builtin"
local actions = require('telescope.actions')



require('telescope').load_extension('dotfiles')
require('telescope').load_extension('dap')
require('telescope').load_extension('cheat')
require('telescope').load_extension('frecency')
require('telescope').load_extension('ultisnips')
-- require('telescope').load_extension('projects')
require('telescope').load_extension('fzy_native')




local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
}


local plugins_directory = function()
  return require("packer.util").join_paths(vim.fn.stdpath("data"), "site", "pack")
end


local tele = {}

-- Telescope defaults
tele.setup_defaults = function()
  local telescope_config = {
    dynamic_preview_title = true,
    selection_strategy = "reset",
    layout_strategy = "flex",
    -- layout_config = { prompt_position = "top", width = 0.8, height = 0.7 },
    sorting_strategy = "ascending",
    winblend = 3,
    prompt_prefix = "> ",
    -- set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  }

  telescope.setup({ defaults = telescope_config })

  

  telescope.setup({defaults = telescope_config})

end

-- Themes
-- >>- ------- -<


local theme = themes.get_dropdown({ winblend = 10, layout_config = { height = 10 } })

tele.theme = function(opts)
  return vim.tbl_deep_extend("force", theme, opts or {})
end

-- File Functions 
-- >>- ------- -<

tele.find_files = function(input_opts)
  require("telescope.builtin").find_files(tele.theme(input_opts))
end

tele.find_files_plugins = function()
  require("telescope.builtin").find_files(tele.theme({ cwd = plugins_directory() }))
end

-- Treesitter 
-- >>- ------- -<

tele.treesitter = function()
  return require"telescope.builtin".treesitter(tele.theme())
end

function P(module)
  require"plenary.reload".reload_module(module)
end

function PlenaryReload()
  require("plenary.reload").reload_module("telescope")
  require("plenary.reload").reload_module("plenary")
  require"plenary.reload".reload_module("plugin")
  require"plenary.reload".reload_module("lsp_extensions")
  tele.setup()
end

return tele
