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


-- lang['https://github.com/haringsrob/nvim_context_vt'] = {
--   after = 'nvim-treesitter',

-- }

lang['https://github.com/RRethy/nvim-treesitter-textsubjects'] = {
  config = conf.textsubjects,
  after = 'nvim-treesitter',

}

lang["lifepillar/pgsql.vim"] = {ft = {"sql", "pgsql"}}

lang["nanotee/sqls.nvim"] = {ft = {"sql", "pgsql"}, setup = conf.sqls, opt = true}


lang["wellle/context.vim"] = {
  after = "nvim-treesitter",
  opt = true,
  -- cmd = {"ContextEnable", "ContextActivate", "ContextToggle", "ContextToggleWindow", "ContextPeek"},
  setup = function()
    vim.g.context_enabled = 1
    vim.g.context_max_height = 6
    vim.g.context_filetype_blacklist = {'clap_input', ''}
  end,
  config = function()
    vim.cmd([[ContextActivate]])
    -- vim.cmd([[ContextEnable]])  -- enable on command as it has performance issue
  end
}

lang["ElPiloto/sidekick.nvim"] = {opt = true, fn = {'SideKickNoReload'}, setup = conf.sidekick}
lang["jbyuki/one-small-step-for-vimkind"] = {opt = true, ft = {"lua"}}
lang["mtdl9/vim-log-highlighting"] = {ft = {"text", "log"}}


lang["windwp/nvim-ts-autotag"] = {
  opt = true
  -- after = "nvim-treesitter",
  -- config = function() require"nvim-treesitter.configs".setup {autotag = {enable = true}} end
}


-- Bloody Usefull 
lang['vhyrro/neorg']={
    branch = "main",
    ft = "norg",
    config = function()
        if not packer_plugins['plenary.nvim'].loaded then
          vim.cmd [[packadd plenary.nvim]]
        end
        require('neorg').setup {
            -- Tell Neorg what modules to load
            load = {
                ["core.defaults"] = {}, -- Load all the default modules
                ["core.keybinds"] = { -- Configure core.keybinds
                    config = {
                        default_keybinds = true, -- Generate the default keybinds
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


    after = 'nvim-treesitter',

}

return lang
