local tools = {}
local conf = require("modules.tools.config")

tools["kristijanhusak/vim-dadbod-ui"] = {
  cmd = { "DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer", "DBUIRenameBuffer", "DB" },
  config = conf.vim_dadbod_ui,
  requires = { "tpope/vim-dadbod", ft = { "sql" } },
  opt = true,
  setup = function()
    vim.g.dbs = {
      eraser = "postgres://postgres:password@localhost:5432/eraser_local",
      staging = "postgres://postgres:password@localhost:5432/my-staging-db",
      wp = "mysql://root@localhost/wp_awesome",
      uni = "sqlite:/home/viv/GitHub/TeamProject2022_28/ARMS/src/main/resources/db/DummyARMS.sql",
    }
  end,
}
tools["j-hui/fidget.nvim"] = {
  ft = { "python", "lua", "c" },
  config = function()
    require("fidget").setup({})
  end,
}
tools["editorconfig/editorconfig-vim"] = {
  opt = true,
  cmd = { "EditorConfigReload" },
  -- ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools["rktjmp/paperplanes.nvim"] = {
  cmd = { "PP" },
  opt = true,
  config = conf.paperplanes,
}

tools["ThePrimeagen/harpoon"] = {
  opt = true,
  config = function()
    require("harpoon").setup({
      global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
         -- set marks specific to each git branch inside git repository
        mark_branch = true,
      },
    })
    require("telescope").load_extension("harpoon")
  end,
}

tools["natecraddock/workspaces.nvim"] = {
  opt = true,
  config = function()
    require("workspaces").setup({
      hooks = {
        open = { "Telescope find_files" },
      },
    })
    require("telescope").load_extension("workspaces")
  end,
}

tools["ThePrimeagen/git-worktree.nvim"] = {
  event = { "CmdwinEnter", "CmdlineEnter" },
  config = conf.worktree,
}

-- Packer

-- github GH ui
tools["pwntester/octo.nvim"] = {
  cmd = { "Octo" },
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "kyazdani42/nvim-web-devicons",
  },
  config = function()
    require("octo").setup()
  end,
}
tools["jghauser/mkdir.nvim"] = {
  opt = true,
  event = "CmdlineEnter",
  config = [[require'mkdir']],
}

-- tools["wellle/targets.vim"] = {}
tools["TimUntersberger/neogit"] = {
  opt = true,
  cmd = { "Neogit" },
  config = function()
    local neogit = require("neogit")
    neogit.setup({})
  end,
}

tools["ruifm/gitlinker.nvim"] = {
  keys = "<leader>gy",
  config = function()
    require("gitlinker").setup()
  end,
}

tools["liuchengxu/vista.vim"] = { cmd = "Vista", setup = conf.vim_vista, opt = true }

------------- Spelling and Grammer
tools["kamykn/spelunker.vim"] = {
  opt = true,
  fn = { "spelunker#check" },
  setup = conf.spelunker,
  config = conf.spellcheck,
}

tools["lewis6991/spellsitter.nvim"] = {
  ft = { "norg", "markdown" },
  config = function()
    require("spellsitter").setup()
  end,
}
tools["rhysd/vim-grammarous"] = {
  opt = true,
  cmd = { "GrammarousCheck" },
  ft = { "markdown", "txt", "norg" },
  setup = conf.grammarous,
}
-------------

tools["plasticboy/vim-markdown"] = {
  ft = "markdown",
  requires = { "godlygeek/tabular" },
  cmd = { "Toc" },
  setup = conf.markdown,
  opt = true,
}

tools["ekickx/clipboard-image.nvim"] = {
  ft = { "norg", "markdown" },
  opt = true,
  config = conf.clipboardimage,
}

tools["iamcco/markdown-preview.nvim"] = {
  ft = { "markdown", "pandoc.markdown", "rmd" },
  cmd = { "MarkdownPreview" },
  setup = conf.mkdp,
  run = [[sh -c "cd app && yarn install"]],
  opt = true,
}

tools["turbio/bracey.vim"] = {
  ft = { "html", "javascript", "typescript" },
  cmd = { "Bracey", "BraceyEval" },
  run = 'sh -c "npm install --prefix server"',
  opt = true,
}

tools["akinsho/toggleterm.nvim"] = {
  keys = { "<c-t>", "<leader>gh", "<leader>tf", "<leader>tv", "<leader>tr" },
  config = function()
    require("modules.tools.toggleterm")
  end,
}

--
tools["nanotee/zoxide.vim"] = { cmd = { "Z", "Lz", "Zi" } }

tools["liuchengxu/vim-clap"] = {
  cmd = { "Clap" },
  run = function()
    vim.fn["clap#installer#download_binary"]()
  end,
  setup = conf.clap,
  config = conf.clap_after,
}

-- For this to record, cmd might not work
tools["wakatime/vim-wakatime"] = {
  event = "InsertEnter",
  cmd = {
    "WakaTimeApiKey",
    "WakaTimeDebugEnable",
    "WakaTimeDebugDisable",
    "WakaTimeScreenRedrawEnable",
    "WakaTimeScreenRedrawEnableAuto",
    "WakaTimeScreenRedrawDisable",
    "WakaTimeToday",
  },
}

tools["sindrets/diffview.nvim"] = {
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
    "DiffviewRefresh",
  },
  config = conf.diffview,
}

tools["lewis6991/gitsigns.nvim"] = {
  config = conf.gitsigns,
  -- keys = {']c', '[c'},  -- load by lazy.lua
  opt = true,
}

-- ze black magic
tools["windwp/nvim-spectre"] = {
  module = "spectre",
  requires = { "nvim-lua/plenary.nvim" },
  keys = {
    "<Leader><Leader>Ss",
    "<Leader><Leader>Sw",
    "<Leader><Leader>Sv",
    "<Leader><Leader>Sc",
  },

  config = function()
    local status_ok, spectre = pcall(require, "spectre")
    if not status_ok then
      return
    end
    spectre.setup()
  end,
}

tools["ray-x/sad.nvim"] = {
  cmd = { "Sad" },
  requires = "ray-x/guihua.lua",
  opt = true,
  config = function()
    require("sad").setup({
      diff = "delta", -- you can use `diff`, `diff-so-fancy`
      ls_file = "fd", -- also git ls_file
      exact = false, -- exact match
    })
  end,
}

tools["ray-x/viewdoc.nvim"] = {
  requires = "ray-x/guihua.lua",
  cmd = { "Viewdoc" },
  opt = true,
  config = function()
    require("viewdoc").setup({ debug = true, log_path = "~/tmp/neovim_debug.log" })
  end,
}

-- early stage...
tools["tanvirtin/vgit.nvim"] = { -- gitsign has similar features
  setup = function()
    vim.o.updatetime = 2000
  end,
  cmd = { "VGit" },
  -- after = {"telescope.nvim"},
  opt = true,
  config = conf.vgit,
}

tools["tpope/vim-fugitive"] = {
  cmd = { "Gvsplit", "Git", "Gedit", "Gstatus", "Gdiffsplit", "Gvdiffsplit" },
  opt = true,
}

tools["LhKipp/nvim-git-fixer"] = {
  cmd = { "FixUp", "Ammend" },
  opt = true,
  config = function()
    require("fixer").setup({})
    vim.cmd([[command! -nargs=*  FixUp lua require('fixer/picker/telescope').commit{hunk_only=true, type="fixup"} ]])
    vim.cmd([[command! -nargs=*  Ammend lua require('fixer/picker/telescope').commit{type="amend"} ]])
  end,
}

-- need quick fix  :vimgrep /\w\+/j % | copen
tools["kevinhwang91/nvim-bqf"] = {
  opt = true,
  ft = "qf",
  event = { "CmdlineEnter", "QuickfixCmdPre" },
  config = conf.bqf,
}

tools["ahmedkhalf/project.nvim"] = {
  module = "project",
  ft = { "python", "java", "c", "cpp", "lua" },
  opt = true,
  after = { "telescope.nvim" },
  config = conf.project,
}

tools["jvgrootveld/telescope-zoxide"] = {
  opt = true,
  after = { "telescope.nvim" },
  config = function()
    require("utils.telescope")
    require("telescope").load_extension("zoxide")
  end,
}

tools["tami5/sqlite.lua"] = {
  module = "sqlite",
}
-- manual call
tools["AckslD/nvim-neoclip.lua"] = {
  opt = true,
  requires = { "tami5/sqlite.lua" },
  config = conf.neoclip,
}

-- This can be lazy loaded probably, figure out how ?
tools["camspiers/animate.vim"] = {
  opt = true,
}

tools["chentau/marks.nvim"] = {
  opt = true,
  event = { "BufReadPost" },
  config = function()
    require("marks").setup({
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {},
      bookmark_0 = {
        sign = "⚑",
        virt_text = "BookMark",
      },
      mappings = {},
    })
  end,
}

tools["Krafi2/jeskape.nvim"] = {
  event = "InsertEnter",
  config = function()
    require("jeskape").setup({
      mappings = {
        ["\\"] = {
          i = "<cmd>Clap | startinsert<cr>",
          f = "<cmd>Clap grep ++query=<cword> |  startinsert<cr>",
        },
        j = {
          k = "<esc>",
          j = "<esc>o",
        },
      },
    })
  end,
}

tools["fladson/vim-kitty"] = {
  ft = { "*.conf" },
}

tools["marekzidek/vim-nayvy"] = {
  ft = "python",
  run = ":UpdateRemotePlugins",
  config = function()
    vim.g.nayvy_import_config_path = "$HOME/nayvy.py"
  end,
}

-- Dont know why, but i kinda enjoy this
tools["sQVe/sort.nvim"] = {
  cmd = "Sort",
  config = function()
    require("sort").setup({})
  end,
}
return tools
