--https://github.com/LunarVim/LunarVim/tree/rolling/lua/lvim/lsp
-- Modified though
local M = {}
-- local autocmds = require("lvim.core.autocmds")
local config = require("modules.lsp.lsp.utils.config")

local function lsp_highlight_document(client, bufnr)
    local status_ok, highlight_supported = pcall(function()
        return client.supports_method("textDocument/documentHighlight")
    end)
    if not status_ok or not highlight_supported then
        return
    end
    local augroup_exist, _ = pcall(vim.api.nvim_get_autocmds, {
        group = "lsp_document_highlight",
    })
    if not augroup_exist then
        vim.api.nvim_create_augroup("lsp_document_highlight", {})
    end
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = "lsp_document_highlight",
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = "lsp_document_highlight",
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
    })
end

local function lsp_code_lens_refresh(client, bufnr)
    local status_ok, codelens_supported = pcall(function()
        return client.supports_method("textDocument/codeLens")
    end)
    if not status_ok or not codelens_supported then
        return
    end
    local augroup_exist, _ = pcall(vim.api.nvim_get_autocmds, {
        group = "lsp_code_lens_refresh",
    })
    if not augroup_exist then
        vim.api.nvim_create_augroup("lsp_code_lens_refresh", {})
    end
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = "lsp_code_lens_refresh",
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
    })
end

local function add_lsp_buffer_keybindings(client, bufnr)
    local border = config.float.border
    vim.keymap.set("n", "<leader>*", function()
        require("modules.lsp.lsp.utils.list").change_active("Quickfix")
        vim.lsp.buf.references()
    end, { buffer = true })

    vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
    vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })

    local lsp_map = {
        ["<Leader>cw"] = "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
        ["gA"] = "<cmd>Lspsaga code_action<CR>",
        ["gX"] = "<cmd>Lspsaga range_code_action<CR>",
        ["gD"] = "<cmd>lua vim.lsp.buf.declaration()<CR>",
        ["gI"] = "<cmd>lua vim.lsp.buf.implementation()<CR>",
        ["gr"] = "<cmd>lua vim.lsp.buf.references()<CR>",
        ["[d"] = "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        ["]d"] = "<cmd>Lspsaga diagnostic_jump_next<CR>",
        ["<leader>="] = "<cmd>lua vim.lsp.buf.formatting()<CR>",
        ["<leader>ai"] = "<cmd>lua vim.lsp.buf.incoming_calls()<CR>",
        ["<leader>ao"] = "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>",
    }
    for mode_name, mode_char in pairs(lsp_map) do
        vim.keymap.set("n", mode_name, mode_char, { noremap = true, silent = true, buffer = bufnr })
    end
end

-- this could change ove ra period of time . 1
local function select_default_formater(client, bufnr)
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes = 200
    if client.name == "null-ls" or not client.server_capabilities.document_formatting then
        vim.diagnostic.config({
            virtual_text = false,
        })
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        vim.api.nvim_create_augroup("LspFormatting", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = "LspFormatting",
            callback = function()
                vim.lsp.buf.format()
            end,
            buffer = bufnr,
        })
        -- else
        --     client.server_capabilities.document_formatting = false
        --     client.server_capabilities.document_range_formatting = false
    end
end

function M.common_on_init(client, bufnr)
    if config.on_init_callback then
        config.on_init_callback(client, bufnr)
        return
    end
    select_default_formater(client, bufnr)
end

function M.common_capabilities()
    local capabilities = require("modules.lsp.lsp.utils.capabilities")
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
    require("modules.lsp.lsp.utils.handlers").setup()
    require("modules.lsp.lsp.utils.autocmd")
    require("modules.lsp.lsp.utils.list")
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
