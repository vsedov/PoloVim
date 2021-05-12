local telescope = require "telescope"
local themes = require "telescope.themes"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"

-- Some stuff were take from his confgs I changed them up a bit . 

local finders = require "telescope.builtin"
local actions = require('telescope.actions')



local tele = {}

-- Telescope defaults
tele.setup = function()
  local telescope_config = {
    selection_strategy = "reset",
    shorten_path = true,
    layout_strategy = "flex",
    prompt_position = "top",
    sorting_strategy = "ascending",
    winblend = 3,
    prompt_prefix = "※",
    width = 0.8,
    height = 0.7,
    results_width = 80,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    generic_sorter = sorters.get_fzy_sorter,
    -- file_sorter = sorters.get_fzy_sorter,
  }

  telescope.setup({defaults = telescope_config})
end

-- Themes
-- >>- ------- -<

local theme = themes.get_dropdown {winblend = 10, results_height = 10}

tele.theme = function(opts)
  return vim.tbl_deep_extend("force", theme, opts or {})
end

-- File Functions 
-- >>- ------- -<

tele.find_files = function(input_opts)
  local opts = vim.tbl_deep_extend("force", theme, input_opts or {})
  require"telescope.builtin".find_files(opts)
end

tele.find_files_plugins = function()
  local cwd = require"packer.util".join_paths(vim.fn.stdpath("data"), "site", "pack")

  require"telescope.builtin".find_files(tele.theme({cwd = cwd}))
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
  require"plenary.reload".reload_module("boo-colorscheme")
  require"plenary.reload".reload_module("plugin")
  require"plenary.reload".reload_module("lsp_extensions")
  require'boo-colorscheme'.use{}
  tele.setup()
end

return tele