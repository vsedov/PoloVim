local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
return capabilities
