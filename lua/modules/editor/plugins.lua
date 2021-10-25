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

editor["mbbill/undotree"] = { cmd = { "UndotreeToggle" } }

editor["famiu/bufdelete.nvim"] = {
	opt = true,
	cmd = { "Bdelete", "Bwipeout" },
}

editor["itchyny/vim-cursorword"] = {
	config = conf.vim_cursorwod,
}

editor["blackCauldron7/surround.nvim"] = {
	config = function()
		require("surround").setup({ mappings_style = "surround" })
	end,
}

editor["ggandor/lightspeed.nvim"] = {
	requires = { "https://github.com/tpope/vim-repeat" },
	config = function()
		require("lightspeed").setup({
			jump_to_first_match = true,
			jump_on_partial_input_safety_timeout = 400,
			highlight_unique_chars = true,
			grey_out_search_area = true,
			match_only_the_start_of_same_char_seqs = true,
			limit_ft_matches = 5,
			x_mode_prefix_key = "<C-x>",
			substitute_chars = { ["\r"] = "¬" },
			instant_repeat_fwd_key = nil,
			instant_repeat_bwd_key = nil,
			-- If no values are given, these will be set at runtime,
			-- based on `jump_to_first_match`.
			labels = nil,
			cycle_group_fwd_key = nil,
			cycle_group_bwd_key = nil,
		})
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

editor["tpope/vim-repeat"] = {}

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
	
	local patterns = require"nrpattern.default"

	-- The dict uses the pattern as key, and has a dict of options as value.
	-- To add a new pattern, for example the VHDL x"aabb" format.
	patterns['()x"(%x+)"'] = {
	  base = 16, -- Hexadecimal
	  format = '%sx"%s"', -- Output format
	  priority = 15, -- Determines order in pattern matching
	}

	-- Change a default setting:
	patterns["(%d*)'h([%x_]+)"].separator.group = 8


	patterns[{"yes", "no"}] = {priority = 5}

	-- Call the setup to enable the patterns
	require"nrpattern".setup(patterns)

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

editor["chaoren/vim-wordmotion"] = {
	fn = { "<Plug>WordMotion_w", "<Plug>WordMotion_b", "<Plug>WordMotion_gE", " <Plug>WordMotion_aW" },
	keys = { "w", "W", "gE", "aW" },
}




return editor
