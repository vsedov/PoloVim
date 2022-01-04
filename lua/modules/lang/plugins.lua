local lang = {}
local conf = require("modules.lang.config")
local path = plugin_folder()

lang["nathom/filetype.nvim"] = {
  -- event = {'BufEnter'},
  setup = function()
    vim.g.did_load_filetypes = 1
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

-- Better plugin for this i think ,
lang["danymat/neogen"] = {
  module = { "neogen" },
  opt = true,
  requires = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("neogen").setup({
      enabled = true,
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
  setup = conf.aerial,
  config = function()
    local aerial = require("aerial")
    aerial.register_attach_cb(function(bufnr)
      -- Toggle the aerial window with <leader>a
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<F8>", "<cmd>AerialToggle!<CR>", {})
      -- Jump forwards/backwards with '{' and '}'
      vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
      vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
      -- Jump up the tree with '[[' or ']]'
      vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
      vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>AerialNextUp<CR>", {})
    end)
  end,
}
lang["simrat39/symbols-outline.nvim"] = {
  opt = true,
  cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
  setup = conf.outline,
}
lang["bfredl/nvim-luadev"] = { opt = true, ft = "lua", setup = conf.luadev }

lang["mfussenegger/nvim-dap"] = {
  requires = {
    { "theHamsta/nvim-dap-virtual-text", cmd = "Luadev", opt = true },
    { "mfussenegger/nvim-dap-python", ft = "python" },
    { "rcarriga/nvim-dap-ui", opt = true },
  },

  run = ":UpdateRemotePlugins",

  config = conf.dap,
} -- cmd = "Luadev",

lang["JoosepAlviste/nvim-ts-context-commentstring"] = { opt = true }

lang["jbyuki/one-small-step-for-vimkind"] = { opt = true, ft = { "lua" } }

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

lang["nvim-telescope/telescope-dap.nvim"] = {
  requires = { "telescope.nvim", "nvim-dap" },
  config = conf.dap,
}

lang["mtdl9/vim-log-highlighting"] = { ft = { "text", "log" } }

-- lang["RRethy/vim-illuminate"] = {opt=true, ft = {"go"}}

------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

lang["Shatur/neovim-cmake"] = {
  opt = true,
  ft = { "c", "cpp" },
  requires = { { "nvim-lua/plenary.nvim" } },
  after = { "telescope.nvim" },
  config = function()
    -- vim.cmd([[packadd nvim-dap]])
    local Path = require("plenary.path")
    require("cmake").setup({
      type = "codelldb",
      request = "launch",
      stopOnEntry = false,
      runInTerminal = true,
    })
  end,
}

--
lang["michaelb/sniprun"] = {
  cmd = {"'<,'>SnipRun", "SnipRun"},
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

lang["vim-test/vim-test"] = {
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
lang["gennaro-tedesco/nvim-jqx"] = { opt = true, cmd = { "JqxList", "JqxQuery" } }

lang["windwp/nvim-ts-autotag"] = {
  opt = true,
  -- after = "nvim-treesitter",
  -- config = function() require"nvim-treesitter.configs".setup {autotag = {enable = true}} end
}

lang["folke/lua-dev.nvim"] = {
  opt = true,
  -- ft = {'lua'},
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

lang["folke/trouble.nvim"] = {
  cmd = { "Trouble", "TroubleToggle" },
  config = function()
    require("trouble").setup({})
  end,
}

-- lang["folke/todo-comments.nvim"] = {
--   cmd = { "TodoTelescope", "TodoTelescope", "TodoTrouble" },
--   requires = "nvim-lua/plenary.nvim",
--   opt = true,
--   config = function()
--     require("todo-comments").setup({})
--   end,
--   after = "trouble.nvim",
-- }

-- Can Gonna Use jaq for now ?
-- lang["CRAG666/code_runner.nvim"] = {
--   branch = "main",
--   requires = "nvim-lua/plenary.nvim",
--   config = function()
--     require("code_runner").setup({
--     })
--   end,
-- }

-- command Neorunner - depends if i will keep this trying out new stuff .
lang["BenGH28/neo-runner.nvim"] = {
  opt = true,
  after = "filetype.nvim",
  config = conf.neorunner,
  run = ":UpdateRemotePlugins",
}


lang["is0n/jaq-nvim"] = {
  cmd = "Jaq",
  after = "filetype.nvim",
  opt = true,
  config = conf.jaq,
}

-- lang["ldelossa/calltree.nvim"] = {
--   cmd = { "CTExpand", "CTCollapse", "CTSwitch", "CTJump", "CTFocus" },
--   config = function()
--     require("calltree").setup({})
--   end,
-- }

lang["jose-elias-alvarez/null-ls.nvim"] = {
  opt = true,
  event = "InsertEnter",
  config = require("modules.lang.null-ls").config,
}

return lang
