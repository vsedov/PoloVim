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
              lookahead = true,
              disable = {},
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aC"] = "@class.outer",
                ["iC"] = "@class.inner",


                ["ac"] = "@conditional.outer",
                ["ic"] = "@conditional.inner",


                ["ae"] = "@block.outer",
                ["ie"] = "@block.inner",


                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",


                ["is"] = "@statement.inner",
                ["as"] = "@statement.outer",


                ["ad"] = "@lhs.inner",
                ["id"] = "@rhs.inner",

                ["am"] = "@call.outer",
                ["im"] = "@call.inner",

                ["iM"] = "@frame.inner",
                ["aM"] = "@frame.outer",

                ["ai"] = "@parameter.outer",
                ["ii"] = "@parameter.inner",

                ["aS"] = { "@scope", "locals" }, -- selects `@scope` from locals.scm
              },
            },
            matchup = {
                enable = true,              -- mandatory, false will disable the whole extension
                disable = {  "ruby" },  -- optional, list of language that will be disabled
              },


            swap = {
              enable = true,
              swap_next = {
                ["<leader>a"] = "@parameter.inner",
                ["<a-f>"] = "@function.outer",
                ["<a-s>"] = { "@scope", "locals" },
              },
              swap_previous = {
                ["<leader>A"] = "@parameter.inner",
                ["<a-F>"] = "@function.outer",
                ["<a-S>"] = { "@scope", "locals" },
              },
            },
            lsp_interop = {
              enable = true,
              peek_definition_code = {
                ["df"] = "@function.outer",
                ["dF"] = "@class.outer",
              },
              peek_type_definition_code = {
                ["def"] = "@class.outer",
              },
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

-- 10 11 17 18 