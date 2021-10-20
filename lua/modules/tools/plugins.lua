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
		}
	end,
}

tools["TimUntersberger/neogit"] = {
	cmd = { "Neogit" },
	config = conf.neogit,
}

tools["f-person/git-blame.nvim"] = {}

tools["editorconfig/editorconfig-vim"] = {
	opt = true,
	cmd = { "EditorConfigReload" },
	-- ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools["numToStr/Comment.nvim"] = {
	config = function()
		require("Comment").setup({
		    ---Add a space b/w comment and the line
		    ---@type boolean
		    padding = true,

		    ---Whether the cursor should stay at its position
		    ---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
		    ---@type boolean
		    sticky = true,

		    ---Lines to be ignored while comment/uncomment.
		    ---Could be a regex string or a function that returns a regex string.
		    ---Example: Use '^$' to ignore empty lines
		    ---@type string|function
		    ignore = nil,

		    ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
		    ---@type table
		    mappings = {
		        ---operator-pending mapping
		        ---Includes `gcc`, `gcb`, `gc[count]{motion}` and `gb[count]{motion}`
		        basic = true,
		        ---extra mapping
		        ---Includes `gco`, `gcO`, `gcA`
		        extra = true,
		        ---extended mapping
		        ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
		        extended = true,
		    },

		    ---LHS of toggle mapping in NORMAL + VISUAL mode
		    ---@type table
		    toggler = {
		        ---line-comment keymap
		        line = 'gcc',
		        ---block-comment keymap
		        block = 'gbc',
		    },

		    ---LHS of operator-pending mapping in NORMAL + VISUAL mode
		    ---@type table
		    opleader = {
		        ---line-comment keymap
		        line = 'gc',
		        ---block-comment keymap
		        block = 'gb',
		    },

		    ---Pre-hook, called before commenting the line
		    ---@type function|nil
		    pre_hook = nil,

		    ---Post-hook, called after commenting is done
		    ---@type function|nil
		    post_hook = nil,

		})

		local ft = require('Comment.ft')

		-- 1. Using set function

		-- set both line and block commentstring
		ft.set('python', {'#%s', '"""%s""'})


	end,
}

tools["liuchengxu/vim-clap"] = {
	cmd = { "Clap" },
	run = function()
		vim.fn["clap#installer#download_binary"]()
	end,
	setup = conf.clap,
	config = conf.clap_after,
}
tools["sindrets/diffview.nvim"] = {
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles", "DiffviewRefresh" },
	config = conf.diffview,
}

tools["fladson/vim-kitty"] = {}

tools["rktjmp/highlight-current-n.nvim"] = {

	config = conf.highlight,
}

tools["relastle/vim-nayvy"] = {

	config = function()
		vim.g.nayvy_import_config_path = "$HOME/nayvy.py"
	end,
}

tools["wakatime/vim-wakatime"] = {}

--Moving stuff
tools["camspiers/animate.vim"] = {}

tools["psliwka/vim-smoothie"] = {
	config = function()
		vim.g.smoothie_experimental_mappings = 1
	end,
}

tools["kamykn/spelunker.vim"] = {
	opt = true,
	fn = { "spelunker#check" },
	setup = conf.spelunker,
	config = conf.spellcheck,
}

tools["rhysd/vim-grammarous"] = {
	opt = true,
	cmd = { "GrammarousCheck" },
	ft = { "markdown", "txt" },
}

tools["euclidianAce/BetterLua.vim"] = {}

tools["nacro90/numb.nvim"] = {
	config = function()
		require("numb").setup({
			show_numbers = true, -- Enable 'number' for the window while peeking
			show_cursorline = true, -- Enable 'cursorline' for the window while peeking

			number_only = true, -- Peek only when the command is only a number instead of when it starts with a number
		})
	end,
}

-- quick code snipit , very nice
tools["https://github.com/rktjmp/paperplanes.nvim"] = {
	config = function()
		require("paperplanes").setup({
			register = "+",
			provider = "dpaste.org",
		})
	end,
}

tools["Pocco81/HighStr.nvim"] = {}

tools["jbyuki/nabla.nvim"] = {}

tools["liuchengxu/vista.vim"] = {
	opt = true,
	cmd = "Vista",
	config = conf.vim_vista,
}

tools["simrat39/symbols-outline.nvim"] = {

	config = conf.outline,
}

tools["kdheepak/lazygit.nvim"] = {
	cmd = { "LazyGit" },
	requires = "nvim-lua/plenary.nvim",
	config = function()
		vim.g.lazygit_floating_window_winblend = 2
		vim.g.lazygit_floating_window_use_plenary = 1
	end,
}

tools["brooth/far.vim"] = {
	cmd = { "Farr", "Farf" },
	run = function()
		require("packer").loader("far.vim")
		vim.cmd([[UpdateRemotePlugins]])
	end,
	config = conf.far,
	opt = true,
} -- brooth/far.vim

tools["iamcco/markdown-preview.nvim"] = {
	run = ":call mkdp#util#install()",

	ft = "markdown",
	config = function()
		vim.g.mkdp_auto_start = 1
	end,
}

tools["chentau/marks.nvim"] = {
	config = conf.marks,
}



tools["AckslD/nvim-neoclip.lua"]={
  requires = {'tami5/sqlite.lua', module = 'sqlite'},
  config = function()
    require('neoclip').setup({
      history = 1000,
      enable_persistant_history = true,
      db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      filter = nil,
      preview = true,
      default_register = '+',
      content_spec_column = true,
      on_paste = {
        set_reg = true,
      },
      keys = {
        i = {
          select = '<cr>',
          paste = '<c-p>',
          paste_behind = '<c-k>',
          custom = {},
        },
        n = {
          select = '<cr>',
          paste = 'p',
          paste_behind = 'P',
        },
      },
    })
  end,
}




return tools
