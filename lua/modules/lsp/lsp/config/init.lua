--https://github.com/LunarVim/LunarVim/tree/rolling/lua/lvim/lsp
-- Modified though
local M = {}
local config = require("modules.lsp.lsp.config.config")

function M.common_capabilities()
    local capabilities = require("modules.lsp.lsp.config.capabilities")
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end
    return capabilities
end

function M.common_on_attach(client, bufnr)
    if config.on_attach_callback[client.name] then
        config.on_attach_callback[client.name](client, bufnr)
    end
    if client.server_capabilities.documentSymbolProvider and lambda.config.lsp.use_navbuddy then
        require("nvim-navbuddy").attach(client, bufnr)
    end
end

function M.get_common_opts()
    return {
        on_attach = M.common_on_attach,
        capabilities = M.common_capabilities(),
    }
end

function M.setup() end

function M.enhance_attach(user_config)
    local attach_config = M.get_common_opts()
    if user_config then
        attach_config = vim.tbl_deep_extend("force", attach_config, user_config)
    end
    return attach_config
end

return M
