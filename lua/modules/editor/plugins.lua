local editor = {}
local conf = require("modules.editor.config")

-- editor['Raimondi/delimitMate'] = {
--   opt = true,
--   event  = 'InsertEnter',
--   config = conf.delimimate,
-- }

editor["junegunn/vim-easy-align"] = { opt = true, cmd = "EasyAlign" }

editor["rhysd/accelerated-jk"] = {
	opt = true,
}

editor["andymass/vim-matchup"] = {
	event = { "CursorMoved", "CursorMovedI" },
	config = function()
		vim.g.matchup_enabled = 1
		vim.g.matchup_surround_enabled = 1
		-- vim.g.matchup_transmute_enabled = 1
		vim.g.matchup_matchparen_deferred = 1
		vim.g.matchup_matchparen_offscreen = { method = "popup" }
		vim.cmd([[nnoremap <c-s-k> :<c-u>MatchupWhereAmI?<cr>]])
	end,
}

-- <A-k>   Move current line/selection up
-- <A-j>   Move current line/selection down
-- <A-h>   Move current character/selection left
-- <A-l>   Move current character/selection right
editor["matze/vim-move"] = {
	-- fn = {'<Plug>MoveBlockDown', '<Plug>MoveBlockUp', '<Plug>MoveLineDown', '<Plug>MoveLineUp'}
}

-- MOST IMPORTANT FEATURE OF THEM ALL, I APROVE OF THIS
editor["rtakasuke/vim-neko"] = {}

editor["bfredl/nvim-miniyank"] = {
	keys = { "p", "y", "<C-v>" },
	opt = true,
	setup = function()
		vim.api.nvim_command("map p <Plug>(miniyank-autoput)")
		vim.api.nvim_command("map P <Plug>(miniyank-autoPut)")
	end,
}

editor["filipdutescu/renamer.nvim"] = {
	branch = "develop",
	requires = "nvim-lua/plenary.nvim",

	config = function()
		local mappings_utils = require("renamer.mappings.utils")
		require("renamer").setup({
			-- The popup title, shown if `border` is true
			title = "Rename",
			-- The padding around the popup content
			padding = { 0, 0, 0, 0 },
			-- Whether or not to shown a border around the popup
			border = true,
			-- The characters which make up the border
			border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			-- Whether or not o highlight the current word references through LSP
			show_refs = true,
		})
	end,
}

editor["mg979/vim-visual-multi"] = {
	keys = {
		"<Ctrl>",
		"<M>",
		"<C-m>",
		"<C-m>",
		"<M-n>",
		"<S-Down>",
		"<S-Up>",
		"<M-Left>",
		"<M-i>",
		"<M-Right>",
		"<M-D>",
		"<M-Down>",
		"<C-dd>",
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

editor["mbbill/undotree"] = {
	cmd = { "UndotreeToggle" },
}

editor["famiu/bufdelete.nvim"] = {
	opt = true,
	cmd = { "Bdelete", "Bwipeout" },
}

-- editor["itchyny/vim-cursorword"] = {
-- 	config = conf.vim_cursorwod,
-- }

editor["https://github.com/yamatsum/nvim-cursorline"] = {
	branch = "nightly",
	config = function() end,
}

-- cs item + what you replacing with
editor["tpope/vim-surround"] = {}

editor["tpope/vim-repeat"] = {}

editor["ggandor/lightspeed.nvim"] = {
	requires = "tpope/vim-repeat",

	config = function()
		require'lightspeed'.setup {
		  exit_after_idle_msecs = { labeled = 1500, unlabeled = 1000 },

		  -- s/x
		  grey_out_search_area = true,
		  highlight_unique_chars = true,
		  match_only_the_start_of_same_char_seqs = true,
		  jump_on_partial_input_safety_timeout = 400,
		  substitute_chars = { ['\r'] = '¬' },
		  -- Leaving the appropriate list empty effectively disables
		  -- -- "smart" mode, and forces auto-jump to be on or off.
		  -- safe_labels = { ... },
		  -- labels = { ... },
		  cycle_group_fwd_key = '<space>',
		  cycle_group_bwd_key = '<tab>',
		  x_mode_prefix_key = '<c-x>',
		  z_mode_prefix_key = '<c-z>',

		  -- f/t
		  limit_ft_matches = 20,
		  instant_repeat_fwd_key = nil,
		  instant_repeat_bwd_key = nil,
		}
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

editor["dhruvasagar/vim-table-mode"] = {
	cmd = { "TableModeToggle" },
}

editor["kana/vim-niceblock"] = {
	opt = true,
}

-- Paste without yank
editor["kana/vim-operator-replace"] = {
	opt = true,
	keys = { { "x", "p" } },
	config = function()
		vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)", { silent = true })
	end,
}

-- This is rather nice i kinda like it .
editor["https://github.com/LoricAndre/OneTerm.nvim.git"] = {
	cmd = { "OneTerm" },
}

editor["andweeb/presence.nvim"] = {
	event = "BufReadPre",
	config = conf.discord,
}

editor["https://github.com/numtostr/FTerm.nvim"] = {
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
---
----
--------

-- editor["arthurxavierx/vim-caser"] = {

-- 	config = function()
-- 		vim.g.caser_no_mappings = 1
-- 	end,
-- }

--Req Syntax Nice Stuff .
editor["raimon49/requirements.txt.vim"] = {}

editor["Vimjas/vim-python-pep8-indent"] = {}

editor["kalekseev/vim-coverage.py"] = {
	run = ":UpdateRemotePlugins",
}

-- editor['jdhao/better-escape.vim']  = {
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

editor["https://github.com/tmhedberg/SimpylFold"] = {
	requires = "https://github.com/Konfekt/FastFold",

	config = function()
		vim.g.SimpylFold_docstring_preview = 1
	end,
}

editor["ray-x/guihua.lua"] = {
	run = "cd lua/fzy && make",
}

editor["ruifm/gitlinker.nvim"] = {
	requires = "nvim-lua/plenary.nvim",
	config = function()
		require("gitlinker").setup()
	end,
}

editor["chaoren/vim-wordmotion"] = {
	fn = { "<Plug>WordMotion_w", "<Plug>WordMotion_b", "<Plug>WordMotion_gE", " <Plug>WordMotion_aW" },
	keys = { "w", "W", "gE", "aW" },
}

--- Cheat

-- editor["RishabhRD/popfix"] = {
	

-- 	config = function()
-- 		local border_chars = {
-- 			TOP_LEFT = "┌",
-- 			TOP_RIGHT = "┐",
-- 			MID_HORIZONTAL = "─",
-- 			MID_VERTICAL = "│",
-- 			BOTTOM_LEFT = "└",
-- 			BOTTOM_RIGHT = "┘",
-- 		}
-- 		--
-- 		local opts = {
-- 			height = 40,
-- 			width = 120,
-- 			mode = "editor",

-- 			prompt = {
-- 				border = true,
-- 				numbering = true,
-- 				title = "MyTitle",
-- 				border_chars = border_chars,
-- 				highlight = "Normal",
-- 				prompt_highlight = "Normal",
-- 			},
-- 		}

-- 		local popup = require("popfix"):new(opts)
-- 	end,
-- }
-- editor["RishabhRD/nvim-cheat.sh"] = {
-- 	requires = "RishabhRD/popfix",
-- }

---------------
---------------------
---------------------
---------------------
--jupyter notebook--

return editor
