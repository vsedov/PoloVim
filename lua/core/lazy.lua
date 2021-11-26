function lazyload()
	local loader = require("packer").loader
	vim.cmd([[syntax on]])
	if vim.wo.diff then
		local plugins = "nvim-treesitter" -- nvim-treesitter-textobjects will be autoloaded with loader
		-- loader(plugins)
		vim.cmd([[packadd nvim-treesitter]])
		require("nvim-treesitter.configs").setup({ highlight = { enable = true, use_languagetree = true } })

		return
	end

	print("I am lazy")

	local disable_ft = {
		"NvimTree",
		"guihua",
		"guihua_rust",
		"clap_input",
		"clap_spinner",
		"TelescopePrompt",
		"csv",
		"txt",
		"defx",
		"sidekick",
	}
	local syn_on = not vim.tbl_contains(disable_ft, vim.bo.filetype)
	if syn_on then
		vim.cmd([[syntax manual]])
	else
		vim.cmd([[syntax on]])
	end

	-- local fname = vim.fn.expand("%:p:f")
	local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f"))
	if fsize == nil or fsize < 0 then
		fsize = 1
	end

	local load_lsp = true
	local load_ts_plugins = true

	if fsize > 1024 * 1024 then
		load_ts_plugins = false
		load_lsp = false
	end
	if fsize > 6 * 1024 * 1024 then
		vim.cmd([[syntax off]])
		return
	end

	local plugins = "plenary.nvim" -- nvim-lspconfig navigator.lua   guihua.lua navigator.lua  -- gitsigns.nvim
	loader(plugins)
	vim.g.vimsyn_embed = "lPr"

	if load_lsp then
		loader("nvim-lspconfig") -- null-ls.nvim
		loader("lsp_signature.nvim")
		-- loader("vim-wordmotion")
	end

	require("vscripts.cursorhold")
	require("vscripts.tools")
	if load_ts_plugins then
		-- print('load ts plugins')
		loader("nvim-treesitter")
	end

	if load_lsp or load_ts_plugins then
		loader("guihua.lua")
	end

	local bytes = vim.fn.wordcount()["bytes"]
	-- print(bytes)

	if load_ts_plugins then
		plugins = "nvim-treesitter-refactor nvim-ts-autotag " --  nvim-ts-rainbow  nvim-treesitter nvim-treesitter-refactor
		-- nvim-treesitter-textobjects should be autoloaded
		loader(plugins)
		loader("indent-blankline.nvim")
	end

	-- if bytes < 2 * 1024 * 1024 and syn_on then
	--   vim.cmd([[setlocal syntax=on]])
	-- end

	vim.cmd([[autocmd FileType vista,guihua,guihua setlocal syntax=on]])
	vim.cmd(
		[[autocmd FileType * silent! lua if vim.fn.wordcount()['bytes'] > 2048000 then print("syntax off") vim.cmd("setlocal syntax=off") else print("syntax on") vim.cmd("setlocal syntax=on") end]]
	)
end

vim.cmd([[autocmd User LoadLazyPlugin lua lazyload()]])
vim.cmd("command! Gram lua require'modules.tools.config'.grammcheck()")
vim.cmd("command! Spell call spelunker#check()")

local lazy_timer = 60
vim.defer_fn(function()
	vim.cmd([[doautocmd User LoadLazyPlugin]])
end, lazy_timer)
