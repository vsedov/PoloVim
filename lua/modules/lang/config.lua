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

function config.sqls()
end

function config.sidekick()
  -- body
  vim.g.sidekick_printable_def_types = {
    'function', 'class', 'type', 'module', 'parameter', 'method', 'field'
  }
  -- vim.g.sidekick_def_type_icons = {
  --    class = "\\uf0e8",
  --    type = "\\uf0e8",
  --    ['function'] = "\\uf794",
  --    module = "\\uf7fe",
  --    arc_component = "\\uf6fe",
  --    sweep = "\\uf7fd",
  --    parameter = "•",
  --    var = "v",
  --    method = "\\uf794",
  --    field = "\\uf6de",
  -- }
  -- vim.g.sidekick_ignore_by_def_type = {
  --   ['var'] = {"_": 1, "self": 1},
  --   parameters = {"self": 1},
  -- }

  -- Indicates which definition types should have their line number displayed in the outline window.
  vim.g.sidekick_line_num_def_types = {
    class = 1,
    type = 1,
    ['function'] = 1,
    module = 1,
    method = 1
  }

  -- What to display between definition and line number
  vim.g.sidekick_line_num_separator = " "
  -- What to display to the left and right of the line number
  -- vim.g.sidekick_line_num_left = "\\ue0b2"
  -- vim.g.sidekick_line_num_right = "\\ue0b0"
  -- -- What to display before outer vs inner vs folded outer definitions
  -- vim.g.sidekick_outer_node_folded_icon = "\\u2570\\u2500\\u25C9"
  -- vim.g.sidekick_outer_node_icon = "\\u2570\\u2500\\u25CB"
  -- vim.g.sidekick_inner_node_icon = "\\u251c\\u2500\\u25CB"
  -- -- What to display to left and right of def_type_icon
  -- vim.g.sidekick_left_bracket = "\\u27ea"
  -- vim.g.sidekick_right_bracket = "\\u27eb"
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