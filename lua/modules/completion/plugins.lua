local completion = {}
local conf = require('modules.completion.config')

completion['neovim/nvim-lspconfig'] = {
  event = 'BufReadPre',
  config = conf.nvim_lsp,
  requires = {{'nvim-lua/lsp_extensions.nvim'},
  {'tjdevries/nlua.nvim'},
  }

}




completion['glepnir/lspsaga.nvim'] = {
  cmd = 'Lspsaga',
}


completion['tzachar/compe-tabnine'] = {
  run = './install.sh',
  requires = {{'hrsh7th/nvim-compe'},
              {'GoldsteinE/compe-latex-symbols'}},
  event = 'InsertEnter',
  config = conf.nvim_compe,

}

completion['SirVer/ultisnips'] = {
  requires = 'honza/vim-snippets',
  config = conf.ultisnipsconf
}



completion['mboughaba/i3config.vim'] = {
}

completion['kabouzeid/nvim-lspinstall'] = {
}




completion['https://github.com/tmhedberg/SimpylFold'] = {
}

completion['lervag/vimtex'] = {
  config = conf.vimtex
}

-- completion['sbdchd/vim-run'] = {
--   config = conf.run
-- }

completion['kkoomen/vim-doge'] = {
  config = conf.doge,
  run = '-> doge#install()'

}



-- command Neorunner - depends if i will keep this trying out new stuff . 
completion['BenGH28/neo-runner.nvim'] = {
  config = conf.neorunner,
  run = 'UpdateRemotePlugins'
}


-- This one seems to have more support and looks better . 
completion['CRAG666/code_runner.nvim'] = {
  requires = 'numtostr/FTerm.nvim',
  config = conf.code_runner,
}




completion['kevinhwang91/nvim-bqf'] = {
  config = conf.bqf

}




completion['hrsh7th/vim-vsnip'] = {
  event = 'InsertCharPre',
  config = conf.vim_vsnip
}

-- completion['mfussenegger/nvim-dap'] = {
--   requires =  'mfussenegger/nvim-dap-python',
--   config = conf.dap_text
-- }


completion['mfussenegger/nvim-dap'] = {
  requires ={'rcarriga/vim-ultest','janko/vim-test','theHamsta/nvim-dap-virtual-text','mfussenegger/nvim-dap-python','rcarriga/nvim-dap-ui'},
  config = function()
  run = ':UpdateRemotePlugins',

  require('dapstuff.dapstuff')

  require("dapui").setup()
  
    -- virtual text deactivated (default)
  vim.g.dap_virtual_text = false
  -- show virtual text for current frame (recommended)
  vim.g.dap_virtual_text = true
  -- request variable values for all frames (experimental)
  vim.g.dap_virtual_text = 'all frames'

  vim.g.ultest_virtual_text = 1
  vim.g.ultest_output_cols = 120
  vim.g.ultest_max_threads = 5


  end
}


-- completion['rcarriga/vim-ultest'] = {

--   requires = {{'janko/vim-test'}},
--   run = ':UpdateRemotePlugins',
--   config = function()

-- }



completion['nvim-telescope/telescope.nvim'] = {
  cmd = 'Telescope',
  requires = {
    {'nvim-lua/popup.nvim', opt = true},
    {'nvim-lua/plenary.nvim',opt = true},
    {'nvim-telescope/telescope-fzy-native.nvim',opt = true}, 
    {'nvim-telescope/telescope-cheat.nvim'},
    {'tami5/sql.nvim'},
    {'nvim-telescope/telescope-frecency.nvim'},
    {'nvim-telescope/telescope-dap.nvim'},
  },
  config = conf.telescope


}


--Real quick autoformat . 


-- For most basic files , there is an autoformat . 
completion['Chiel92/vim-autoformat'] = {
}







completion['michaelb/sniprun'] = {
  run = 'bash install.sh',
  config =  conf.sniprun,

  -- This has not been 100% set up make sure you set it up later 

}



completion['psf/black'] = {
}






completion['mattn/vim-sonictemplate'] = {
  cmd = 'Template',
  config = conf.vim_sonictemplate,
}



return completion
