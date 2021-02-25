
local lspconfig = require('lspconfig')

local lsp_status = require('lsp-status')
local status = require("boo.lsp_status")

local api = vim.api

-- lsp_status.register_progress()

local custom_on_attach = function(client, bufnr)
  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.

  local opts = {
		noremap=true,
		silent=true,
	}
	
	lsp_status.on_attach(client)
end

--  efm doesn't like being told to fold, so only fold on buffers that
--  don't have EFM but use an LSP server that supports folding.
local custom_on_attach_folding = function(client, bufnr)
	custom_on_attach(client, bufnr)
	lsp_status.on_attach(client)

	require('folding').on_attach()
end

-- lspconfig.bashls.setup{
-- 	on_attach = custom_on_attach,
-- 	filetypes = { "sh", "zsh" }
-- }
lspconfig.ccls.setup{
	on_attach = custom_on_attach_folding,
}
lspconfig.dockerls.setup{
	on_attach = custom_on_attach_folding,
}
lspconfig.ghcide.setup{
	on_attach = custom_on_attach_folding,
}
lspconfig.jsonls.setup{
	on_attach = custom_on_attach_folding,
}
lspconfig.vimls.setup{
	on_attach = custom_on_attach
}
lspconfig.efm.setup{
	on_attach = custom_on_attach,
	-- only run on configured filetypes
	filetypes = {'pandoc', 'markdown', 'gfm', 'markdown.pandoc.gfm', 'rst','sh','vim','make','yaml','dockerfile'},
}
require'lspconfig'.texlab.setup{
  cmd = { "texlab" },
  filetypes = { "tex", "bib" }
}


-- lspconfig.jedi_language_server.setup{
-- 	cmd = { "jedi-language-server" },
-- 	filetypes = { "python" },

-- }
--
lspconfig.jdtls.setup{
	on_attach = custom_on_attach,

  cmd = {"jdtls"},
  filetypes = {"java"}
}

lspconfig.pyls.setup{
	on_attach = custom_on_attach,
    settings = { pyls = { plugins = {
    	pycodestyle =  { enabled = false },
     	pylint =  { enabled = false },
     	black = {enabled = true},
     	pyflakes = {enabled = false}
     } ,
 	} ,
  },
}

-- lspconfig.pyls_ms.setup{
-- 	on_attach=on_attach_vim,
-- 	cmd = { "mspyls" },
-- 	filetypes = { "python" },
--     init_options = {
--       analysisUpdates = true,
--       asyncStartup = true,
--       displayOptions = {},
-- 	  settings = {
-- 	  	python = {
-- 	        analysis = {
-- 	          disabled = {"undefined-variable"},
-- 	          errors = {"unknown-parameter-name"},
-- 	          info = {"too-many-function-arguments", "parameter-missing"}
-- 	        },
-- 	   },
-- 	},
-- },
-- }

local custom_on_attach_nlua = function(client, bufnr)
	custom_on_attach_folding(client, bufnr)
end

-- require('lua.lsp.nvim').setup(lspconfig, {
-- 	on_attach = custom_on_attach_nlua,
-- 	settings = {
-- 		Lua = {
-- 			runtime = {
-- 				version = "LuaJIT"
-- 			}
-- 		}
-- 	}
-- })
