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

local function add_lsp_buffer_keybindings(client, bufnr)
    local border = config.float.border
    vim.keymap.set("n", "<leader>*", function()
        require("modules.completion.lsp.utils.list").change_active("Quickfix")
        vim.lsp.buf.references()
    end, { buffer = true })

    vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
    vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })

    local lsp_map = {
        ["<Leader>cw"] = "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
        ["gA"] = "<cmd>Lspsaga code_action<CR>",
        ["gD"] = "<cmd>lua vim.lsp.buf.declaration()<CR>",
        ["gI"] = "<cmd>lua vim.lsp.buf.implementation()<CR>",
        ["gr"] = "<cmd>lua vim.lsp.buf.references()<CR>",
        ["[d"] = "<cmd>lua vim.diagnostic.goto_prev()()<CR>",
        ["]d"] = "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
    }
    for mode_name, mode_char in pairs(lsp_map) do
        vim.keymap.set("n", mode_name, mode_char, { noremap = true, silent = true, buffer = bufnr })
    end
end

local function select_default_formater(client)
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes = 200
    if client.name == "null-ls" or not client.resolved_capabilities.document_formatting then
        vim.diagnostic.config({
            virtual_text = false,
        })
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()")
        return
    else
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
end

function M.common_on_init(client, bufnr)
    if config.on_init_callback then
        config.on_init_callback(client, bufnr)
        return
    end
    select_default_formater(client)
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
    lsp_highlight_document(client, bufnr)
    lsp_code_lens_refresh(client, bufnr)
    add_lsp_buffer_keybindings(client, bufnr)
end

function M.get_common_opts()
    return {
        on_init = M.common_on_init,
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
    require("modules.completion.lsp.utils.list")
end

function M.enhance_attach(user_config)
    M.setup()

    local config = M.get_common_opts()
    if user_config then
        config = vim.tbl_deep_extend("force", config, user_config)
    end
    return config
end

return M
