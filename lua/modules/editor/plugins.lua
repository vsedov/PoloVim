local editor = {}
local conf = require('modules.editor.config')

editor['Raimondi/delimitMate'] = {
  event = 'InsertEnter',
  config = conf.delimimate,
}

editor['junegunn/vim-easy-align'] = {opt = true, cmd = 'EasyAlign'}

editor['rhysd/accelerated-jk'] = {
  opt = true
}

editor['norcalli/nvim-colorizer.lua'] = {
  ft = { 'html','css','sass','vim','typescript','typescriptreact'},
  config = conf.nvim_colorizer
}


editor['haya14busa/vim-asterisk'] = {
  opt = true,
}

-- to get better keep this on . 
editor['takac/vim-hardtime'] = {
  -- cmd = { 'HardTimeOn', 'HardTimeOff', 'HardTimeToggle' },
  config = function()
      vim.g.hardtime_ignore_quickfix = 1
      vim.g.hardtime_allow_different_key = 1
      vim.g.hardtime_maxcount = 3
      vim.g.hardtime_default_on = 1


  end
}


editor['itchyny/vim-cursorword'] = {
  event = {'BufReadPre','BufNewFile'},
  config = conf.vim_cursorwod
}


-- Better version below
editor['ggandor/lightspeed.nvim'] = {

    requires={'https://github.com/tpope/vim-repeat'},
    
    config = function()

      require'lightspeed'.setup {
        automap = true,
        jump_to_first_match = true,
        jump_on_partial_input_safety_timeout = 200,
        -- This can get _really_ slow if the window has a lot of content,
        -- turn it on only if your machine can always cope with it.
        highlight_unique_chars = true,
        grey_out_search_area = true,
        match_only_the_start_of_same_char_seqs = true,
        limit_ft_matches = 10,
        full_inclusive_prefix_key = '<c-x>',

        instant_repeat_fwd_key = nil,
        instant_repeat_bwd_key = nil,

        labels = nil,
        cycle_group_fwd_key = nil,
        cycle_group_bwd_key = nil,
      }


    -- vim.api.nvim_set_keymap('n', 'f', ':HopChar1' {})

    vim.api.nvim_set_keymap('n', 'S', '<Plug>Lightspeed_s', {})
    vim.api.nvim_set_keymap('n', 'ss', '<Plug>Lightspeed_S', {})



    vim.cmd[[nmap <expr> c reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"]]
    vim.cmd[[nmap <expr> C reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"]]
    vim.cmd[[nmap <expr> t reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"]]
    vim.cmd[[nmap <expr> T reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"]]



  end
}

editor['phaazon/hop.nvim']={
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
  end



}

editor['rmagatti/auto-session'] = {
  cmd = {'SaveSession', 'RestoreSession', 'DeleteSession'},
  -- cmd = {'SaveSession', 'RestoreSession', 'DeleteSession'},
  config = function ()
    require('auto-session').setup {
      auto_session_root_dir = ('%s/session/auto/'):format(vim.fn.stdpath 'data'),
      auto_session_enabled = false
    }
  end
}

-- This is rather nice i kinda like it . 
editor['https://github.com/LoricAndre/OneTerm.nvim.git']={
    cmd = { 'OneTerm' }

}


editor['kana/vim-operator-replace'] = {
  keys = {{'x','p'}},
  config = function()
    vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)",{silent =true})
  end,
  requires = 'kana/vim-operator-user'
}

editor['sbdchd/neoformat'] = {opt = true, cmd = 'Neoformat'}


editor['https://github.com/machakann/vim-sandwich']  = {
  -- use default config .
}

-- Pipe keeps losing this will get fixed . 
-- This was causing some string error which i was unsure what it was . 
-- Though I will figure something out , if this is the issue . 



editor['andweeb/presence.nvim']  = {
  event = 'BufReadPre',
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
