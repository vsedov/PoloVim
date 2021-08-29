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
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    prompt_prefix = "-> ",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
      -- width = 0.75,
      -- height = 10,
      preview_cutoff = 120,
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    path_display = {
      'shorten',
      'absolute',
    },
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  },
  extensions = {
      fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
      }
  }
}