local completion = {}
local conf = require('modules.completion.config')

completion['neovim/nvim-lspconfig'] = {
  event = 'BufReadPre',
  config = conf.nvim_lsp,
  requires = {'nvim-lua/lsp_extensions.nvim'}

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


completion['sbdchd/vim-run'] = {
  config = conf.run
}

completion['kkoomen/vim-doge'] = {
  config = conf.doge,
  run = 'doge#install()'

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
  requires ={'theHamsta/nvim-dap-virtual-text','mfussenegger/nvim-dap-python','nvim-telescope/telescope-dap.nvim','rcarriga/nvim-dap-ui'},
  config = function()




  require('dapstuff.dapstuff')

  require("dapui").setup()
  
  require('dap-python').setup('/usr/bin/python3')
  require('dap-python').test_runner = 'pytest'
  


  end
}



completion['nvim-telescope/telescope.nvim'] = {
  cmd = 'Telescope',
  requires = {
    {'nvim-lua/popup.nvim', opt = true},
    {'nvim-lua/plenary.nvim',opt = true},
    {'nvim-telescope/telescope-fzy-native.nvim',opt = true},    
  },
  config = conf.telescope


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
  ft = {'go','typescript','lua','javascript','vim','rust','markdown'},
  config = conf.vim_sonictemplate,
}



return completion
