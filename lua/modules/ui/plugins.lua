local ui = {}
local conf = require('modules.ui.config')

-- ui['glepnir/zephyr-nvim'] = {
--   config = [[vim.cmd('colorscheme zephyr')]]
-- }


--rockerBOO/boo-colorscheme-nvim
ui['folke/tokyonight.nvim'] = {
  config = conf.ui_i,

  branch = 'main',

}

ui['justinmk/vim-syntax-extra'] = {

}



ui['akinsho/nvim-toggleterm.lua'] = {

  config = conf.toggleterm

}






ui['psliwka/vim-smoothie'] ={}



ui['glepnir/dashboard-nvim'] = {
  config = conf.dashboard
}

ui['glepnir/galaxyline.nvim'] = {
  branch = 'main',
  config = conf.galaxyline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lukas-reineke/indent-blankline.nvim'] = {
  event = 'BufRead',
  branch = 'lua',
  config = conf.indent_blakline
}


ui['kdav5758/TrueZen.nvim'] = {
  config = conf.minmin
}







ui['akinsho/nvim-bufferline.lua'] = {
  config = conf.nvim_bufferline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['kyazdani42/nvim-tree.lua'] = {
  cmd = {'NvimTreeToggle','NvimTreeOpen'},
  config = conf.nvim_tree,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lewis6991/gitsigns.nvim'] = {
  event = {'BufRead','BufNewFile'},
  config = conf.gitsigns,
  requires = {'nvim-lua/plenary.nvim',opt=true}
}



ui['https://github.com/alec-gibson/nvim-tetris'] = {
}





return ui
