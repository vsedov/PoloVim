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

-- tools['glepnir/prodoc.nvim'] = {
--   event = 'BufReadPre'
-- }

tools['b3nj5m1n/kommentary'] = {
  config = conf.kommentary,
}


--Add history one to find previous history and keybinds .


tools['relastle/vim-nayvy'] ={

  config = function ()
    vim.g.nayvy_import_config_path = '$HOME/nayvy.py'
  end
}


-- Good way for me to record how much or what i code in mostly  
tools['wakatime/vim-wakatime'] ={
}

--Reload init
tools['famiu/nvim-reload'] ={
}


--Moving stuff 
tools['camspiers/animate.vim'] ={
}





tools['w0rp/ale'] = {
  config = function ()

    vim.g.ale_completion_enabled = 0
    vim.g.ale_python_pylint_options = '--rcfile ~/.config/pylintrc'
    vim.g.ale_python_mypy_options = ''
    vim.g.ale_list_window_size =  4
    vim.g.ale_sign_column_always = 0
    vim.g.ale_open_list = 1


    vim.g.ale_set_loclist = 0

    vim.g.ale_set_quickfix = 1
    vim.g.ale_keep_list_window_open = 1
    vim.g.ale_list_vertical = 0

    vim.g.ale_lint_on_save = 1

    vim.g.ale_sign_error = '‼'
    vim.g.ale_sign_warning = '∙'
    vim.g.ale_lint_on_text_changed = 1

    vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'

    vim.g.ale_lint_on_insert_leave = 0
    vim.g.ale_lint_on_enter = 0


    vim.g.ale_set_balloons = 1
    vim.g.ale_hover_cursor = 1
    vim.g.ale_hover_to_preview = 1
    vim.g.ale_float_preview = 1
    vim.g.ale_virtualtext_cursor = 1

    vim.g.ale_fix_on_save = 1
    vim.g.ale_fix_on_insert_leave = 0
    vim.g.ale_fix_on_text_changed = 'never'



  end
}
tools['euclidianAce/BetterLua.vim'] = {}


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

tools['nacro90/numb.nvim'] = {
  config = function ()
  require('numb').setup()  end
}


tools['jbyuki/nabla.nvim'] = {
}


-- this is  a still work in progress . 
tools['vhyrro/neorg'] = {

config = function()

  require('neorg').setup {
    load = {
      ['core.defaults'] = {} -- Load all the default modules
    },

    -- Tells neorg where to load community provided modules. If unspecified, this is the default
    community_module_path = vim.fn.stdpath("cache") .. "/neorg_community_modules"
  }

end
}










return tools
