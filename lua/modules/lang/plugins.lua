local lang = {}
local conf = require('modules.lang.config')

lang['nvim-treesitter/nvim-treesitter'] = {
  event = 'BufRead',
  after = 'telescope.nvim',
  config = conf.nvim_treesitter,
}

lang['nvim-treesitter/nvim-treesitter-textobjects'] = {
  after = 'nvim-treesitter'
}

lang['romgrk/nvim-treesitter-context'] = {
  after = 'nvim-treesitter',


}



lang['https://github.com/haringsrob/nvim_context_vt'] = {
  event = 'BufRead',

  after = 'nvim-treesitter',
  config = function() require 'nvim_context_vt'.showDebug() end


}




return lang
