local ui = {}
local conf = require("modules.ui.config")
local winwidth = function()
	return vim.api.nvim_call_function("winwidth", { 0 })
end

ui["kyazdani42/nvim-web-devicons"] = {}
ui["lambdalisue/glyph-palette.vim"] = {}

ui["folke/tokyonight.nvim"] = {
	-- config = conf.ui,
}

-- Pocco81/Catppuccino.nvim

ui["Pocco81/Catppuccino.nvim"] = {
	opt = true,
	config = function()
		require("catppuccino").setup({
			colorscheme = "neon_latte",
			transparency = true,
			term_colors = true,
			styles = {
				comments = "italic",
				functions = "italic",
				keywords = "italic",
				strings = "NONE",
				variables = "NONE",
			},
			integrations = {
				treesitter = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = "italic",
						hints = "italic",
						warnings = "italic",
						information = "italic",
					},
					underlines = {
						errors = "underline",
						hints = "underline",
						warnings = "underline",
						information = "underline",
					},
				},
				lsp_trouble = true,
				lsp_saga = true,
				gitgutter = true,
				gitsigns = true,
				telescope = true,
				nvimtree = {
					enabled = true,
					show_root = true,
				},
				which_key = true,
				indent_blankline = {
					enabled = true,
					colored_indent_levels = true,
				},
				dashboard = true,
				neogit = true,
				vim_sneak = true,
				fern = true,
				barbar = true,
				bufferline = true,
				markdown = true,
				lightspeed = true,
				ts_rainbow = true,
				hop = true,
			},
		})
	end,
}

ui["https://github.com/numToStr/Sakura.nvim"] = {
	config = function()
		vim.cmd([[colorscheme sakura]])
	end,
}

ui["glepnir/dashboard-nvim"] = {
	config = conf.dashboard,
}

ui["NTBBloodbath/galaxyline.nvim"] = {
	branch = "main",
	config = conf.galaxyline,
	requires = "kyazdani42/nvim-web-devicons",
}

-- ui["windwp/windline.nvim"] = {
--   event = "UIEnter",
--   config = conf.windline,
--   -- requires = {'kyazdani42/nvim-web-devicons'},
--   opt = true
-- }

ui["lambdalisue/glyph-palette.vim"] = {}

ui["lukas-reineke/indent-blankline.nvim"] = {
	config = conf.indent_blakline,
}

ui["dstein64/nvim-scrollview"] = { config = conf.scrollview }

ui["NFrid/due.nvim"] = {
	config = function()
		require("due_nvim").setup({})
	end,
}

ui["akinsho/bufferline.nvim"] = {
	config = conf.nvim_bufferline,
	event = "UIEnter",
	requires = { "kyazdani42/nvim-web-devicons" },
	opt = true,
}

ui["kazhala/close-buffers.nvim"] = {
	config = conf.buffers_close,
}

-- legit stoped working
ui["kyazdani42/nvim-tree.lua"] = {
	cmd = { "NvimTreeToggle", "NvimTreeOpen" },
	requires = "kyazdani42/nvim-web-devicons",

	-- config = conf.nvim_tree,
	config = function()
		-- vim.g.nvim_tree_git_hl = 1
		-- vim.g.nvim_tree_highlight_opened_files = 1
		-- vim.g.nvim_tree_hide_dotfiles = 1
		-- vim.g.nvim_tree_indent_markers = 1

		require("nvim-tree").setup({
			-- disables netrw completely
			disable_netrw = true,
			-- hijack netrw window on startup
			hijack_netrw = false,
			-- open the tree when running this setup function
			open_on_setup = false,
			-- will not open on setup if the filetype is in this list
			ignore_ft_on_setup = {},
			-- closes neovim automatically when the tree is the last **WINDOW** in the view
			auto_close = true,
			-- opens the tree when changing/opening a new tab if the tree wasn't previously opened
			open_on_tab = false,
			-- hijack the cursor in the tree to put it at the start of the filename
			hijack_cursor = false,
			-- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
			update_cwd = true,
			-- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
			update_focused_file = {
				-- enables the feature
				enable = true,
				-- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
				-- only relevant when `update_focused_file.enable` is true
				update_cwd = true,
				-- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
				-- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
				ignore_list = {},
			},
		})
		local tree_cb = require("nvim-tree.config").nvim_tree_callback
		vim.g.nvim_tree_icons = {
			default = "",
			symlink = "",
			git = {
				unstaged = "✚",
				staged = "✚",
				unmerged = "≠",
				renamed = "≫",
				untracked = "★",
			},
		}
		vim.g.nvim_tree_bindings = {
			{ key = "<C-s>", cb = tree_cb("vsplit") },
			{ key = "<C-i>", cb = tree_cb("split") },
		}
	end,
}

ui["lewis6991/gitsigns.nvim"] = {
	event = { "BufRead", "BufNewFile" },
	config = conf.gitsigns,
	requires = { "nvim-lua/plenary.nvim", opt = true },
}

ui["beauwilliams/focus.nvim"] = {

	config = function()
		require("focus").setup({
			hybridnumber = true,
			excluded_filetypes = { "minimap", "vista", "outline", "symbols_outline" },
		})

		vim.api.nvim_set_keymap("n", "<leader>hh", ":FocusMaximise<CR>", { silent = true })
		vim.api.nvim_set_keymap("n", "<leader>kk", ":FocusSplitNicely<CR>", { silent = true })
	end,
}

ui["kdav5758/TrueZen.nvim"] = {
	config = conf.truezen,
}
ui["folke/zen-mode.nvim"] = {

	config = function()
		require("zen-mode").setup({
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		})
	end,
}

ui["wfxr/minimap.vim"] = {
	run = ":!cargo install --locked code-minimap --force",
	setup = conf.minimap,
}

ui["https://github.com/yamatsum/nvim-cursorline"] = {}

ui["folke/twilight.nvim"] = {}

return ui
