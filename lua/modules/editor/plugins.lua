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

editor["kana/vim-niceblock"] = {
  opt = true,
}

-- I want this all the time - so im not lazy loading this .,
editor["ggandor/lightspeed.nvim"] = {
  as = "lightspeed",
  requires = { "tpope/vim-repeat", opt = true },
  config = conf.lightspeed,
}

editor["hrsh7th/vim-searchx"] = {
  event = { "CmdwinEnter", "CmdlineEnter" },
  setup = conf.searchx,
}

-- folke BROKEN
editor["zeertzjq/which-key.nvim"] = {
  branch = "patch-1",
  opt = true,
  after = "nvim-treesitter",
  config = function()
    require("modules.editor.which_key")
  end,
}

-- -- HOP BROKEN
-- editor["indianboy42/hop-extensions"] = { after = "hop", opt = true }
editor["phaazon/hop.nvim"] = {
  as = "hop",
  cmd = { "HopWord", "HopWordBC", "HopWordAC", "HopLineStartAC", "HopLineStartBC", "HopeLine" },
  config = function()
    require("hop").setup({ keys = "adghklqwertyuiopzxcvbnmfjADHKLWERTYUIOPZXCVBNMFJ1234567890" })
  end,
}

editor["blackCauldron7/surround.nvim"] = {
  config = function()
    require("surround").setup({
      mappings_style = "surround",
      pairs = {
        nestable = {
          { "(", ")" },
          { "[", "]" },
          { "{", "}" },
          { "/", "/" },
          {
            "*",
            "*",
          },
        },
        linear = { { "'", "'" }, { "`", "`" }, { '"', '"' } },
      },
    })
  end,
}

-- nvim-colorizer replacement
editor["rrethy/vim-hexokinase"] = {
  -- ft = { 'html','css','sass','vim','typescript','typescriptreact'},
  config = conf.hexokinase,
  run = "make hexokinase",
  opt = true,
  cmd = { "HexokinaseTurnOn", "HexokinaseToggle" },
}

-- Its hard for this because binds are weird
editor["booperlv/nvim-gomove"] = {
  event = { "CursorMoved", "CursorMovedI" },
  opt = true,
  config = conf.gomove,
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
  },
  opt = true,
  setup = conf.vmulti,
}

editor["sudormrfbin/cheatsheet.nvim"] = {
  cmd = { "Cheatsheet" },
  requires = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
}

-- editor["itchyny/vim-cursorword"] = {
--   event = { "BufReadPre", "BufNewFile" },
--   opt = true,
--   config = conf.vim_cursorwod,
-- }

-- Currently needs to be calle , not sure if i have to lazy load this or not.
editor["andweeb/presence.nvim"] = {
  event = { "BufEnter", "BufRead", "InsertEnter" },
  config = conf.discord,
}

-- REMOVED FTERM

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
  keys = { "g", "<ESC>" },
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
  requires = { "folke/twilight.nvim", opt = true, config = conf.twilight },
  cmd = { "ZenMode" },
  config = conf.zen,
}

editor["nvim-neorg/neorg"] = {
  config = function()
    require("modules.editor.neorg")
  end,
}

editor["psf/black"] = { ft = "python" }

editor["famiu/bufdelete.nvim"] = {
  opt = true,
  cmd = { "Bdelete", "Bwipeout" },
}

editor["nvim-lua/popup.nvim"] = {
  opt = true,
}

editor["raimon49/requirements.txt.vim"] = {
  ft = { "requirements" },
}

editor["max397574/better-escape.nvim"] = {
  event = "InsertEnter",
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

editor["rmagatti/alternate-toggler"] = {
  opt = true,
  cmd = "ToggleAlternate",
}

editor["jbyuki/nabla.nvim"] = {
  opt = true,
  ft = "norg",
  requires = { "nvim-lua/popup.nvim" },
}

return editor
