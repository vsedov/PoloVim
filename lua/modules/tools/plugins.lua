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

tools["f-person/git-blame.nvim"] = {
	config = function()
		vim.g.gitblame_enabled = 0
	end,
}

tools["editorconfig/editorconfig-vim"] = {
	opt = true,
	cmd = { "EditorConfigReload" },
	-- ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools["numToStr/Comment.nvim"] = {
	config = conf.comment,
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
	config = conf.numb,
}

-- quick code snipit , very nice
tools["https://github.com/rktjmp/paperplanes.nvim"] = {
	config = conf.paperplanes,
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

tools["rmagatti/auto-session"] = {
	-- cmd = {'SaveSession', 'RestoreSession', 'DeleteSession'},
	config = conf.session,
}

tools["rmagatti/session-lens"] = {
	cmd = "SearchSession",
	config = function()
		require("session-lens").setup({ shorten = true, previewer = true })
	end,
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
-- --
tools["chentau/marks.nvim"] = {
	-- event = "BufEnter",
	branch = "master",
	config = function()
		require("marks").setup({
			default_mappings = true,
			builtin_marks = { ".", "<", ">", "^" },
			-- whether movements cycle back to the beginning/end of buffer. default true
			cyclic = true,
			-- whether the shada file is updated after modifying uppercase marks. default false
			force_write_shada = false,
			-- how often (in ms) to redraw signs/recompute mark positions.
			-- higher values will have better performance but may cause visual lag,
			-- while lower values may cause performance penalties. default 150.
			refresh_interval = 250,
			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
			bookmark_0 = {
				sign = "⚑",
				virt_text = "BookMarks",
			},
		})
	end,
}

tools["AckslD/nvim-neoclip.lua"] = {
	requires = { "tami5/sqlite.lua", module = "sqlite" },
	config = conf.clipboard,
}

tools["gelguy/wilder.nvim"] = {
	requires = {
		"https://github.com/romgrk/fzy-lua-native",
		"nixprime/cpsm",
		"kyazdani42/nvim-web-devicons",
		"https://github.com/lambdalisue/nerdfont.vim",
	},
	run = ":UpdateRemotePlugins",
}

tools["tjdevries/train.nvim"] = {}

return tools
