--https://github.com/LunarVim/LunarVim/tree/rolling/lua/lvim/lsp
-- Modified though
local M = {}
-- local autocmds = require("lvim.core.autocmds")
local config = require("modules.lsp.lsp.utils.config")

local function add_lsp_buffer_keybindings(client, bufnr)
    -- local border = config.float.border
    vim.keymap.set("n", "<leader>*", function()
        require("modules.lsp.lsp.utils.list").change_active("Quickfix")
        vim.lsp.buf.references()
    end, { buffer = true })

    vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
    vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })

    local lsp_map = {
        ["<Leader>cw"] = "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
        ["gD"] = "<cmd>lua vim.lsp.buf.declaration()<CR>",
        ["gI"] = "<cmd>lua vim.lsp.buf.implementation()<CR>",

        ["<leader>="] = "<cmd>lua vim.lsp.buf.formatting()<CR>",
        ["<leader>ai"] = "<cmd>lua vim.lsp.buf.incoming_calls()<CR>",
        ["<leader>ao"] = "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>",

        ["<C-f>"] = "<cmd> lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>",
        ["<C-b>"] = "<cmd> lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>",

        ["gr"] = "<cmd>Lspsaga rename<CR>",
        ["[e"] = "<cmd> Lspsaga diagnostic_jump_next<cr>",
        ["]e"] = "<cmd> Lspsaga diagnostic_jump_prev<cr>",

        ["gd"] = "<cmd> Lspsaga preview_definition<cr>",
        ["gh"] = "<cmd> Lspsaga lsp_finder<cr>",
        ["gj"] = "<cmd> Lspsaga signature_help<cr>",
        ["ca"] = "<cmd> Lspsaga code_action<cr>",
    }
    for mode_name, mode_char in pairs(lsp_map) do
        vim.keymap.set("n", mode_name, mode_char, { noremap = true, silent = true, buffer = bufnr })
    end

    vim.keymap.set("v", "ca", "<cmd>Lspsaga range_code_action<cr>", { noremap = true, silent = true, buffer = bufnr })
end

-- this could change ove ra period of time . 1
local function select_default_formater(client, bufnr)
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes = 200
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
    require("nvim-navic").attach(client, bufnr)
    require("modules.lsp.lsp.utils.autocmd").setup_autocommands(client, bufnr)
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
    local fn = vim.fn
    for _, sign in ipairs(config.signs) do
        fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
    end
    require("modules.lsp.lsp.utils.handlers").setup()
    require("modules.lsp.lsp.utils.list")
end

function M.enhance_attach(user_config)
    local attach_config = M.get_common_opts()
    if user_config then
        attach_config = vim.tbl_deep_extend("force", attach_config, user_config)
    end
    return attach_config
end

return M
