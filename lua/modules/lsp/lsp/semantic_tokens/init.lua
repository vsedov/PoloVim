-- https://github.com/neovim/neovim/pull/15723
require("modules.lsp.lsp.semantic_tokens.core.handlers")
require("modules.lsp.lsp.semantic_tokens.core.buf")
require("modules.lsp.lsp.semantic_tokens.core.protocol")

-- https://github.com/theHamsta/nvim-semantic-tokens
require("modules.lsp.lsp.semantic_tokens.plugin.nvim_semantic_tokens").setup()
