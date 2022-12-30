local M = {}

M.DocumentHighlightAU = function()
    lambda.augroup("DocumentHighlight", {
        {
            event = "CursorHold",
            buffer = 0,
            command = function()
                pcall(vim.lsp.buf.document_highlight)
            end,
        },
        {
            event = "CursorMoved",
            buffer = 0,
            command = vim.lsp.buf.clear_references,
        },
    })
end

M.SemanticTokensAU = function(bufnr)
    lambda.augroup("SemanticTokens", {
        {
            -- event = { "BufEnter", "CursorHold", "InsertLeave" },
            event = "TextChanged",
            buffer = bufnr,
            command = function()
                vim.lsp.buf.semantic_tokens_full()
            end,
        },
    })
    vim.lsp.buf.semantic_tokens_full()
end

M.InlayHintsAU = function()
    require("modules.lsp.lsp.providers.python.inlay_hint_core").setup_autocmd()
end

return M
