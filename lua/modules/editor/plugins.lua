local editor = {}

local conf = require("modules.editor.config")

-- alternatives: steelsojka/pears.nvim
-- windwp/nvim-ts-autotag  'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue'
-- windwp/nvim-autopairs

editor["junegunn/vim-easy-align"] = { opt = true, cmd = "EasyAlign" }

editor["windwp/nvim-autopairs"] = {
  -- keys = {{'i', '('}},
  -- keys = {{'i'}},
  requires = "nvim-treesitter",
  after = { "nvim-cmp" }, -- "nvim-treesitter", nvim-cmp "nvim-treesitter", coq_nvim
  -- event = "InsertEnter",  --InsertCharPre
  -- after = "hrsh7th/nvim-compe",
  config = conf.autopairs,
  opt = true,
}

editor["rhysd/accelerated-jk"] = {
  opt = true,
}
editor["kana/vim-niceblock"] = {
  opt = true,
}

-- Remove at any time if you dont want
------------------------------------------------------------------------------
-- MOST IMPORTANT FEATURE OF THEM ALL, I APROVE OF THIS
editor["rtakasuke/vim-neko"] = {
  cmd = "Neko"
}

editor["tamton-aquib/duck.nvim"] = {
  config = function()
    require("duck").setup({
      winblend = 100, -- 0 to 100
      speed = 1, -- optimal: 1 to 99
      width = 2,
    })

    vim.api.nvim_set_keymap("n", "<leader><leader>dd", ':lua require("duck").hatch("🐼")<CR>', { noremap = true })
    vim.api.nvim_set_keymap("n", "<leader><leader>dk", ':lua require("duck").cook("🐼")<CR>', { noremap = true })
  end,
}
editor["https://github.com/raghavdoescode/nvim-owoifier"] = {
  opt = true,
}
------------------------------------------------------------------------------

-- I want this all the time - so im not lazy loading this .,
editor["ggandor/lightspeed.nvim"] = {
  requires = { "tpope/vim-repeat" },
  config = conf.lightspeed,
}

editor["tpope/vim-surround"] = {
  opt = true,
  -- event = 'InsertEnter',
  -- keys={'c', 'd'}
}

-- nvim-colorizer replacement
editor["rrethy/vim-hexokinase"] = {
  -- ft = { 'html','css','sass','vim','typescript','typescriptreact'},
  config = conf.hexokinase,
  run = "make hexokinase",
  opt = true,
  cmd = { "HexokinaseTurnOn", "HexokinaseToggle" },
}

-- <A-k>   Move current line/selection up
-- <A-j>   Move current line/selection down
-- <A-h>   Move current character/selection left
-- <A-l>   Move current character/selection right
editor["matze/vim-move"] = {
  opt = true,
  event = { "CursorMoved", "CursorMovedI" },
  -- fn = {'<Plug>MoveBlockDown', '<Plug>MoveBlockUp', '<Plug>MoveLineDown', '<Plug>MoveLineUp'}
}

-- editor["kevinhwang91/nvim-hlslens"] = {
--   -- keys = {"/", "?", '*', '#'}, --'n', 'N', '*', '#', 'g'
--   -- opt = true,
--   -- config = conf.hlslens
-- }

editor["mg979/vim-visual-multi"] = {
  keys = {
    "<Ctrl>",
    "<M>",
    "<C-n>",
    "<C-n>",
    "<M-n>",
    "<S-Down>",
    "<S-Up>",
    "<M-Left>",
    "<M-i>",
    "<M-Right>",
    "<M-D>",
    "<M-Down>",
    "<C-d>",
    "<C-Down>",
    "<S-Right>",
    "<C-LeftMouse>",
    "<M-LeftMouse>",
    "<M-C-RightMouse>",
    "<Leader>",
  },
  opt = true,
  setup = conf.vmulti,
}

editor["https://github.com/LoricAndre/OneTerm.nvim.git"] = {
  cmd = { "OneTerm" },
}

editor["sudormrfbin/cheatsheet.nvim"] = {
  cmd = { "Cheatsheet" },
  requires = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
}

-- Currently needs to be calle , not sure if i have to lazy load this or not.
editor["andweeb/presence.nvim"] = {
  event = { "BufEnter", "BufRead" },
  config = conf.discord,
}

editor["itchyny/vim-cursorword"] = {
  opt = true,
  config = conf.vim_cursorwod,
}

editor["https://github.com/numtostr/FTerm.nvim"] = {
  opt = true,

  config = function()
    local fterm = require("FTerm")

    local gitui = fterm:new({
      cmd = "gitui",
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
    })

    -- Use this to toggle gitui in a floating terminal
    function _G.__fterm_gitui()
      gitui:toggle()
    end

    local top = fterm:new({ cmd = "bpytop" })

    -- Use this to toggle bpytop in a floating terminal
    function _G.__fterm_top()
      top:toggle()
    end
  end,
}

-- NORMAL mode:
-- `gcc` - Toggles the current line using linewise comment
-- `gbc` - Toggles the current line using blockwise comment
-- `[count]gcc` - Toggles the number of line given as a prefix-count
-- `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- `gb[count]{motion}` - (Op-pending) Toggles the region using linewise comment

-- VISUAL mode:
-- `gc` - Toggles the region using linewise comment
-- `gb` - Toggles the region using blockwise comment

-- NORMAL mode
-- `gco` - Insert comment to the next line and enters INSERT mode
-- `gcO` - Insert comment to the previous line and enters INSERT mode
-- `gcA` - Insert comment to end of the current line and enters INSERT mode

-- NORMAL mode
-- `g>[count]{motion}` - (Op-pending) Comments the region using linewise comment
-- `g>c` - Comments the current line using linewise comment
-- `g>b` - Comments the current line using blockwise comment
-- `g<[count]{motion}` - (Op-pending) Uncomments the region using linewise comment
-- `g<c` - Uncomments the current line using linewise comment
-- `g<b`- Uncomments the current line using blockwise comment

-- VISUAL mode
-- `g>` - Comments the region using single line
-- `g<` - Unomments the region using single line

-- `gcw` - Toggle from the current cursor position to the next word
-- `gc$` - Toggle from the current cursor position to the end of line
-- `gc}` - Toggle until the next blank line
-- `gc5l` - Toggle 5 lines after the current cursor position
-- `gc8k` - Toggle 8 lines before the current cursor position
-- `gcip` - Toggle inside of paragraph
-- `gca}` - Toggle around curly brackets

-- # Blockwise

-- `gb2}` - Toggle until the 2 next blank line
-- `gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
-- `gbac` - Toggle comment around a class (w/ LSP/treesitter support)

editor["numToStr/Comment.nvim"] = {
  opt = true,
  config = conf.comment,
}

-- copy paste failed in block mode when clipboard = unnameplus"
editor["bfredl/nvim-miniyank"] = {
  keys = { "p", "y", "<C-v>" },
  opt = true,
  setup = function()
    vim.api.nvim_command("map p <Plug>(miniyank-autoput)")
    vim.api.nvim_command("map P <Plug>(miniyank-autoPut)")
  end,
}

editor["dhruvasagar/vim-table-mode"] = { cmd = { "TableModeToggle" } }

-- fix terminal color
editor["norcalli/nvim-terminal.lua"] = {
  opt = true,
  ft = { "log", "terminal" },
  config = function()
    require("terminal").setup()
  end,
}

editor["simnalamburt/vim-mundo"] = {
  opt = true,
  cmd = { "MundoToggle", "MundoShow", "MundoHide" },
  run = function()
    vim.cmd([[packadd vim-mundo]])
    vim.cmd([[UpdateRemotePlugins]])
  end,
  setup = function()
    -- body
    vim.g.mundo_prefer_python3 = 1
  end,
}
editor["mbbill/undotree"] = { opt = true, cmd = { "UndotreeToggle" } }
editor["AndrewRadev/splitjoin.vim"] = {
  opt = true,
  cmd = { "SplitjoinJoin", "SplitjoinSplit" },
  setup = function()
    vim.g.splitjoin_split_mapping = ""
    vim.g.splitjoin_join_mapping = ""
  end,
  -- keys = {'<space>S', '<space>J'}
}

editor["chaoren/vim-wordmotion"] = {
  opt = true,
  fn = {
    "<Plug>WordMotion_w",
    "<Plug>WordMotion_b",
    "<Plug>WordMotion_gE",
  },
  keys = { "w", "W", "gE", "b", "B" },
}

editor["folke/zen-mode.nvim"] = {
  opt = true,
  cmd = { "ZenMode" },
  config = function()
    require("zen-mode").setup({})
  end,
}

editor["nvim-neorg/neorg"] = {

  config = function()
    require("packer").loader("plenary.nvim")
    require("packer").loader("nvim-treesitter")
    require("packer").loader("telescope.nvim")

    require("neorg").setup({
      -- Tell Neorg what modules to load
      load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.concealer"] = {}, -- Allows for use of icons
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
          config = { workspaces = { my_workspace = "~/neorg" } },
        },
        ["core.keybinds"] = { -- Configure core.keybinds
          config = {
            default_keybinds = true, -- Generate the default keybinds
            neorg_leader = "<Leader>o", -- This is the default if unspecified
          },
        },
        ["core.integrations.telescope"] = {}, -- Enable the telescope module
      },
    })
  end,
}

editor["psf/black"] = { ft = "python" }

editor["famiu/bufdelete.nvim"] = {
  opt = true,
  cmd = { "Bdelete", "Bwipeout" },
}

editor["filipdutescu/renamer.nvim"] = {
  branch = "master",
  requires = { { "nvim-lua/plenary.nvim" } },

  config = function()
    local mappings_utils = require("renamer.mappings.utils")
    require("renamer").setup({
      -- The popup title, shown if `border` is true
      title = "Rename",
      -- The padding around the popup content
      padding = {
        top = 0,
        left = 0,
        bottom = 0,
        right = 0,
      },
      -- Whether or not to shown a border around the popup
      border = true,
      -- The characters which make up the border
      border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      -- Whether or not to highlight the current word references through LSP
      show_refs = true,
      -- Whether or not to add resulting changes to the quickfix list
      with_qf_list = true,
      -- Whether or not to enter the new name through the UI or Neovim's `input`
      -- prompt
      with_popup = true,
      -- The keymaps available while in the `renamer` buffer. The example below
      -- overrides the default values, but you can add others as well.
      mappings = {
        ["<c-i>"] = mappings_utils.set_cursor_to_start,
        ["<c-a>"] = mappings_utils.set_cursor_to_end,
        ["<c-e>"] = mappings_utils.set_cursor_to_word_end,
        ["<c-b>"] = mappings_utils.set_cursor_to_word_start,
        ["<c-c>"] = mappings_utils.clear_line,
        ["<c-u>"] = mappings_utils.undo,
        ["<c-r>"] = mappings_utils.redo,
      },
      -- Custom handler to be run after successfully renaming the word. Receives
      -- the LSP 'textDocument/rename' raw response as its parameter.
      handler = nil,
    })
  end,
}

editor["raimon49/requirements.txt.vim"] = {}

-- This might not be needed
-- editor["kalekseev/vim-coverage.py"] = {
--   run = ":UpdateRemotePlugins",
-- }

editor["max397574/better-escape.nvim"] = {
  config = function()
    require("better_escape").setup({
      timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      clear_empty_lines = true, -- clear line after escaping if ther is only whitespace      })
    })
  end,
}

editor["zegervdv/nrpattern.nvim"] = {
  opt = true,

  config = function()
    local patterns = require("nrpattern.default")

    -- The dict uses the pattern as key, and has a dict of options as value.
    -- To add a new pattern, for example the VHDL x"aabb" format.
    patterns['()x"(%x+)"'] = {
      base = 16, -- Hexadecimal
      format = '%sx"%s"', -- Output format
      priority = 15, -- Determines order in pattern matching
    }

    -- Change a default setting:
    patterns["(%d*)'h([%x_]+)"].separator.group = 8

    patterns[{ "yes", "no" }] = { priority = 5 }

    -- Call the setup to enable the patterns
    require("nrpattern").setup(patterns)
  end,
}

editor["rmagatti/alternate-toggler"] = {}

-- nEed to add this or add something extra to this.
editor["VonHeikemen/fine-cmdline.nvim"] = {
  opt = true,
  requires = {
    { "MunifTanjim/nui.nvim", opt = true },
  },
}

editor["jbyuki/nabla.nvim"] = {
  opt = true,
  ft = "norg",
  requires = "nvim-lua/popup.nvim",
  config = function() end,
}

return editor
