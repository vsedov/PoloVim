local lang = {}
local conf = require('modules.lang.config')

lang['nvim-treesitter/nvim-treesitter'] = {
  event = 'BufRead',
  after = 'telescope.nvim',
  config = conf.nvim_treesitter,
}








-- lang['romgrk/nvim-treesitter-context'] = {

--   after = 'nvim-treesitter',


-- }



lang['https://github.com/haringsrob/nvim_context_vt'] = {
  after = 'nvim-treesitter',

}





return lang
