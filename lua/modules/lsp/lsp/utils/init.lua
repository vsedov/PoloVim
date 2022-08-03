--https://github.com/LunarVim/LunarVim/tree/rolling/lua/lvim/lsp
-- Modified though
local M = {}
local rtest
-- local autocmds = require("lvim.core.autocmds")
local config = require("modules.lsp.lsp.utils.config")

local function add_lsp_buffer_keybindings(client, bufnr)
    local mappings = {
        normal_mode = "n",
        insert_mode = "i",
        visual_mode = "v",
        extra_binds = "n",
    }
    for mode_name, mode_char in pairs(mappings) do
        for key, remap in pairs(config.buffer_mappings[mode_name]) do
            local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
            vim.keymap.set(mode_char, key, remap[1], opts)
        end
    end
end

-- this could change ove ra period of time . 1
local function select_default_formater(client, bufnr)
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes = 200

    client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
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
    config.on_attach_callback["global"](client, bufnr)
    if config.on_attach_callback[client.name] then
        config.on_attach_callback[client.name](client, bufnr)
    end
    add_lsp_buffer_keybindings(client, bufnr)
    require("modules.lsp.lsp.utils.autocmd").setup_autocommands(client, bufnr)
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
