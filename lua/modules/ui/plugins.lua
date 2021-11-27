local ui = {}
local conf = require("modules.ui.config")
local winwidth = function()
	return vim.api.nvim_call_function("winwidth", { 0 })
end

ui["kyazdani42/nvim-web-devicons"] = {}
ui["lambdalisue/glyph-palette.vim"] = {}

ui["folke/tokyonight.nvim"] = {
	config = function() end,
}

ui["catppuccin/nvim"] = {
	config = function()
		require("catppuccin").setup({
			transparent_background = false,
			term_colors = false,
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
				lsp_saga = false,
				gitgutter = true,
				gitsigns = true,
				telescope = true,
				nvimtree = {
					enabled = true,
					show_root = true,
				},
				which_key = false,
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
				markdown = false,
				lightspeed = true,
				ts_rainbow = true,
				hop = true,
			},
		})
		vim.cmd([[colorscheme catppuccin]])
	end,
}

ui["https://github.com/numToStr/Sakura.nvim"] = {
	config = function()
		-- vim.cmd([[colorscheme sakura]])
	end,
}

ui["glepnir/dashboard-nvim"] = {
	config = conf.dashboard,
}

-- ui["NTBBloodbath/galaxyline.nvim"] = {
-- 	branch = "main",
-- 	config = conf.galaxyline,
-- 	requires = "kyazdani42/nvim-web-devicons",
-- }

ui["windwp/windline.nvim"] = {
	event = "UIEnter",
	config = conf.windline,
	-- requires = {'kyazdani42/nvim-web-devicons'},
	opt = true,
}

ui["lukas-reineke/virt-column.nvim"] = {
	opt = true,
	event = { "CursorMoved", "CursorMovedI" },
	config = function()
		vim.cmd("highlight clear ColorColumn")
		require("virt-column").setup()
	end,
}

ui["lambdalisue/glyph-palette.vim"] = {}

ui["lukas-reineke/indent-blankline.nvim"] = {
	config = conf.indent_blakline,
}

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
	requires = { "kyazdani42/nvim-web-devicons" },
	config = conf.nvim_tree,
}

ui["lewis6991/gitsigns.nvim"] = {
	event = { "BufRead", "BufNewFile" },
	config = conf.gitsigns,
	requires = { "nvim-lua/plenary.nvim", opt = true },
}

ui["Pocco81/TrueZen.nvim"] = {
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

ui["folke/twilight.nvim"] = {}

return ui
