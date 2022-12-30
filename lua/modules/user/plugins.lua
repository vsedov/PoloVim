local user = require("core.pack").package

user({
	"p00f/cphelper.nvim",
	cmd = {
		"CphReceive",
		"CphTest",
		"CphReTest",
		"CphEdit",
		"CphDelete",
	},
	lazy = true,
	config = function()
		vim.g["cph#lang"] = "python"
		vim.g["cph#border"] = lambda.style.border.type_0
	end,
})

user({
	"samjwill/nvim-unception",
	lazy = true,
	init = function()
		lambda.lazy_load({
			events = "CmdlineEnter",
			pattern = "toggleterm",
			augroup_name = "unception",
			condition = lambda.config.use_unception,
			plugin = "nvim-unception",
		})
	end,
	config = function()
		vim.g.unception_delete_replaced_buffer = true
		vim.g.unception_enable_flavor_text = false
	end,
})
-- -- --
-- user({
--     "glepnir/hlsearch.nvim",
--     init =  function()
--         lambda.lazy_load({
--             events = "BufRead",
--             augroup_name = "hlsearch",
--             condition = false,
--             plugin = "hlsearch.nvim",
--         })
--     end,
--     config = function()
--         require("hlsearch").setup()
--     end,
-- })

user({
	"nullchilly/fsread.nvim",
	cmd = { "FSRead", "FSClear", "FSToggle" },
	config = function()
		vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
		vim.g.skip_flow_default_hl = true -- If you want to override default highlights
		vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
		vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
	end,
})

user({
	"chrisgrieser/nvim-genghis",
	dependencies = { "stevearc/dressing.nvim" },
	lazy = true,
	cmd = {
		"GenghiscopyFilepath",
		"GenghiscopyFilename",
		"Genghischmodx",
		"GenghisrenameFile",
		"GenghiscreateNewFile",
		"GenghisduplicateFile",
		"Genghistrash",
		"Genghismove",
	},
	config = function()
		local genghis = require("genghis")
		lambda.command("GenghiscopyFilepath", genghis.copyFilepath, {})
		lambda.command("GenghiscopyFilename", genghis.copyFilename, {})
		lambda.command("Genghischmodx", genghis.chmodx, {})
		lambda.command("GenghisrenameFile", genghis.renameFile, {})
		lambda.command("GenghiscreateNewFile", genghis.createNewFile, {})
		lambda.command("GenghisduplicateFile", genghis.duplicateFile, {})
		lambda.command("Genghistrash", function()
			genghis.trashFile({ trashLocation = "/home/viv/.local/share/Trash/" })
		end, {})
		lambda.command("Genghismove", genghis.moveSelectionToNewFile, {})
	end,
})

-- -- about time .
user({
	"LunarVim/bigfile.nvim",
	event = "VeryLazy",
	config = function()
		local default_config = {
			filesize = 2,
			pattern = { "*" },
			features = {
				"indent_blankline",
				"illuminate",
				"syntax",
				"matchparen",
				"vimopts",
				"filetype",
			},
		}
		require("bigfile").config(default_config)
	end,
})

user({
	"elihunter173/dirbuf.nvim",
	cmd = "DirBuf",
	config = function()
		require("dirbuf").setup({
			hash_padding = 2,
			show_hidden = true,
			sort_order = "default",
			write_cmd = "DirbufSync",
		})
	end,
})

user({
	"strash/everybody-wants-that-line.nvim",
	lazy = true,
	event = "BufWinEnter",
	config = function()
		-- or you can add it
		require("everybody-wants-that-line").setup({
			buffer = {
				show = true,
				prefix = "λ:",
				-- Symbol before buffer number, e.g. "0000.".
				-- If you don't want additional symbols to be displayed, set `buffer.max_symbols = 0`.
				symbol = "0",
				-- Maximum number of symbols including buffer number.
				max_symbols = 5,
			},
			filepath = {
				path = "relative",
				shorten = false,
			},
			filesize = {
				metric = "decimal",
			},
			separator = "│",
		})
	end,
})
user({
	"tamton-aquib/mpv.nvim",
	lazy = true,
	cmd = "MpvToggle",
	config = true,
})

user({
	"meatballs/notebook.nvim",
	ft = "ipynb",
	dependencies = { "dccsillag/magma-nvim" },
})

user({
	"Apeiros-46B/qalc.nvim",
	config = true,
	cmd = { "Qalc", "QalcAttach" },
})
