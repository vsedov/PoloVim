local lang = {}
local conf = require('modules.lang.config')

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



lang['https://github.com/p00f/nvim-ts-rainbow'] = {
  config = conf.rainbow,
  after = 'nvim-treesitter',

}


-- Bloody Usefull 
lang['vhyrro/neorg']={
    branch = "unstable",
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
