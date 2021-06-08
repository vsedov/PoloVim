local tools = {}
local conf = require('modules.tools.config')

tools['kristijanhusak/vim-dadbod-ui'] = {
  cmd = {'DBUIToggle','DBUIAddConnection','DBUI','DBUIFindBuffer','DBUIRenameBuffer'},
  config = conf.vim_dadbod_ui,
  requires = {{'tpope/vim-dadbod',opt = true}}
}

tools['editorconfig/editorconfig-vim'] = {
  ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools['b3nj5m1n/kommentary'] = {
  config = conf.kommentary,
}


tools['relastle/vim-nayvy'] ={

  config = function ()
    vim.g.nayvy_import_config_path = '$HOME/nayvy.py'
  end
}


tools['wakatime/vim-wakatime'] ={
}

--Moving stuff 
tools['camspiers/animate.vim'] ={
}

tools['psliwka/vim-smoothie'] ={
}

tools['euclidianAce/BetterLua.vim'] = {}

tools['nacro90/numb.nvim'] = {
  config = function ()
  require('numb').setup()  end
}


tools['gennaro-tedesco/nvim-jqx'] = {
}


--NOT REALLY SURE WHAT THIS DOES NGL . BUT FUCK IT .
tools['ahmedkhalf/lsp-rooter.nvim'] = {
}

tools['Pocco81/HighStr.nvim'] = {
}



tools['jbyuki/nabla.nvim'] = {
}

tools['liuchengxu/vista.vim'] = {
  cmd = 'Vista',
  config = conf.vim_vista
}

tools['brooth/far.vim'] = {
  cmd = {'Far','Farp'},
  config = function ()
    vim.g['far#source'] = 'rg'
  end
}

tools['iamcco/markdown-preview.nvim'] = {
  ft = 'markdown',
  config = function ()
    vim.g.mkdp_auto_start = 0
  end
}




-- Nice toools 


tools['kevinhwang91/nvim-hlslens'] = {
  config = function ()
    require('hlslens').setup({
      calm_down = true,
      nearest_only = true,
      nearest_float_when = 'always'
    })
  end
}


return tools
