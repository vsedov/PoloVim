local lang = {}
local conf = require("modules.lang.config")
lang["tpope/vim-liquid"] = {
	ft = { "liquid" },
}

lang["pseewald/vim-anyfold"] = {
	cmd = "AnyFoldActivate",
}

lang["nvim-treesitter/nvim-treesitter"] = {
	event = "BufRead",
	after = "telescope.nvim",
	config = conf.nvim_treesitter,
}

lang["nvim-treesitter/nvim-treesitter-textobjects"] = {
	config = conf.textobjects,

	after = "nvim-treesitter",
}

lang["https://github.com/haringsrob/nvim_context_vt"] = {
	after = "nvim-treesitter",
}

lang["nvim-treesitter/nvim-treesitter-refactor"] = {
	after = "nvim-treesitter-textobjects", -- manual loading
	config = conf.nvim_treesitter_ref, -- let the last loaded config treesitter
	opt = true,
}

lang["https://github.com/RRethy/nvim-treesitter-textsubjects"] = {
	config = conf.textsubjects,
	after = "nvim-treesitter",
}

lang["lifepillar/pgsql.vim"] = { ft = { "sql", "pgsql" } }

lang["nanotee/sqls.nvim"] = { ft = { "sql", "pgsql" }, setup = conf.sqls, opt = true }

lang["ElPiloto/sidekick.nvim"] = { cmd = { "SideKickNoReload" }, config = conf.sidekick }

lang["jbyuki/one-small-step-for-vimkind"] = { opt = true, ft = { "lua" } }

lang["mtdl9/vim-log-highlighting"] = { ft = { "text", "log" } }

lang["windwp/nvim-ts-autotag"] = {
	opt = true,
	-- after = "nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({ autotag = { enable = true } })
	end,
}

lang["p00f/nvim-ts-rainbow"] = {
	-- after = "nvim-treesitter",
	-- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
	cmd = "Rainbow",
	config = conf.rainbow,
}

lang["nvim-lua/plenary.nvim"] = {}

lang["nathom/filetype.nvim"] = {
	-- event = {'BufEnter'},
	setup = function()
		vim.g.did_load_filetypes = 1
	end,
}

-- Bloody Usefull
lang["vhyrro/neorg"] = {
	config = conf.neorg,
	requires = { { "nvim-lua/plenary.nvim" } },
	after = { "nvim-treesitter" },
}

lang["rcarriga/vim-ultest"] = {
	requires = { "janko/vim-test" },
	run = ":UpdateRemotePlugins",
	config = conf.ultest,
}
lang["mfussenegger/nvim-dap"] = {
	requires = {
		{ "theHamsta/nvim-dap-virtual-text" },
		{ "mfussenegger/nvim-dap-python" },
		{ "rcarriga/nvim-dap-ui" },
		{ "Pocco81/DAPInstall.nvim" },
	},
	run = ":UpdateRemotePlugins",

	config = function()
		require("modules.lang.Dap.config")
	end,
}
lang["yardnsm/vim-import-cost"] = { cmd = "ImportCost", opt = true }

lang["danymat/neogen"] = {
	opt = true,
	config = function()
		require("neogen").setup({ enabled = true })
		local opts = { noremap = true, silent = true }
		vim.api.nvim_set_keymap("n", "<Leader>n", ":lua require('neogen').generate()<CR>", opts)
	end,
}

return lang
