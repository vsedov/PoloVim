local ui = {}
local conf = require('modules.ui.config')

--switch out with folke/tokyonight.nvim
ui['folke/tokyonight.nvim'] = {
  config = conf.ui,
}


ui['glepnir/dashboard-nvim'] = {
  config = conf.dashboard,

}



ui['glepnir/galaxyline.nvim'] = {
  branch = 'main',
  config = conf.galaxyline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lukas-reineke/indent-blankline.nvim'] = {
  event = 'BufRead',
  branch = 'master',
  config = conf.indent_blakline
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

ui['kdav5758/TrueZen.nvim'] = {
  config = conf.truezen
}
ui['folke/zen-mode.nvim'] = {

  config = function()
    require("zen-mode").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }



  end

}

ui['folke/twilight.nvim'] = {
}


ui['mbbill/undotree'] = {
  config = conf.undo
}

-- Just a nicert delete 
ui['famiu/bufdelete.nvim'] = {


}



return ui
