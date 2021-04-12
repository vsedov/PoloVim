local api = vim.api
local configs = require 'nvim-treesitter.configs'
local parsers = require 'nvim-treesitter.parsers'
 
require "nvim-treesitter.utils"

require "nvim-treesitter.configs".setup{
      ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages

      highlight = {
        enable = true, -- false will disable the whole extension
        disable = {} -- list of language that will be disabled
      },
      query_linter = {
        enable = true
      },
      playground = {
        enable = true
      },
      incremental_selection = {
        -- this enables incremental selection
        enable = true,
        disable = {},
        keymaps = {
          init_selection = "<enter>", -- maps in normal mode to init the node/scope selection
          node_incremental = "<enter>", -- increment to the upper named parent
          scope_incremental = "Ts", -- increment to the upper scope (as defined in locals.scm)
          node_decremental = "<bs>"
        }
      },
      textobjects = {
        select = {
          enable = true,
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
            ["im"] = "@call.inner"
          }
        },
        swap = {
          enable = true,
          swap_next = {
            ["<a-l>"] = "@parameter.inner",
            ["<a-f>"] = "@function.outer",
            ["<a-s>"] = "@statement.outer"
          },
          swap_previous = {
            ["<a-L>"] = "@parameter.inner",
            ["<a-F>"] = "@function.outer",
            ["<a-S>"] = "@statement.outer"
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
        }
      },
      fold = {
        enable = true
      },

        highlight_definitions = {
          enable = false,
          disable = {"cpp", "c"}
        },
        smart_rename = {
          enable = true,
          disable = {},
          keymaps = {
            smart_rename = "grr"
          }
        },
        navigation = {
          enable = true,
          disable = {},
          keymaps = {
            goto_definition = "gnd",
            list_definitions = "gnD",
            goto_next_usage = "<a-*>",
            goto_previous_usage = "<a-#>"
          }
        },
      }

-- turn on treesitter folding for supported languages
-- TODO: submit a patch that enables folding as a nvim-treesitter module
local ft_str = ""
local autocmd_fold_str = ""

for _, ft in pairs(parsers.available_parsers()) do
    if (ft == "c_sharp") then
        ft_str = ft_str..'cs'..','
    else
        ft_str = ft_str..ft..','
    end
end

--autocmd_fold_str = 'autocmd Filetype '..ft_str..' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()'
--api.nvim_command(autocmd_fold_str)


