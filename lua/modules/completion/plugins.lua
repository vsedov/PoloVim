local completion = {}
local conf = require("modules.completion.config")

completion["neovim/nvim-lspconfig"] = {
	event = "BufReadPre",
	config = conf.nvim_lsp,

	requires = {
		{ "nvim-lua/lsp_extensions.nvim" },
		{ "tjdevries/nlua.nvim" },
		{ "https://github.com/onsails/lspkind-nvim" },
		{ "folke/lsp-colors.nvim" },
		{ "https://github.com/mfussenegger/nvim-jdtls" },
		{ "ray-x/lsp_signature.nvim" },
		{ "williamboman/nvim-lsp-installer" },

		-- {'nathunsmitty/nvim-ale-diagnostic',opt=true}
	},
}

completion["ahmedkhalf/project.nvim"] = {
	config = function()
		require("project_nvim").setup({})
	end,
}


completion["hrsh7th/nvim-cmp"] = {
	event = "InsertEnter", -- InsertCharPre
	requires = {
		{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
		{ "hrsh7th/cmp-vsnip", after = "nvim-cmp" },
		{ "hrsh7th/cmp-calc", after = "nvim-cmp" },
		{ "hrsh7th/cmp-path", after = "nvim-cmp" },
		{ "https://github.com/ray-x/cmp-treesitter", after = "nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp", after = { "nvim-cmp" } },
		{ "f3fora/cmp-spell", after = "nvim-cmp" },
		{ "octaltree/cmp-look", after = "nvim-cmp" },
		-- { "dcampos/cmp-snippy", after = { "nvim-snippy", "nvim-cmp" } },
		{ "quangnguyen30192/cmp-nvim-ultisnips", event = "InsertCharPre", after = "nvim-cmp" },
		{ "hrsh7th/cmp-vsnip", rtp = ".", after = "nvim-cmp" },
		{ "saadparwaiz1/cmp_luasnip", after = { "nvim-cmp", "LuaSnip" } },
		{
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			after = "cmp-spell",
			config = conf.tabnine,
		},
	},
	config = conf.cmp,
}

-- can not lazyload, it is also slow...
completion["L3MON4D3/LuaSnip"] = { -- need to be the first to load
	event = "InsertEnter",
	requires = {
		{ "rafamadriz/friendly-snippets" },
		-- { "honza/vim-snippets", event = "InsertEnter" }
	}, -- , event = "InsertEnter"
	config = conf.luasnip,
	after = "nvim-cmp",
}

completion["SirVer/ultisnips"] = {
	requires = "honza/vim-snippets",
	config = function()
		-- vim.g.UltiSnipsRemoveSelectModeMappings = 0
		vim.g.UltiSnipsExpandTrigger = "<C-s>"
		vim.g.UltiSnipsJumpForwardTrigger = "<C-n>"
		vim.g.UltiSnipsJumpBackwardTrigger = "<C-p>"
	end,
}

completion["https://github.com/folke/trouble.nvim"] = {
	config = conf.trouble,
}
completion["folke/todo-comments.nvim"] = {
	config = conf.todo_comments,
	after = "trouble.nvim",
}

completion["luukvbaal/stabilize.nvim"] = {
	config = function()
		require("stabilize").setup()
	end,
}

completion["kristijanhusak/vim-dadbod-completion"] = {
	event = "InsertEnter",
	ft = { "sql" },
	setup = function()
		vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
		vim.cmd(
			[[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]]
		)
		-- body
	end,
}
completion["dense-analysis/ale"] = {

	config = conf.ale,
}

completion["windwp/nvim-autopairs"] = {
	after = "nvim-cmp",
	config = conf.autopairs,
}
completion["weilbith/nvim-code-action-menu"] = {
	cmd = "CodeActionMenu",
}

completion["nvim-telescope/telescope.nvim"] = {

	cmd = "Telescope",
	requires = {
		{ "nvim-lua/popup.nvim" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzy-native.nvim" },
		{ "nvim-telescope/telescope-cheat.nvim" },
		{ "tami5/sql.nvim" },
		{ "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } },
		{ "nvim-telescope/telescope-dap.nvim" },
		{ "https://github.com/fhill2/telescope-ultisnips.nvim" },
	},
	config = conf.telescope,
}

completion["pwntester/octo.nvim"] = {
	after = "telescope.nvim",
	config = function()
		require("octo").setup()
	end,
}

completion["Groctel/jobsplit.nvim"] = {
	config = function() end,
}

completion["Pocco81/AbbrevMan.nvim"] = {
	opt = true,
	config = conf.AbbrevMan,
}

completion["kkoomen/vim-doge"] = {
	config = conf.doge,
	run = ":call doge#install()",
}

completion["CRAG666/code_runner.nvim"] = {
	config = function()
		require("code_runner").setup({
			filetype = {
				map = "<leader>r",
			},
		})
	end,
}

-- command Neorunner - depends if i will keep this trying out new stuff .
completion["BenGH28/neo-runner.nvim"] = {
	config = conf.neorunner,
	run = ":UpdateRemotePlugins",
}

-- This one seems to have more support and looks better .
-- -- Currenty Broken , give a few days to see if it will be back up or not .

completion["kevinhwang91/nvim-bqf"] = {
	config = conf.bqf,
}

completion["mfussenegger/nvim-dap"] = {
	requires = {
		{ "rcarriga/vim-ultest" },
		{ "janko/vim-test" },
		{ "theHamsta/nvim-dap-virtual-text" },
		{ "mfussenegger/nvim-dap-python" },
		{ "rcarriga/nvim-dap-ui" },
		{ "Pocco81/DAPInstall.nvim" },
	},
	run = ":UpdateRemotePlugins",

	config = function()
		require("dapstuff.dapstuff")

		-- virtual text deactivated (default)
		vim.g.dap_virtual_text = false
		-- show virtual text for current frame (recommended)
		vim.g.dap_virtual_text = true
		-- request variable values for all frames (experimental)
		vim.g.dap_virtual_text = "all frames"

		vim.g.ultest_virtual_text = 1
		vim.g.ultest_output_cols = 120
		vim.g.ultest_max_threads = 5
	end,
}

completion["lervag/vimtex"] = {
	config = conf.vimtex,
}

completion['rcarriga/nvim-notify']={
	config = conf.nvim_notify

}

completion["michaelb/sniprun"] = {
	run = "bash install.sh",
	config = conf.sniprun,
}
completion["dccsillag/magma-nvim"] = {
	-- ft = "python", 
	config = conf.magma,
}



completion["psf/black"] = {}

completion["https://github.com/vsedov/vim-sonictemplate"] = {
	cmd = "Template",
	config = conf.vim_sonictemplate,
}

completion["mattn/emmet-vim"] = {
	event = "InsertEnter",
	ft = { "html", "css", "javascript", "javascriptreact", "vue", "typescript", "typescriptreact" },
	config = conf.emmet,
}

return completion
