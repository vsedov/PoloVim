--https://github.com/LunarVim/LunarVim/tree/rolling/lua/lvim/lsp
-- Modified though
local M = {}
-- local autocmds = require("lvim.core.autocmds")
local config = require("modules.completion.lsp.utils.config")

local function lsp_highlight_document(client, bufnr)
    if config.document_highlight == false then
        return -- we don't need further
    end
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
            buffer = bufnr,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                vim.lsp.buf.clear_references()
            end,
            buffer = bufnr,
        })
    end
end

local function lsp_code_lens_refresh(client, bufnr)
    if config.code_lens_refresh == false then
        return
    end

    if client.resolved_capabilities.code_lens then
        vim.api.nvim_create_autocmd("InsertLeave", {
            command = [[lua vim.lsp.codelens.refresh()]],
            buffer = bufnr,
        })
        vim.api.nvim_create_autocmd("InsertLeave", {
            command = [[lua vim.lsp.codelens.display()]],
            buffer = bufnr,
        })
    end
end

function M.common_capabilities()
    local capabilities = require("modules.completion.lsp.utils.capabilities")
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    end
    return capabilities
end

function M.common_on_attach(client, bufnr)
    if config.on_attach_callback then
        config.on_attach_callback(client, bufnr)
    end
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    lsp_highlight_document(client, bufnr)
    lsp_code_lens_refresh(client, bufnr)
end

function M.get_common_opts()
    return {
        on_attach = M.common_on_attach,
        capabilities = M.common_capabilities(),
    }
end

function M.setup()
    for _, sign in ipairs(config.signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
    end

    require("modules.completion.lsp.utils.handlers").setup()
    require("modules.completion.lsp.utils.autocmd")
end

return M
