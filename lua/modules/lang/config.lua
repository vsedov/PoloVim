local config = {}
local api = vim.api

function config.textsubjects()
  require'nvim-treesitter.configs'.setup {
      textsubjects = {
          enable = true,
          keymaps = {
              ['<CR>'] = 'textsubjects-smart',
              [';'] = 'textsubjects-container-outer',
          }
      },
  }
end

function config.rainbow()
  require'nvim-treesitter.configs'.setup {
    rainbow = {
      enable = true,
      extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
      max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
  }
end

function config.textobjects()
  require'nvim-treesitter.configs'.setup {
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
  }
end


function config.nvim_treesitter()
  local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

  parser_configs.norg = {
      install_info = {
          url = "https://github.com/vhyrro/tree-sitter-norg",
          files = { "src/parser.c" },
          branch = "main"
      },
  },


  
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
    
}

end

local ft_str = ""
local autocmd_fold_str = ""

autocmd_fold_str = 'autocmd Filetype '..ft_str..' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()'
api.nvim_command(autocmd_fold_str)

return config

