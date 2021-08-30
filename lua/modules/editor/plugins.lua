local editor = {}
local conf = require('modules.editor.config')

editor['Raimondi/delimitMate'] = {
  opt = true,
  event  = 'InsertEnter',
  config = conf.delimimate,
}

editor['junegunn/vim-easy-align'] = {opt = true, cmd = 'EasyAlign'}

editor['rhysd/accelerated-jk'] = {
  opt = true
}

editor['haya14busa/vim-asterisk'] = {
  opt = true,
}

editor['rmagatti/auto-session'] = {
  -- cmd = {'SaveSession', 'RestoreSession', 'DeleteSession'},
  config = function ()
    require('auto-session').setup {
      auto_session_root_dir = ('%s/session/auto/'):format(vim.fn.stdpath 'data'),
    }
  end
}

editor['takac/vim-hardtime'] = {
  -- opt = true,
  -- cmd = { 'HardTimeOn', 'HardTimeOff', 'HardTimeToggle' },
  config = function()
    vim.g.hardtime_default_on = 1
    vim.g.hardtime_ignore_quickfix = 1
    vim.g.hardtime_allow_different_key = 1
    vim.g.hardtime_maxcount = 5
  end
}

editor['famiu/bufdelete.nvim'] = {
  opt = true,
  cmd = {'Bdelete', 'Bwipeout'}
}


editor['turbio/bracey.vim'] ={
  opt = true,
  run = 'npm install --prefix server',
  cmd = {'Bracey', 'BraceyStop', 'BraceyReload'},
  config = function ()
    vim.g.bracey_refresh_on_save = 0
  end
}



-- editor['norcalli/nvim-colorizer.lua'] = {
--   opt = true,
--   ft = { 'html','css','sass','vim','typescript','typescriptreact'},
--   cmd = {'ColorizerToggle', 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer', 'ColorizerReloadAllBuffers'},
--   config = conf.nvim_colorizer
-- }

-- nvim-colorizer replacement
editor["rrethy/vim-hexokinase"] = {
  -- ft = { 'html','css','sass','vim','typescript','typescriptreact'},
  config = conf.hexokinase,
  run = "make hexokinase",
  opt = true,
  cmd = {"HexokinaseTurnOn", "HexokinaseToggle"}
}

editor['itchyny/vim-cursorword'] = {
  opt = true,
  event = {'BufReadPre','BufNewFile'},
  config = conf.vim_cursorwod,
}

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



editor['dhruvasagar/vim-table-mode'] = {
  cmd = {'TableModeToggle'}
}

editor["hrsh7th/vim-eft"] = {
  opt = true,
  config = function()
    vim.g.eft_ignorecase = true
  end
}

editor['kana/vim-niceblock']  = {
  opt = true
}

editor["tpope/vim-repeat"]  = {}



-- Paste without yank
editor['kana/vim-operator-replace'] = {
  opt = true,
  keys = {{'x','p'}},
  config = function()
    vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)",{silent =true})
  end
}


-- This is rather nice i kinda like it . 
editor['https://github.com/LoricAndre/OneTerm.nvim.git']={
    cmd = { 'OneTerm' }

}



editor['andweeb/presence.nvim']  = {
  event = 'BufReadPre',
  config = conf.discord
}

-- editor['voldikss/vim-floaterm']  = {}

editor['https://github.com/numtostr/FTerm.nvim']={
    config = function()
        require("FTerm").setup()
        local term = require("FTerm.terminal")

        local top = term:new():setup({
            cmd = "bpytop"
        })

         -- Use this to toggle bpytop in a floating terminal
        function _G.__fterm_top()
            top:toggle()
        end


    end
}

--Req Syntax Nice Stuff . 
editor['raimon49/requirements.txt.vim']  = {}




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