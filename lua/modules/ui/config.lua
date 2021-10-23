local config = {}

function config.galaxyline()
	require("modules.ui.eviline")
end

function config.nvim_bufferline()
	require("bufferline").setup({
		options = {
			modified_icon = "✥",
			buffer_close_icon = "",
			diagnostics = "nvim_lsp",

			diagnostics_indicator = function(count, level)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,
			diagnostics_update_in_insert = true,
			show_close_icon = false,
			always_show_bufferline = true,
			show_buffer_close_icons = false,
		},
	})
end

function config.buffers_close()
	require("close_buffers").setup({
		preserve_window_layout = { "this" },
		next_buffer_cmd = function(windows)
			require("bufferline").cycle(1)
			local bufnr = vim.api.nvim_get_current_buf()

			for _, window in ipairs(windows) do
				vim.api.nvim_win_set_buf(window, bufnr)
			end
		end,
	})
end

function config.dashboard()
	local home = os.getenv("HOME")
	vim.g.dashboard_footer_icon = "🐬 "
	vim.g.dashboard_custom_header = {
		"                                   ",
		"                                   ",
		"   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆         ",
		"    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
		"          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
		"           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
		"          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
		"   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
		"  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
		" ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
		" ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
		"    ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆       ",
		"       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
		"                                   ",
	}
	vim.g.dashboard_preview_file_height = 12
	vim.g.dashboard_preview_file_width = 80
	vim.g.dashboard_default_executive = "telescope"
	vim.g.dashboard_custom_section = {
		last_session = {
			description = { "  Recently laset session                  SPC s l" },
			command = "SessionLoad",
		},
		find_history = {
			description = { "  Recently opened files                   SPC f h" },
			command = "DashboardFindHistory",
		},
		find_file = {
			description = { "  Find  File                              SPC f f" },
			command = "Telescope find_files find_command=rg,--hidden,--files",
		},
		new_file = {
			description = { "  File Browser                            SPC f b" },
			command = "Telescope file_browser",
		},
		find_word = {
			description = { "  Find  word                              SPC f w" },
			command = "DashboardFindWord",
		},
		find_dotfiles = {
			description = { "  Open Personal dotfiles                  SPC f d" },
			command = "Telescope dotfiles path=" .. home .. "/.dotfiles",
		},
		go_source = {
			description = { "  Find cheat  - Language container        SPC f s" },
			command = "Telescope cheat fd",
		},
	}
end
function config.nvim_tree_setup()
	vim.g.nvim_tree_hide_dotfiles = 1
	vim.g.nvim_tree_indent_markers = 1
	vim.g.nvim_tree_width = 28
	vim.g.nvim_tree_git_hl = 1
	vim.g.nvim_tree_width_allow_resize = 1
	vim.g.nvim_tree_highlight_opened_files = 1
	vim.g.nvim_tree_icons = {
		default = "",
		symlink = "",
		git = {
			unstaged = "✗",
			staged = "✓",
			unmerged = "",
			renamed = "➜",
			untracked = "★",
			deleted = "",
			ignored = "◌",
		},
		folder = {
			arrow_open = "",
			arrow_closed = "",
			default = "",
			open = "",
			symlink = "",
			empty = "",
			empty_open = "",
			symlink = "",
			symlink_open = "",
		},
	}
	vim.cmd([[autocmd Filetype NvimTree set cursorline]])
end

function config.nvim_tree()
	-- following options are the default
	require("nvim-tree").setup({
		-- disables netrw completely
		disable_netrw = true,
		-- hijack netrw window on startup
		hijack_netrw = true,
		-- open the tree when running this setup function
		open_on_setup = false,
		-- will not open on setup if the filetype is in this list
		ignore_ft_on_setup = {},
		-- closes neovim automatically when the tree is the last **WINDOW** in the view
		auto_close = false,
		-- opens the tree when changing/opening a new tab if the tree wasn't previously opened
		open_on_tab = false,
		-- hijack the cursor in the tree to put it at the start of the filename
		update_to_buf_dir = {
			-- enable the feature
			enable = true,
			-- allow to open the tree if it was previously closed
			auto_open = true,
		},
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
		-- configuration options for the system open command (`s` in the tree by default)
		system_open = {
			-- the command to run this, leaving nil should work in most cases
			cmd = nil,
			-- the command arguments as a list
			args = {},
		},
		diagnostics = {
			enable = true,
			icons = {
				hint = "",
				info = "",
				warning = "",
				error = "",
			},
		},
		view = {
			-- width of the window, can be either a number (columns) or a string in `%`
			width = 30,
			-- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
			side = "left",
			-- if true the tree will resize itself after opening a file
			auto_resize = false,
			mappings = {
				-- custom only false will merge the list with the default mappings
				-- if true, it will only use your list to set the mappings
				custom_only = false,
				-- list of mappings to set on the tree manually
				list = {},
			},
		},
	})
end

function config.gitsigns()
	if not packer_plugins["plenary.nvim"].loaded then
		vim.cmd([[packadd plenary.nvim]])
	end
	require("gitsigns").setup({
		signs = {
			add = { hl = "GitGutterAdd", text = "▋" },
			change = { hl = "GitGutterChange", text = "▋" },
			delete = { hl = "GitGutterDelete", text = "▋" },
			topdelete = { hl = "GitGutterDeleteChange", text = "▔" },
			changedelete = { hl = "GitGutterChange", text = "▎" },
		},
		keymaps = {
			-- Default keymap options
			noremap = true,
			buffer = true,

			["n ]g"] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
			["n [g"] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },

			["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
			["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
			["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
			["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
			["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',

			-- Text objects
			["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
			["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
		},
	})
end

function config.indent_blakline()
	vim.g.indent_blankline_char = "│"
	vim.g.indent_blankline_show_first_indent_level = true
	vim.g.indent_blankline_filetype_exclude = {
		"startify",
		"dashboard",
		"dotooagenda",
		"log",
		"fugitive",
		"gitcommit",
		"packer",
		"vimwiki",
		"markdown",
		"json",
		"txt",
		"vista",
		"help",
		"todoist",
		"NvimTree",
		"peekaboo",
		"git",
		"TelescopePrompt",
		"undotree",
		"flutterToolsOutline",
		"", -- for all buffers without a file type
	}
	vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
	vim.g.indent_blankline_show_trailing_blankline_indent = true
	vim.g.indent_blankline_show_current_context = true
	vim.g.indent_blankline_context_patterns = {
		"class",
		"function",
		"method",
		"block",
		"list_literal",
		"selector",
		"^if",
		"^table",
		"if_statement",
		"while",
		"for",
	}
	-- because lazy load indent-blankline so need readd this autocmd
	vim.cmd("autocmd CursorMoved * IndentBlanklineRefresh")
end

function config.ui()
	-- vim.cmd('colorscheme boo')
	vim.g.tokyonight_style = "night"
	vim.g.tokyonight_transparent = false

	vim.g.tokyonight_enable_italic_comment = true
	vim.g.tokyonight_enable_italic = true
	vim.g.tokyonight_italic_functions = true

	vim.g.tokyonight_terminal_colors = true

	vim.g.tokyonight_dark_float = true
	vim.g.tokyonight_sidebars = { "qf", "NvimTree", "NvimTreeNormal", "packer" }

	vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }
	vim.g.tokyonight_transparent_sidebar = true
	vim.g.tokyonight_dark_sidebar = false

	-- Load the colorscheme
	vim.cmd([[colorscheme tokyonight]])
end

function config.undo()
	vim.g.undotree_WindowLayout = 3
end

function config.truezen()
	local true_zen = require("true-zen")

	true_zen.after_minimalist_mode_hidden = function()
		vim.cmd("echo 'I ran after minimalist mode hid everything :)'")
	end

	true_zen.before_minimalist_mode_hidden = function()
		vim.cmd("echo 'I ran before minimalist mode hid everything :)'")
	end

	true_zen.after_minimalist_mode_shown = function()
		vim.cmd("echo 'I ran after minimalist mode showed everything :)'")
	end

	true_zen.before_minimalist_mode_shown = function()
		vim.cmd("echo 'I ran before minimalist mode showed everything :)'")
	end
end

function config.windline()
	if not packer_plugins["nvim-web-devicons"].loaded then
		packer_plugins["nvim-web-devicons"].loaded = true
		require("packer").loader("nvim-web-devicons")
	end

	require("modules.ui.eviline")
end

function config.scrollview()
	if vim.wo.diff then
		return
	end
	local w = vim.api.nvim_call_function("winwidth", { 0 })
	if w < 70 then
		return
	end

	vim.g.scrollview_column = 1
end

function config.scrollbar()
	if vim.wo.diff then
		return
	end
	local w = vim.api.nvim_call_function("winwidth", { 0 })
	if w < 70 then
		return
	end
	local vimcmd = vim.api.nvim_command
	vimcmd("augroup " .. "ScrollbarInit")
	vimcmd("autocmd!")
	vimcmd("autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()")
	vimcmd("autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()")
	vimcmd("autocmd WinLeave,FocusLost,BufLeave    * silent! lua require('scrollbar').clear()")
	vimcmd("autocmd WinLeave,BufLeave    * silent! DiffviewClose")
	vimcmd("augroup end")
	vimcmd("highlight link Scrollbar Comment")
	vim.g.sb_default_behavior = "never"
	vim.g.sb_bar_style = "solid"
end

function config.minimap()
	vim.g.minimap_auto_start = 1

	local w = vim.api.nvim_call_function("winwidth", { 0 })
	if w > 180 then
		vim.g.minimap_width = 12
	elseif w > 120 then
		vim.g.minimap_width = 10
	elseif w > 80 then
		vim.g.minimap_width = 7
	else
		vim.g.minimap_width = 2
	end
end

return config
