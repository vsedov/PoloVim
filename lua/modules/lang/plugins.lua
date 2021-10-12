local lang = {}
local conf = require('modules.lang.config')
lang['tpope/vim-liquid'] = {
  ft = {'liquid'}
}


lang['pseewald/vim-anyfold'] = {
  cmd = 'AnyFoldActivate'
}


lang['nvim-treesitter/nvim-treesitter'] = {
  event = 'BufRead',
  after = 'telescope.nvim',
  config = conf.nvim_treesitter,
}

lang['nvim-treesitter/nvim-treesitter-textobjects'] = {
  config = conf.textobjects,

  after = 'nvim-treesitter'
}


lang['https://github.com/haringsrob/nvim_context_vt'] = {
  after = 'nvim-treesitter',

}

lang['https://github.com/RRethy/nvim-treesitter-textsubjects'] = {
  config = conf.textsubjects,
  after = 'nvim-treesitter',

}

lang["lifepillar/pgsql.vim"] = {ft = {"sql", "pgsql"}}

lang["nanotee/sqls.nvim"] = {ft = {"sql", "pgsql"}, setup = conf.sqls, opt = true}


lang["ElPiloto/sidekick.nvim"] = {cmd = {'SideKickNoReload'}, config = conf.sidekick}
lang["jbyuki/one-small-step-for-vimkind"] = {opt = true, ft = {"lua"}}
lang["mtdl9/vim-log-highlighting"] = {ft = {"text", "log"}}


lang["windwp/nvim-ts-autotag"] = {
  opt = true,
  -- after = "nvim-treesitter",
  config = function() require"nvim-treesitter.configs".setup {autotag = {enable = true}} end
}

lang['nvim-lua/plenary.nvim']={

}

-- Bloody Usefull 
lang['vhyrro/neorg']={
    config = function()
        require('neorg').setup {
            -- Tell Neorg what modules to load
            load = {
                ["core.defaults"] = {}, -- Load all the default modules
                ["core.keybinds"] = { -- Configure core.keybinds
                    config = {
                        default_keybinds = true, -- Generate the default keybinds
                        neorg_leader = "<Leader>v" -- This is the default if unspecified
                    }
                },
                ["core.norg.completion"] = {
                  config = {
                    engine = "nvim-cmp" -- We current support nvim-compe and nvim-cmp only
                  }
                },
                ["core.norg.concealer"] = {}, -- Allows for use of icons
                ["core.norg.dirman"] = { -- Manage your directories with Neorg
                    config = {
                        workspaces = {
                            my_workspace = "~/neorg"
                        }
                    }
                }
            },
        }
    end,
    requires = "nvim-lua/plenary.nvim",
    after =  {'nvim-treesitter',"nvim-cmp"}
}
return lang
