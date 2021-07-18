local completion = {}
local conf = require('modules.completion.config')

completion['neovim/nvim-lspconfig'] = {
  event = 'BufReadPre',
  config = conf.nvim_lsp,

  requires = {
  {'nvim-lua/lsp_extensions.nvim'},
  {'tjdevries/nlua.nvim'},
  {'ray-x/lsp_signature.nvim'},
  {'https://github.com/onsails/lspkind-nvim'},
  {'folke/lsp-colors.nvim'}

  -- {'nathunsmitty/nvim-ale-diagnostic',opt=true}
  }
}

completion['folke/todo-comments.nvim']  = {
  config = conf.todo_comments,
  after = 'trouble.nvim'

}

-- For thoe that only use lsp - i use this for linting - python flake8 for 
-- this ale lint is disabled ale fix enabled and so on . 
completion['https://github.com/folke/trouble.nvim'] = {
  config = conf.trouble,

}



completion['dense-analysis/ale'] = {

  config = conf.ale

}

-- OUt of date need to replace this
completion['glepnir/lspsaga.nvim'] = {
  cmd = 'Lspsaga',
}

-- completion['ray-x/navigator.lua'] = {
--   requires = {'ray-x/guihua.lua', run = 'cd lua/fzy && make'}

-- }



completion['tzachar/compe-tabnine'] = {
  run = './install.sh',
  requires = {{'hrsh7th/nvim-compe'},
              {'GoldsteinE/compe-latex-symbols'}},
  config = conf.nvim_compe,

}


completion['hrsh7th/vim-vsnip'] = {
  event = 'InsertCharPre',
  config = conf.vim_vsnip
}

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
    {'https://github.com/fhill2/telescope-ultisnips.nvim'},
  },
  config = conf.telescope
}
completion['pwntester/octo.nvim']={
  after="telescope.nvim",
  config  = function()
    require"octo".setup()

  end
}

--Leave for last i think ,. 

completion['SirVer/ultisnips'] = {
  requires = 'honza/vim-snippets',
  config = conf.ultisnipsconf
}


completion['Pocco81/AbbrevMan.nvim'] = {
  config = conf.AbbrevMan
}



completion['kkoomen/vim-doge'] = {
  config = conf.doge,
  run = ':call doge#install()'

}



-- command Neorunner - depends if i will keep this trying out new stuff . 
completion['BenGH28/neo-runner.nvim'] = {
  config = conf.neorunner,
  run = ':UpdateRemotePlugins'
}


-- This one seems to have more support and looks better . 
completion['CRAG666/code_runner.nvim'] = {
  requires = 'numtostr/FTerm.nvim',
  config = conf.code_runner,
}




completion['kevinhwang91/nvim-bqf'] = {
  config = conf.bqf

}



completion['mfussenegger/nvim-dap'] = {
  requires ={
    {'rcarriga/vim-ultest'},
    {'janko/vim-test'},
    {'theHamsta/nvim-dap-virtual-text'},
    {'mfussenegger/nvim-dap-python'},
    {'rcarriga/nvim-dap-ui'},
  },
  run = ':UpdateRemotePlugins',


  config = function()

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




completion['lervag/vimtex'] = {
  config = conf.vimtex
}




-- For most basic files , there is an autoformat . 
completion['Chiel92/vim-autoformat'] = {

}



completion['michaelb/sniprun'] = {
  run = 'bash install.sh',
  config =  conf.sniprun,

  -- This has not been 100% set up make sure you set it up later 

}
-- completion['simrat39/symbols-outline.nvim'] = {
--   config = conf.outline
-- }




completion['psf/black'] = {
}





completion['glepnir/smartinput.nvim'] = {
  ft = 'go',
  config = conf.smart_input
}





completion['mattn/vim-sonictemplate'] = {
  cmd = 'Template',
  ft = {'go','typescript','lua','javascript','vim','rust','markdown'},
  config = conf.vim_sonictemplate,
}

completion['mattn/emmet-vim'] = {
  event = 'InsertEnter',
  ft = {'html','css','javascript','javascriptreact','vue','typescript','typescriptreact'},
  config = conf.emmet,
}

return completion
