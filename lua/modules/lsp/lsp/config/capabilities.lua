local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok then
    return
end

local caps = vim.lsp.protocol.make_client_capabilities()
caps = cmp_nvim_lsp.default_capabilities(caps)
caps.textDocument.completion.completionItem.snippetSupport = true

return caps
