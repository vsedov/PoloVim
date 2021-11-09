function lazyload()
	local loader = require("packer").loader

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

	local gitrepo = vim.fn.isdirectory(".git/index")

	if load_lsp then
		loader("nvim-lspconfig") -- null-ls.nvim
		loader("lsp_signature.nvim")
	end

	require("vscripts.cursorhold")
	require("vscripts.tools")

	if load_lsp or load_ts_plugins then
		loader("guihua.lua")
		loader("focus.nvim")
	end

	local bytes = vim.fn.wordcount()["bytes"]
	-- print(bytes)

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

vim.defer_fn(function()
	-- lazyload()
	local cmd = "TSEnableAll highlight " .. vim.o.ft
	vim.cmd(cmd)
	vim.cmd([[doautocmd ColorScheme]])
	vim.cmd(cmd)
end, lazy_timer + 20)
