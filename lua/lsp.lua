
local lspconfig = require('lspconfig')
local lsp_status = require("lsp-status")
local utils = require("boo.utils")
local api = vim.api



-- Fucking needed this >.< 
vim.lsp.handlers['textDocument/publishDiagnostics']= function() end




-- vim.lsp.handlers['textDocument/publishDiagnostics'] = 
-- -- vim.lsp.with(
-- --   vim.lsp.diagnostic.on_publish_diagnostics, {
-- --     -- Enable underline, use default values
-- --     underline = false,
-- --     -- Enable virtual text, override spacing to 4
-- --     virtual_text = false,
-- --     signs = {
-- --       enable = false,
-- --       priority = 0
-- --     },
-- --     -- Disable a feature
-- --     update_in_insert = false,
-- -- })


-- lsp_status.register_progress()
local custom_on_attach_num = function(client, bufnr)
  
  -- This is the new thing added
  local opts = {
		noremap=true,
		silent=true,
	}
end

--  efm doesn't like being told to fold, so only fold on buffers that
--  don't have EFM but use an LSP server that supports folding.
local custom_on_attach_folding = function(client, bufnr)
	custom_on_attach(client, bufnr)
	
	require('folding').on_attach()
end

-- lspconfig.bashls.setup{
-- 	on_attach = custom_on_attach,
-- 	filetypes = { "sh", "zsh" }
-- }
lspconfig.ccls.setup{
	on_attach = custom_on_attach_num,
}
lspconfig.dockerls.setup{
	on_attach = custom_on_attach_num,
}
lspconfig.ghcide.setup{
	on_attach = custom_on_attach_num,
}
lspconfig.jsonls.setup{
	on_attach = custom_on_attach_num,
}
lspconfig.vimls.setup{
	on_attach = custom_on_attach_num
}
lspconfig.efm.setup{
	on_attach = custom_on_attach_num,
	-- only run on configured filetypes
	filetypes = {'pandoc', 'markdown', 'gfm', 'markdown.pandoc.gfm', 'rst','sh','vim','make','yaml','dockerfile'},
}
-- require'lspconfig'.texlab.setup{
--   cmd = { "texlab" },
--   filetypes = { "tex", "bib" }
-- }


-- lspconfig.jedi_language_server.setup{
-- 	cmd = { "jedi-language-server" },
-- 	filetypes = { "python" },

-- }
--
lspconfig.jdtls.setup{
	on_attach=on_attach_vim,

  cmd = {"jdtls"},
  filetypes = {"java"}
}


-- lspconfig.pyls.setup{
-- 	cmd = { "pyls" },
-- 	on_attach=on_attach_vim,
--     settings = { 
--     	pyls = { 
--     		plugins = {
-- 		    	pycodestyle =  {
-- 		    	 enabled = false 
-- 		    	},
-- 		     	pylint =  {
-- 		     	 enabled = false 
-- 		     	},
-- 		     	black = {
-- 		     		enabled = false
-- 		     	},
-- 		     	pyflakes = {enabled = false},
-- 		     	jedi_completion = {fuzzy = false}
--     		 } ,
--  		} ,
--   },

-- }





-- require'lspconfig'.jedi_language_server.setup{
--     cmd = { "jedi-language-server" },
--     filetypes = { "python" },	
--     initializationOptions = {
--     	completion={
-- 	      disableSnippets= false,
-- 	      resolveEagerly=true
--   	  },
 
--     },
-- }





require'lspconfig'.pyright.setup{
  on_attach=on_attach_vim,
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
      settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
      },
}

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


