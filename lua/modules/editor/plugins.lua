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
  -- use defaulyt config .
}

editor['andweeb/presence.nvim']  = {

  config = function()

    require("presence"):setup({
        -- This config table shows all available config options with their default values
        auto_update       = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua Presence:update()`)
        editing_text      = "Editing %s",               -- Editing format string (either string or function(filename: string|nil, buffer: string): string)
        workspace_text    = "Working on %s",            -- Workspace format string (either string or function(git_project_name: string|nil, buffer: string): string)
        neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
        main_image        = "neovim",                   -- Main image display (either "neovim" or "file")
        client_id         = "793271441293967371",       -- Use your own Discord application client id (not recommended)
        log_level         = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
        debounce_timeout  = 15,                         -- Number of seconds to debounce TextChanged events (or calls to `:lua Presence:update(<buf>, true)`)
    })
    
  end
}

editor['voldikss/vim-floaterm']  = {}







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

editor['rmagatti/alternate-toggler']  = {
}

editor['https://github.com/lambdalisue/suda.vim.git']  = {
}






return editor
