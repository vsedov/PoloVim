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


-- Better version below
editor['https://github.com/ggandor/lightspeed.nvim'] = {
    
    config = function()
    require'lightspeed'.setup {
      jump_to_first_match = true,
      highlight_unique_chars = true,
      grey_out_search_area = true,
      match_only_the_start_of_same_char_seqs = true,
      limit_ft_matches = 10,
      full_inclusive_prefix_key = '<c-x>',
      -- By default, the values of these will be decided at runtime,
      -- based on `jump_to_first_match`.
      labels = nil,
      cycle_group_fwd_key = "<Tab.",
      cycle_group_bwd_key = "S-TAB",
    }
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





editor['Vimjas/vim-python-pep8-indent'] = {
}


editor['jdhao/better-escape.vim']  = {
}



editor['zegervdv/nrpattern.nvim']  = {

  config = function()
    require"nrpattern".setup()

    end

}

editor['sindrets/diffview.nvim']={
  config = conf.diffview,
  requires= 'f-person/git-blame.nvim'
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
