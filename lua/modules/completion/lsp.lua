local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")
local global = require("core.global")
local lsp = require("vim.lsp")
local fn = vim.fn
local api = vim.api

if not packer_plugins["telescope.nvim"].loaded then
  vim.cmd([[packadd telescope.nvim]])
end
if not packer_plugins["nvim-lsp-installer"].loaded then
  vim.cmd([[packadd nvim-lsp-installer]])
end

if not packer_plugins["lsp-colors.nvim"].loaded then
  vim.cmd([[packadd lsp-colors.nvim]])
end



vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    format = function(d)
      local t = vim.deepcopy(d)
      if d.code then
        t.message = string.format("%s [%s]", t.message, t.code):gsub("1. ", "")
      end
      return t.message
    end,
  },
})

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = border }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = border }
)


local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.offsetEncoding = { "utf-16" }

capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport =
  true
capabilities.textDocument.completion.completionItem.tagSupport = {
  valueSet = { 1 },
}
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}


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

-- show diagnostics for current line
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {})]])
-- show diagnostics for current position
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {scope="cursor"})]])


vim.cmd([[hi DiagnosticHeader gui=bold,italic guifg=#56b6c2]])
vim.cmd(
  [[au CursorHold,CursorHoldI  * lua vim.diagnostic.open_float(0, { focusable = true,scope = "cursor",source = "if_many",format = function(diagnostic) return require'modules.completion.lsp_support'.parse_diagnostic(diagnostic) end, header = {"Cursor Diagnostics:","DiagnosticHeader"}, prefix = function(diagnostic,i,total) local icon, highlight if diagnostic.severity == 1 then icon = ""; highlight ="DiagnosticError" elseif diagnostic.severity == 2 then icon = ""; highlight ="DiagnosticWarn" elseif diagnostic.severity == 3 then icon = ""; highlight ="DiagnosticInfo" elseif diagnostic.severity == 4 then icon = ""; highlight ="DiagnosticHint" end return i.."/"..total.." "..icon.."  ",highlight end})]]
)



function _G.reload_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.cmd([[edit]])
end

function _G.open_lsp_log()
  local path = vim.lsp.get_log_path()
  vim.cmd("edit " .. path)
end

vim.cmd("command! -nargs=0 LspLog call v:lua.open_lsp_log()")
vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")

local enhance_attach = function(client, bufnr)
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

lspconfig.gopls.setup({
  filetypes = { "go" },
  cmd = { "gopls", "--remote=auto" },
  on_attach = enhance_attach,
  capabilities = capabilities,
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
  },
})

lspconfig.tsserver.setup({
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    enhance_attach(client)
  end,
})

local custom_on_attach_num = function(client, bufnr)
  -- This is the new thing added
  local opts = {
    noremap = true,
    silent = true,
  }
end

-- lspconfig.ccls.setup {
--   cmd = {"ccls" },
--   on_attach = enhance_attach,
--   capabilities = capabilities,
--   filetypes = { "c", "cpp", "objc", "objcpp" },

-- }
local clangd_flags = {
  "--background-index",
  "--cross-file-rename",
  "--offset-encoding=utf-16",
  "--clang-tidy-checks=clang-diagnostic-*,clang-analyzer-*,-*,bugprone*,modernize*,performance*,-modernize-pass-by-value,-modernize-use-auto,-modernize-use-using,-modernize-use-trailing-return-type",
}

lspconfig.clangd.setup({
  cmd = { "clangd", unpack(clangd_flags) },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  on_attach = enhance_attach,
  capabilities = capabilities,
})

lspconfig.jedi_language_server.setup({
  cmd = { "jedi-language-server" },
  filetypes = { "python" },
  on_attach = enhance_attach,
  capabilities = capabilities,
})

lspconfig.sqlls.setup({

  filetypes = { "sql", "mysql" },
  cmd = { "sql-language-server", "up", "--method", "stdio" },
  on_attach = enhance_attach,
  capabilities = capabilities,
})

-- You will have to Build a package for this .
lspconfig.rust_analyzer.setup({
  filetypes = { "rust" },
  cmd = { "rust-analyzer" },
  capabilities = capabilities,
  on_attach = enhance_attach,
})
lspconfig.jdtls.setup({
  cmd = { "jdtls" },
  filetypes = { "java" },
  on_attach = enhance_attach,
  capabilities = capabilities,
})
-- lspconfig.jdtls.setup({ cmd = { "jdtls" } })

lspconfig.sumneko_lua.setup({
  capabilities = capabilities,
  on_attach = enhance_attach,

  cmd = { "lua-language-server", "-E", "/usr/share/lua-language-server/main.lua" },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

lspconfig.vimls.setup({
  on_attach = enhance_attach,
  capabilities = capabilities,

  cmd = { "vim-language-server", "--stdio" },
  filetypes = { "vim" },
  init_options = {
    diagnostic = {
      enable = true,
    },
    indexes = {
      count = 3,
      gap = 100,
      projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
      runtimepath = true,
    },
    iskeyword = "@,48-57,_,192-255,-#",
    runtimepath = "",
    suggest = {
      fromRuntimepath = true,
      fromVimruntime = true,
    },
    vimruntime = "",
  },
})

require("nvim-lsp-installer").settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
})

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
})

lsp_installer.on_server_ready(function(server)
  local opts = {}
  server:setup(opts)
  -- vim.cmd([[ do User LspAttachBuffers ]])
end)
