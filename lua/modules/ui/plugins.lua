local ui = {}
local conf = require('modules.ui.config')
local winwidth = function()
  return vim.api.nvim_call_function("winwidth", {0})
end


ui["kyazdani42/nvim-web-devicons"] = {}
ui["lambdalisue/glyph-palette.vim"] = {}
--switch out with folke/tokyonight.nvim
ui['folke/tokyonight.nvim'] = {
  config = conf.ui,
}


ui['glepnir/dashboard-nvim'] = {
  config = conf.dashboard,

}



ui['NTBBloodbath/galaxyline.nvim'] = {
  branch = 'main',
  config = conf.galaxyline,
  requires = 'kyazdani42/nvim-web-devicons'
}

-- ui["windwp/windline.nvim"] = {
--   event = "UIEnter",
--   config = conf.windline,
--   -- requires = {'kyazdani42/nvim-web-devicons'},
--   opt = true
-- }

ui["lambdalisue/glyph-palette.vim"] = {}


ui['lukas-reineke/indent-blankline.nvim'] = {
  config = conf.indent_blakline
}



ui["dstein64/nvim-scrollview"] = {config = conf.scrollview}


ui["akinsho/bufferline.nvim"] = {
  config = conf.nvim_bufferline,
  event = "UIEnter",
  diagnostics_update_in_insert = false,
  -- after = {"aurora"}
  -- requires = {'kyazdani42/nvim-web-devicons'}
  opt = true
}


ui['kazhala/close-buffers.nvim'] = {
  config = conf.buffers_close,
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

-- ui['beauwilliams/focus.nvim']={

--   config = function()
--   local focus = require('focus')
--   -- Displays a cursorline in the focussed window only
--   -- Not displayed in unfocussed windows
--   -- Default: true
--   focus.cursorline = false
--   end
-- }


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


-- ui['https://github.com/yamatsum/nvim-cursorline'] = {
-- }




ui['folke/twilight.nvim'] = {
}




return ui
