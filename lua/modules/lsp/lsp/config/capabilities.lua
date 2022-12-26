local M = vim.lsp.protocol.make_client_capabilities()

M.window = M.window or {}
M.window.workDoneProgress = true

-- https://microsoft.github.io/language-server-protocol/specifications/specification-3-17/#completionClientCapabilities
M.textDocument.completion.completionItem.snippetSupport = true
M.textDocument.completion.completionItem.commitCharactersSupport = true
M.textDocument.completion.completionItem.deprecatedSupport = true
M.textDocument.completion.completionItem.preselectSupport = true
M.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
M.textDocument.completion.completionItem.insertReplaceSupport = true
M.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}
M.textDocument.completion.completionItem.labelDetailsSupport = true

return M
