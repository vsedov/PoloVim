local telescope = require "telescope"
local themes = require "telescope.themes"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"

-- Some stuff were take from his confgs I changed them up a bit . 

local finders = require "telescope.builtin"
local actions = require('telescope.actions')



local tele = {}

-- Themes
-- >>- ------- -<

local theme = themes.get_dropdown {winblend = 10, results_height = 10}

tele.theme = function(opts)
  return vim.tbl_deep_extend("force", theme, opts or {})
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
  tele.setup()
end

return tele



