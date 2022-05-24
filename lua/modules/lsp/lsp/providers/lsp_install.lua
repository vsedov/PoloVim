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
    -- (optional) Customize the options passed to the server
    if server.name == "jdtls" then
        return
    end
    server:setup(opts)
    -- vim.cmd([[ do User LspAttachBuffers ]])
end)
