local config = {}
local api = vim.api


function config.nvim_treesitter()
  vim.api.nvim_command('set foldmethod=expr')
  vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
    },
    indent = {
      enable = true
    },
    fold = {
      enable = true
    },
    textobjects = {
            select = {
              enable = true,
              disable = {},
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aC"] = "@conditional.outer",
                ["iC"] = "@conditional.inner",
                ["ae"] = "@block.outer",
                ["ie"] = "@block.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["is"] = "@statement.inner",
                ["as"] = "@statement.outer",
                ["ad"] = "@lhs.inner",
                ["id"] = "@rhs.inner",
                ["am"] = "@call.outer",
                ["im"] = "@call.inner"
              }
            },
            move = {
              enable = true,
              goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
              },
              goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
              },
              goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
              },
              goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
              },
            },
          },


  -- Very nice very nice indeed . 
  textsubjects = {
      enable = true,
      keymaps = {
            ['<CR>'] = 'textsubjects-smart',
      }
  },

}

end

local ft_str = ""
local autocmd_fold_str = ""

autocmd_fold_str = 'autocmd Filetype '..ft_str..' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()'
api.nvim_command(autocmd_fold_str)

return config

