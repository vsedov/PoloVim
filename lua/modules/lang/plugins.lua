local lang = {}
local conf = require("modules.lang.config")
local path = plugin_folder()

lang["nathom/filetype.nvim"] = {
  -- event = {'BufEnter'},
  setup = function()
    vim.g.did_load_filetypes = 1
  end,
  config = function()
    require("filetype").setup({
      overrides = {
        literal = {
          ["kitty.conf"] = "kitty",
          [".gitignore"] = "conf",
          [".env"] = "sh",
        },
      },
    })
  end,
}

lang["nvim-treesitter/nvim-treesitter"] = {
  opt = true,
  config = conf.nvim_treesitter,
}

lang["nvim-treesitter/nvim-treesitter-textobjects"] = {
  after = "nvim-treesitter",
  config = conf.treesitter_obj,
  opt = true,
}
-- lang["eddiebergman/nvim-treesitter-pyfold"] = {config = conf.pyfold}
lang["RRethy/nvim-treesitter-textsubjects"] = {
  ft = { "lua", "rust", "go", "python", "javascript" },
  opt = true,
  config = conf.tsubject,
}

lang["RRethy/nvim-treesitter-endwise"] = {
  ft = { "lua", "ruby", "vim" },
  event = "InsertEnter",
  opt = true,
  config = conf.endwise,
}

lang["danymat/neogen"] = {
  opt = true,
  requires = { "nvim-treesitter/nvim-treesitter", "rcarriga/nvim-notify" },
  config = function()
    require("neogen").setup({
      languages = {
        lua = {
          template = { annotation_convention = "emmylua" },
        },
        python = {
          template = { annotation_convention = "numpydoc" },
        },
        c = {
          template = { annotation_convention = "doxygen" },
        },
      },
    })
  end,
}

-- Inline functions dont seem to work .
lang["ThePrimeagen/refactoring.nvim"] = {
  opt = true,
  requires = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
  },
  config = conf.refactor,
}

-- Yay gotopreview lazy loaded
lang["rmagatti/goto-preview"] = {
  cmd = { "GotoPrev", "GotoImp", "GotoTel" },
  requires = "telescope.nvim",
  config = conf.goto_preview,
}

lang["nvim-treesitter/nvim-treesitter-refactor"] = {
  after = "nvim-treesitter-textobjects", -- manual loading
  config = conf.treesitter_ref, -- let the last loaded config treesitter
  opt = true,
}

lang["yardnsm/vim-import-cost"] = { cmd = "ImportCost", opt = true }

-- lang['scalameta/nvim-metals'] = {requires = {"nvim-lua/plenary.nvim"}}
lang["lifepillar/pgsql.vim"] = { ft = { "sql", "pgsql" } }

lang["nanotee/sqls.nvim"] = { ft = { "sql", "pgsql" }, setup = conf.sqls, opt = true }

lang["ray-x/go.nvim"] = { ft = { "go", "gomod" }, config = conf.go }

lang["ray-x/guihua.lua"] = {
  run = "cd lua/fzy && make",
  opt = true,
}

-- lang["gcmt/wildfire.vim"] = {
--   setup = function()
--     vim.cmd([[nmap <leader>s <Plug>(wildfire-quick-select)]])
--   end,
--   fn = {'<Plug>(wildfire-fuel)', '<Plug>(wildfire-water)', '<Plug>(wildfire-quick-select)'}
-- }

lang["romgrk/nvim-treesitter-context"] = {
  event = "InsertEnter",
  config = conf.context,
}

lang["max397574/nvim-treehopper"] = {
  module = "tsht",
  config = conf.treehopper,
}

lang["nvim-treesitter/playground"] = {
  -- after = "nvim-treesitter",
  opt = true,
  cmd = "TSPlaygroundToggle",
  config = conf.playground,
}

-- great plugin but not been maintained
-- lang["ElPiloto/sidekick.nvim"] = {opt = true, fn = {'SideKickNoReload'}, setup = conf.sidekick}
lang["stevearc/aerial.nvim"] = {
  opt = true,
  cmd = { "AerialToggle" },
  config = conf.aerial,
}

-- lang["simrat39/symbols-outline.nvim"] = {
--   opt = true,
--   cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
--   setup = conf.outline,
-- }
-- Only for java files help maven.txt
lang["mikelue/vim-maven-plugin"] = {
  ft = "java",
}

lang["mfussenegger/nvim-jdtls"] = {
  ft = "java",
}

-- :lua require'blanket'.start() - start the plugin, useful when filetype property is not set
-- :lua require'blanket'.stop() - stop displaying coverage and cleanup autocmds, watcher etc.
-- :lua require'blanket'.refresh() - manually trigger a refresh of signs, useful when filetype property is not set
-- :lua require'blanket'.set_report_path() - change report_path to a new value and refresh the gutter based on the new report
-- temp for groupwork will remove soon .
lang["dsych/blanket.nvim"] = {
  ft = "java",
  config = function()
    require("blanket").setup({
      -- can use env variables and anything that could be interpreted by expand(), see :h expandcmd()
      -- REQUIRED
      report_path = "/home/viv/GitHub/TeamProject2022_28/ARMS/target/site/jacoco/jacoco.xml",
      -- refresh gutter every time we enter java file
      -- defauls to empty - no autocmd is created
      filetypes = "java",
      -- for debugging purposes to see whether current file is present inside the report
      -- defaults to false
      silent = true,
      -- can set the signs as well
      signs = {
        priority = 10,
        incomplete_branch = "█",
        uncovered = "█",
        covered = "█",
        sign_group = "Blanket",
      },
    })
  end,
}

lang["mfussenegger/nvim-dap"] = {
  opt = true,
  requires = {
    { "theHamsta/nvim-dap-virtual-text", cmd = "Luadev", opt = true },
    { "mfussenegger/nvim-dap-python", ft = "python" },
    { "rcarriga/nvim-dap-ui", opt = true },
  },

  run = ":UpdateRemotePlugins",

  config = conf.dap,
} -- cmd = "Luadev",

-- better python indent

lang["nvim-telescope/telescope-dap.nvim"] = {
  opt = true,
  requires = { "telescope.nvim", "nvim-dap" },
  config = conf.dap,
}

lang["m-demare/hlargs.nvim"] = {
  ft = { "python", "c", "java", "lua" },
  requires = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("hlargs").setup()
  end,
}

lang["JoosepAlviste/nvim-ts-context-commentstring"] = { opt = true }

lang["jbyuki/one-small-step-for-vimkind"] = { opt = true, ft = { "lua" } }

lang["bfredl/nvim-luadev"] = { opt = true, ft = "lua", setup = conf.luadev }

lang["rafcamlet/nvim-luapad"] = {
  cmd = { "LuaRun", "Lua", "Luapad" },
  ft = { "lua" },
  config = function()
    require("luapad").setup({
      count_limit = 150000,
      error_indicator = true,
      eval_on_move = true,
      error_highlight = "WarningMsg",
      on_init = function()
        print("Hello from Luapad!")
      end,
      context = {
        the_answer = 42,
        shout = function(str)
          return (string.upper(str) .. "!")
        end,
      },
    })
  end,
}

lang["mtdl9/vim-log-highlighting"] = { ft = { "text", "log" } }

-- lang["RRethy/vim-illuminate"] = {opt=true, ft = {"go"}}

--
lang["michaelb/sniprun"] = {
  cmd = { "'<,'>SnipRun", "SnipRun" },
  opt = true,
  run = "bash install.sh",
  requires = "rcarriga/nvim-notify",
  config = conf.sniprun,
}

lang["dccsillag/magma-nvim"] = {
  opt = true,
  requires = "rcarriga/nvim-notify",
  run = ":UpdateRemotePlugins",
  config = conf.magma,
}

lang["Vimjas/vim-python-pep8-indent"] = {
  ft = "python",
}
-- Quite nice
lang["ok97465/pycell_deco.nvim"] = {
  ft = "python",
  config = function()
    require("pycell_deco").setup({ cell_name_fg = "#1abc9c", cell_line_bg = nil })
  end,
}

lang["vim-test/vim-test"] = {
  opt = true,
}

-- lua testign
lang["lewis6991/nvim-test"] = {
  ft = "lua", 
  opt = true,
}

lang["rcarriga/vim-ultest"] = {
  requires = { "vim-test/vim-test", opt = true },
  run = ":UpdateRemotePlugins",
  opt = true,
}

-- This might not be needed
lang["mgedmin/coverage-highlight.vim"] = {
  ft = "python",
  opt = true,
  run = ":UpdateRemotePlugins",
}

------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- JqxList and JqxQuery json browsing, format
lang["gennaro-tedesco/nvim-jqx"] = {
  ft = "json",
  cmd = { "JqxList", "JqxQuery" },
  opt = true,
}

lang["windwp/nvim-ts-autotag"] = {
  opt = true,
  -- after = "nvim-treesitter",
  -- config = function() require"nvim-treesitter.configs".setup {autotag = {enable = true}} end
}

lang["Tastyep/structlog.nvim"] = {
  opt = true,
  config = function()
    require("utils.Log")
  end,
}

lang["folke/lua-dev.nvim"] = {
  -- opt = true,
  ft = { "lua" },
  config = conf.lua_dev,
}

lang["nanotee/luv-vimdocs"] = {
  opt = true,
}
-- builtin lua functions
lang["milisims/nvim-luaref"] = {
  opt = true,
}

lang["p00f/nvim-ts-rainbow"] = {
  opt = true,
  -- after = "nvim-treesitter",
  -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
  cmd = "Rainbow",
  config = function()
    require("nvim-treesitter.configs").setup({ rainbow = { enable = true, extended_mode = true } })
  end,
}

lang["onsails/diaglist.nvim"] = {
  cmd = { "DiaglistA", "DiaglistB" },
  opt = true,
  ft = { "python", "c", "lua", "cpp" },
  config = function()
    require("diaglist").init({
      debug = false,
      debounce_ms = 150,
    })
    vim.cmd([[command! -nargs=*  DiaglistA lua require('diaglist').open_all_diagnostics()]])
    vim.cmd([[command! -nargs=*  DiaglistB lua require('diaglist').open_buffer_diagnostics()]])
  end,
}

lang["folke/trouble.nvim"] = {
  cmd = { "Trouble", "TroubleToggle" },
  opt = true,
  config = function()
    require("trouble").setup({})
  end,
}

-- Might use this
lang["folke/todo-comments.nvim"] = {
  cmd = { "TodoTelescope", "TodoTelescope", "TodoTrouble" },
  opt = true,
  config = function()
    require("todo-comments").setup({}) -- Use defualt
  end,
  after = "trouble.nvim",
}

-- -- Can Gonna Use jaq for now ?
-- lang["CRAG666/code_runner.nvim"] = {
--   -- ft = {"c", "java"},
--   requires = "nvim-lua/plenary.nvim",
--   config = function()
--     require("code_runner").setup({
--       term = {
--         position = "belowright",
--         size = 8,
--       },
--       filetype = {
--         java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
--         python = "python -U",
--         typescript = "deno run",
--         rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
--       },
--       project = {
--         ["~/GitHub/TeamProject2022_28/ARMS"] = {
--           name = "ARMS",
--           description = "Project with make file",
--           command = "cd ~/GitHub/TeamProject2022_28/ARMS && mvn! compile && mvn test",
--         },
--       },
--     })
--   end,
-- }

lang["is0n/jaq-nvim"] = {
  cmd = "Jaq",
  after = "filetype.nvim",
  opt = true,
  config = conf.jaq,
}

lang["jose-elias-alvarez/null-ls.nvim"] = {
  opt = true,
  config = require("modules.lang.null-ls").config,
}

return lang
