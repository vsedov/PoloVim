local api = vim.api
local lspconfig = require 'lspconfig'
local global = require 'core.global'
vim.o.completeopt = "menuone,noselect"



if not packer_plugins['lspsaga.nvim'].loaded then
  vim.cmd [[packadd lspsaga.nvim]]
end

local saga = require 'lspsaga'
saga.init_lsp_saga({
  code_action_keys = {
    quit = 'q',exec = '<CR>'
  },
  rename_action_keys = {
    quit = '<C-c>',exec = '<CR>'  -- quit can be a table
  },
  code_action_icon = '',
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

do
  
end



function _G.reload_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.cmd [[edit]]
end

function _G.open_lsp_log()
  local path = vim.lsp.get_log_path()
  vim.cmd("edit " .. path)
end

vim.cmd('command! -nargs=0 LspLog call v:lua.open_lsp_log()')
vim.cmd('command! -nargs=0 LspRestart call v:lua.reload_lsp()')

-- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     -- Enable underline, use default values
--     underline = false,
--     -- Enable virtual text, override spacing to 4
--     virtual_text = false,
--     signs = {
--       enable = true,
--       priority = 20
--     },
--     -- Disable a feature
--     update_in_insert = false,
-- })


-- I dont like the lsp diagnositcs, it can be very annoying and gets in teh way 
vim.lsp.handlers['textDocument/publishDiagnostics']= function() end

-- vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
-- vim.cmd[[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]

local enhance_attach = function(client,bufnr)

  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")


end
lspconfig.vimls.setup{
  cmd = { "vim-language-server", "--stdio" },
  filetypes = { "vim" },
 on_attach = enhance_attach,
 capabilities = capabilities,


}


lspconfig.gopls.setup {
    filetypes = {"go"},

  cmd = {"gopls","--remote=auto"},
  on_attach = enhance_attach,
  capabilities = capabilities,
  init_options = {
    usePlaceholders=true,
    completeUnimported=true,
  }
}

lspconfig.tsserver.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    enhance_attach(client)
  end
}

lspconfig.clangd.setup {
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
  },
    on_attach = enhance_attach,
    capabilities = capabilities,

}

-- lspconfig.ccls.setup {
--   cmd = {"ccls" },
--   on_attach = enhance_attach,
--   capabilities = capabilities,
--   filetypes = { "c", "cpp", "objc", "objcpp" },

-- }



local servers = {
  'dockerls','bashls'
}

for _,server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = enhance_attach,
    capabilities = capabilities,
  }
end

-- lspconfig.pyright.setup{
--     on_attach = enhance_attach,
--     capabilities = capabilities,
--     settings = {
--       python = {
--         analysis = {
--           autoSearchPaths = true;
--           useLibraryCodeForTypes = true;
--           autoImportCompletions = true;
--         };
--     };
--   };
-- };


lspconfig.jdtls.setup{
  filetypes = {"java"},
  cmd = {'jdtls'},
  on_attach = enhance_attach,
  capabilities = capabilities,

}


lspconfig.jedi_language_server.setup{
 cmd = { "jedi-language-server" },
 filetypes = { "python" },
 on_attach = enhance_attach,
 capabilities = capabilities,
}



-- You will have to Build a package for this . 
lspconfig.rust_analyzer.setup {
    filetypes = {"rust"},
    cmd = { "rust-analyzer" },
    capabilities = capabilities,
    on_attach = enhance_attach,


}


local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

lspconfig.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}


-- lspconfig.pyls.setup{
--     on_attach = enhance_attach,
--     capabilities = capabilities,
--     filetypes = { "python" },
--     settings = { 
--      pyls = { 
--        plugins = {
--          pycodestyle =  {
--           enabled = false 
--          },
--          pylint =  {
--           enabled = true 
--          },
--          black = {
--            enabled = true
--          },
--          pyflakes = {enabled = false},
--          jedi_completion = {enabled = true}
--         };
--      };
--   };
-- }

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{
      
      capabilities = capabilities,
      on_attach = enhance_attach,

    }
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end


