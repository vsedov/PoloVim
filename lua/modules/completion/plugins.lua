local completion = {}
local conf = require('modules.completion.config')
local remap = vim.api.nvim_set_keymap

completion['neovim/nvim-lspconfig'] = {
  event = 'BufReadPre',
  config = conf.nvim_lsp,

  requires = {
  {'nvim-lua/lsp_extensions.nvim'},
  {'tjdevries/nlua.nvim'},
  {'https://github.com/onsails/lspkind-nvim'},
  {'folke/lsp-colors.nvim'},
  {'https://github.com/mfussenegger/nvim-jdtls'},


  -- {'nathunsmitty/nvim-ale-diagnostic',opt=true}
  }
}


completion['folke/todo-comments.nvim']  = {
  opt=true,
  config = conf.todo_comments,
  after = 'trouble.nvim'
}

completion["hrsh7th/nvim-cmp"] = {
  event = "InsertEnter", -- InsertCharPre
  requires = {
    {'ray-x/lsp_signature.nvim',after= "nvim-lspconfig"},
    {"hrsh7th/cmp-buffer", after = "nvim-cmp"},
    {"hrsh7th/cmp-nvim-lua", after = "nvim-cmp"},
    {"hrsh7th/cmp-vsnip", after = "nvim-cmp"},
    {"hrsh7th/cmp-calc", after = "nvim-cmp"},
    {"hrsh7th/cmp-path", after = "nvim-cmp"},
    {"https://github.com/ray-x/cmp-treesitter", after = "nvim-cmp"},
    {"hrsh7th/cmp-nvim-lsp", after = "nvim-cmp"},
    {"f3fora/cmp-spell", after = "nvim-cmp"},
    {"octaltree/cmp-look", after = "nvim-cmp"},
    {"dcampos/cmp-snippy",after = {"nvim-snippy", "nvim-cmp"}},
    {"quangnguyen30192/cmp-nvim-ultisnips", event = "InsertCharPre", after = "nvim-cmp" },
      {"hrsh7th/cmp-vsnip", after = "nvim-cmp"},
    -- {"saadparwaiz1/cmp_luasnip", after = {"nvim-cmp", "LuaSnip"}},
    {'tzachar/cmp-tabnine',
            run = './install.sh',
            after = 'cmp-spell',
            config = conf.tabnine
    }
  },
    config = conf.cmp,
}

-- can not lazyload, it is also slow...
completion["L3MON4D3/LuaSnip"] = { -- need to be the first to load
  event = "InsertEnter",
  requires = {"rafamadriz/friendly-snippets", event = "InsertEnter"}, -- , event = "InsertEnter"
  config = conf.luasnip
}

completion["kristijanhusak/vim-dadbod-completion"] = {
  event = "InsertEnter",
  ft = {'sql'},
  setup = function()
    vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
    vim.cmd([[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]])
    -- body
  end
}

completion["SirVer/ultisnips"]={
  requires = "honza/vim-snippets",
  config = function()
    -- vim.g.UltiSnipsRemoveSelectModeMappings = 0
    vim.g.UltiSnipsExpandTrigger = "<C-s>"      
  vim.g.UltiSnipsJumpForwardTrigger = "<C-j>" 
  vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"
  end,
}



completion["dcampos/nvim-snippy"] = {
  opt = true,
  -- event = "InsertEnter",
  -- requires = {"honza/vim-snippets", event = "InsertEnter"}, --event = "InsertEnter"
  config = function()
    require'snippy'.setup {}
    -- body
    -- vim.cmd([[imap <expr> <Tab> snippy#can_expand_or_advance() ? '<Plug>(snippy-expand-or-next)' : '<Tab>']])
    -- vim.cmd([[imap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<Tab>']])
    -- vim.cmd([[smap <expr> <Tab> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<Tab>']])
    -- vim.cmd([[smap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<Tab>']])
  end
  -- after = "vim-snippets"
}




completion['https://github.com/folke/trouble.nvim'] = {
  config = conf.trouble,

}


completion['dense-analysis/ale'] = {

  config = conf.ale

}



completion['windwp/nvim-autopairs'] = {
    after = 'nvim-cmp',
    config = conf.autopairs
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




completion['Pocco81/AbbrevMan.nvim'] = {
  opt = true,
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
-- -- Currenty Broken , give a few days to see if it will be back up or not .



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
    {'Pocco81/DAPInstall.nvim'},
  },
  run = ':UpdateRemotePlugins',


  config = function()

  require('dapstuff.dapstuff')
  
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

completion['mattn/emmet-vim'] = {
  event = 'InsertEnter',
  ft = {'html','css','javascript','javascriptreact','vue','typescript','typescriptreact'},
  config = conf.emmet,
}

return completion



















-- completion["ms-jpq/coq_nvim"] = {
--   -- event = "InsertCharPre",
--   after = {"coq.artifacts"},
--   branch = 'coq',

--   config = function()
--   vim.g.coq_settings = {
--     ['clients.lsp.weight_adjust'] = 0.7,
--     ['clients.tabnine.weight_adjust'] = 0.6,
--     ['clients.snippets.weight_adjust'] = 0.5,
--     ['clients.paths.weight_adjust'] = 0.4,
--     ['clients.buffers.weight_adjust'] = 0.3,
--     ['display.icons.mode'] = 'long',
--     ['display.pum.source_context'] = { '[', ']' },
--     ['display.pum.kind_context'] = { ' ', ' ' },
--     ['match.proximate_lines']=25,
--     ['match.fuzzy_cutoff'] = 0.5,

--     keymap = {
--           recommended  = true,
--           jump_to_mark = '<c-k>',
--           -- manual_complete ='<cr>',
--           bigger_preview = '<c-l>',
--     },

--     clients = {
--           lsp = {enabled = true},
--           snippets = {enabled = true},
--           tabnine = {enabled = true},
--           tree_sitter = {enabled = true},

--       },
--     display = {
--         pum={fast_close = false},

--       },


--   }
--   vim.defer_fn(function() vim.opt.completeopt = 'menuone,noinsert' end, 1000) -- has to be deferred since COQ changes this setting
--   vim.cmd([[COQnow --shut-up]])
--   end
-- }


-- completion["ms-jpq/coq.artifacts"] = {
--   -- opt = true,
--   event = "InsertEnter",
--   branch = 'artifacts'
-- }

