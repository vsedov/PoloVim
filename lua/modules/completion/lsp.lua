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

require("lsp-colors").setup({})

local codes = { 
  no_matching_function = { 
    "redundant-parameter", 
    "ovl_no_viable_function_in_call",
  }

}
local border = {
  { "🭽", "FloatBorder" },
  { "▔", "FloatBorder" },
  { "🭾", "FloatBorder" },
  { "▕", "FloatBorder" },
  { "🭿", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "🭼", "FloatBorder" },
  { "▏", "FloatBorder" },
  -- { "╭", "FloatBorder" },
  -- { "─", "FloatBorder" },
  -- { "╮", "FloatBorder" },
  -- { "│", "FloatBorder" },
  -- { "╯", "FloatBorder" },
  -- { "─", "FloatBorder" },
  -- { "╰", "FloatBorder" },
  -- { "│", "FloatBorder" },
}

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  float = {
    focusable = true,
    style = "minimal",
    source = "always",
    header = " diagnostic",
    scope = "cursor", 
    prefix = function(prefix, i, total)
      return i .. "/" .. total .. " "
    end,
    format = function(d)
      local t = vim.deepcopy(d)
      if d.code then
        t.message = string.format("%s [%s]", t.message, t.code):gsub("1. ", "")
      end
      return t.message
    end,
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.offsetEncoding = { "utf-16" }

capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
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

local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- wrap open_float to inspect diagnostics and use the severity color for border
-- https://neovim.discourse.group/t/lsp-diagnostics-how-and-where-to-retrieve-severity-level-to-customise-border-color/1679
vim.diagnostic.open_float = (function(orig)
  return function(bufnr, opts)
    local line_number = vim.api.nvim_win_get_cursor(0)[1] - 1
    local opts = opts or {}

    local diagnostics = vim.diagnostic.get(opts.bufnr or 0, { lnum = line_number })
    local max_severity = vim.diagnostic.severity.HINT
    for _, d in ipairs(diagnostics) do
      if d.severity < max_severity then
        max_severity = d.severity
      end
    end
    local border_color = ({
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
    })[max_severity]
    opts.border = border
    orig(bufnr, opts)
  end
end)(vim.diagnostic.open_float)

-- Show line diagnostics in floating popup on hover, except insert mode (CursorHoldI)
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float()]])

-- show diagnostics for current line
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {})]])
-- show diagnostics for current position
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {scope="cursor"})]])

-- vim.cmd([[hi DiagnosticHeader gui=bold,italic guifg=#56b6c2]])
-- vim.cmd(
--   [[au CursorHold   * lua vim.diagnostic.open_float(0, { focusable = true,scope = "cursor",source = "if_many",

-- format = function(diagnostic)
--   return require'modules.completion.lsp_support'.parse_diagnostic(diagnostic)
-- end,
-- header = {"Cursor Diagnostics:","DiagnosticHeader"},
--
-- prefix = function(diagnostic,i,total)
--   local icon, highlight
--   if diagnostic.severity == 1 then icon = ""; highlight ="DiagnosticError" elseif diagnostic.severity == 2 then icon = ""; highlight ="DiagnosticWarn" elseif diagnostic.severity == 3 then icon = ""; highlight ="DiagnosticInfo" elseif diagnostic.severity == 4 then icon = ""; highlight ="DiagnosticHint" end
--
-- return i.."/"..total.." "..icon.."  ",highlight end})]]
-- -- )
--
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
-- Need to configer this for xmake soon
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






-- lspconfig.diagnosticls.setup({
-- filetypes = { "python" },
-- init_options = {
--     filetypes = {
--         python = { "flake8" },
--     },
--     linters = {
--         flake8 = {
--             debounce = 100,
--             sourceName = "flake8",
--             command = "flake8",
--             args = {
--                 "--extend-ignore=E",
--                 "--format",
--                 "%(row)d:%(col)d:%(code)s:%(code)s: %(text)s",
--                 "%file",
--             },
--             formatPattern = {
--                 "^(\\d+):(\\d+):(\\w+):(\\w).+: (.*)$",
--                 {
--                     line = 1,
--                     column = 2,
--                     message = { "[", 3, "] ", 5 },
--                     security = 4,
--                 },
--             },
--             securities = {
--                 E = "error",
--                 W = "warning",
--                 F = "info",
--                 B = "hint",
--             },
--         },
--     },
-- },
-- })