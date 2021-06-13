local api = vim.api
local lspconfig = require 'lspconfig'
local global = require 'core.global'
local format = require('modules.completion.format')
local fn = vim.fn

require("lsp-rooter").setup {}


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

capabilities.textDocument.codeAction = {
  dynamicRegistration = false;
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
      };
    };
  };
}




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


-- I dont like the lsp diagnositcs, it can be very annoying and gets in teh way
-- vim.lsp.handlers['textDocument/publishDiagnostics']= function() end
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = false,
    -- Enable virtual text, override spacing to 4
    virtual_text = false,
    signs = {
      enable = true,
      priority = 20
    },
    -- Disable a feature
    update_in_insert = true,
  })
vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]

vim.cmd [[autocmd CursorHoldI * silent! Lspsaga signature_help]]



local enhance_attach = function(client,bufnr)
  if client.resolved_capabilities.document_formatting then
    format.lsp_before_save()
  end
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

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




lspconfig.jedi_language_server.setup{
  cmd = { "jedi-language-server" },
  filetypes = { "python" },
  on_attach = enhance_attach,
  capabilities = capabilities,
}

lspconfig.diagnosticls.setup {
  filetypes = { "python" },
  init_options = {
    filetypes = {
      python = {"flake8"},
    },
    linters = {
      flake8 = {
        debounce = 100,
        sourceName = "flake8",
        command = "flake8",
        args = {
          "--extend-ignore=E",
          "--format",
          "%(row)d:%(col)d:%(code)s:%(code)s: %(text)s",

          "%file",

        },
        formatPattern = {
          "^(\\d+):(\\d+):(\\w+):(\\w).+: (.*)$",
          {
            line = 1,
            column = 2,
            message = {"[", 3, "] ", 5},
            security = 4
          }
        },
        securities = {
          E = "error",
          W = "warning",
          F = "info",
          B = "hint",
        },
      },
    },
  }
}


lspconfig.jdtls.setup{
  filetypes = {"java"},
  cmd = {'jdtls'},
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



lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = enhance_attach,

  cmd = {'lua-language-server', "-E", '/usr/share/lua-language-server/main.lua'};
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

lspconfig.vimls.setup{
  on_attach = enhance_attach,
  capabilities = capabilities,

  cmd = { "vim-language-server", "--stdio" };
  filetypes = {"vim"},
  init_options = {
    diagnostic = {
      enable = true
    },
    indexes = {
      count = 3,
      gap = 100,
      projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
      runtimepath = true
    },
    iskeyword = "@,48-57,_,192-255,-#",
    runtimepath = "",
    suggest = {
      fromRuntimepath = true,
      fromVimruntime = true
    },
    vimruntime = "",
  },
}



vim.api.nvim_call_function('sign_define', {"LspDiagnosticsSignError", {text = "", texthl = "LspDiagnosticsDefaultError"}})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsDefaultHint"})
vim.fn.sign_define("LspDiagnosticsSignOther", {text = "﫠", texthl = "LspDiagnosticsDefaultOther"})



--trash

-- i like jedi
-- lspconfig.pyls.setup{
--     on_attach = enhance_attach,
--     capabilities = capabilities,
--     filetypes = { "python" },
--      settings = {
--       pyls = {
--                   plugins = {
--                         jedi_completion = {
--                         enabled=true,
--                         include_params=true,
--                         include_class_objects=true
--                       },
--                       pycodestyle={enabled=false},
--                       mccabe={enabled=false},
--                       pyflakes={enabled=false},
--                       pylint= {
--                       enabled=true,
--                       args = {"--rcfile ~/.config/pylintrc"}
--                       }
--                   },
--               },
--           },
-- }





-- lspconfig.pyright.setup{
--     -- on_attach = enhance_attach,
--     cmd = {'pyright-langserver','--stdio'}
--   --   capabilities = capabilities,
--   --   settings = {
--   --     python = {
--   --       analysis = {
--   --         autoSearchPaths = true;
--   --         useLibraryCodeForTypes = true;
--   --         autoImportCompletions = true;
--   --       };
--   --   };
--   -- };
-- };


-- lspconfig.ccls.setup {
--   cmd = {"ccls" },
--   on_attach = enhance_attach,
--   capabilities = capabilities,
--   filetypes = { "c", "cpp", "objc", "objcpp" },

-- }
-- require'lspinstall'.setup() -- important

-- local servers = require'lspinstall'.installed_servers()
-- for _, server in pairs(servers) do
--   require'lspconfig'[server].setup{}
-- end


-- local function setup_servers()
--   require'lspinstall'.setup()
--   local servers = require'lspinstall'.installed_servers()
--   for _, server in pairs(servers) do
--     require'lspconfig'[server].setup{

--       capabilities = capabilities,
--       on_attach = enhance_attach,

--     }
--   end
-- end

-- setup_servers()

-- -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
-- require'lspinstall'.post_install_hook = function ()
--   setup_servers() -- reload installed servers
--   vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
-- end

-- if not packer_plugins['lspinstall'].loaded then
--   vim.cmd [[packadd lspinstall]]

-- end

-- vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
-- vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
