local editor = {}
local conf = require('modules.editor.config')

editor['Raimondi/delimitMate'] = {
  event = 'InsertEnter',
  config = conf.delimimate,
}



editor['rhysd/accelerated-jk'] = {
  opt = true
}

editor['norcalli/nvim-colorizer.lua'] = {
  ft = { 'html','css','sass','vim','typescript','typescriptreact'},
  config = conf.nvim_colorizer
}

editor['itchyny/vim-cursorword'] = {
  event = {'BufReadPre','BufNewFile'},
  config = conf.vim_cursorwod
}

editor['hrsh7th/vim-eft'] = {
  opt = true,
  config = function()
    vim.g.eft_ignorecase = true
  end
}

editor['kana/vim-operator-replace'] = {
  keys = {{'x','p'}},
  config = function()
    vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)",{silent =true})
  end,
  requires = 'kana/vim-operator-user'
}



editor['https://github.com/machakann/vim-sandwich']  = {
  -- use default config .
}

-- Pipe keeps losing this will get fixed . 

editor['andweeb/presence.nvim']  = {
  event = 'InsertEnter',

  config = conf.discord
}

editor['voldikss/vim-floaterm']  = {}


--Req Syntax Nice Stuff . 
editor['raimon49/requirements.txt.vim']  = {}


editor['kana/vim-niceblock']  = {
  opt = true
}



editor['https://github.com/tpope/vim-sensible'] = {
  opt = true
}







editor['Vimjas/vim-python-pep8-indent'] = {
}


editor['jdhao/better-escape.vim']  = {
}



editor['zegervdv/nrpattern.nvim']  = {

  config = function()
    require"nrpattern".setup()

    end

}

editor['rmagatti/alternate-toggler']  = {
}

editor['https://github.com/tmhedberg/SimpylFold']  = {
  requires  ='https://github.com/Konfekt/FastFold',

  config = function()
    vim.g.SimpylFold_docstring_preview = 1
  end
}







return editor
