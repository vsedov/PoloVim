set termguicolors

call plug#begin('~/.vim/plugged')

if has('nvim')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'ray-x/lsp_signature.nvim'
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'https://github.com/numToStr/Sakura.nvim'
endif



call plug#end()

set mouse=a

colorscheme sakura

if ! has('nvim')
  finish
endif



lua <<EOF

vim.g.UltiSnipsRemoveSelectModeMappings = 0

 require'lsp_signature'.setup({
    floating_window = true,
 })


require'nvim-treesitter.configs'.setup {
  highlight = {
  enable = true,              
  additional_vim_regex_highlighting = false,
  },
}
local nvim_lsp = require('lspconfig')

local cmp = require("cmp")
local has_any_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local press = function(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end

cmp.setup {

    snippet = {
      expand = function(args)
         vim.fn["UltiSnips#Anon"](args.body)
      end
    },
    completion = {
      autocomplete = {require("cmp.types").cmp.TriggerEvent.TextChanged},
      completeopt = "menu,menuone,noselect"
    },

	mapping = {

		
			["<C-e>"] = cmp.mapping.close(),
			["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			

			["<C-Space>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
						return press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
					end

					cmp.select_next_item()
				elseif has_any_words_before() then
					press("<Space>")
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),

			["<Tab>"] = cmp.mapping(function(fallback)
				if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
					press("<ESC>:call UltiSnips#JumpForwards()<CR>")
				elseif cmp.visible() then
					cmp.select_next_item()
				elseif has_any_words_before() then
					press("<Tab>")
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
					press("<ESC>:call UltiSnips#JumpBackwards()<CR>")
				elseif cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		},

	   



    sources = {{name = 'nvim_lsp'}, {name = 'buffer'}, {name='ultisnips'}}
}


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

capabilities.textDocument.codeAction = {
	-- dynamicRegistration = false;
	codeActionLiteralSupport = {
		codeActionKind = {
			valueSet = {
				"quickfix",
				"refactor",
				"refactor.extract",
				"refactor.inline",
				"refactor.rewrite",
				"source",
				"source.organizeImports",
			},
		},
	},
}



require'lspconfig'.jedi_language_server.setup({
	cmd = { "jedi-language-server" },
	filetypes = { "python" },
	on_attach = enhance_attach,
	capabilities = capabilities,
})


EOF