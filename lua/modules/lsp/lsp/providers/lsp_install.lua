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
local function on_server_ready(server)
    local opts = require("modules.lsp.lsp.utils").get_common_opts()
    local has_custom_config, server_custom_config = pcall(require, "core.lsp.server_settings." .. server.name)
    if has_custom_config then
        if type(server_custom_config) == "function" then
            return server_custom_config(server, opts)
        else
            opts = vim.tbl_deep_extend("force", opts, server_custom_config)
        end
    end
    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end

lsp_installer.on_server_ready(on_server_ready)
