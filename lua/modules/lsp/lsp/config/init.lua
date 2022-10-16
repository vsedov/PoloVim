--https://github.com/LunarVim/LunarVim/tree/rolling/lua/lvim/lsp
-- Modified though
local cfg = {
    bind = true,
    fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
    doc_lines = 10,

    floating_window = false, -- show hint in a floating window, set to false for virtual text only mode ]]
    floating_window_above_cur_line = false,
    hint_enable = true, -- virtual hint enable
    hint_prefix = "🐼 ", -- Panda for parameter
    auto_close_after = 15, -- close after 15 seconds
    --[[ hint_prefix = " ", ]]
    toggle_key = "»",
    select_signature_key = "<C-n>",
    max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    handler_opts = {
        border = lambda.style.border.type_0, -- double, single, shadow, none
    },

    transpancy = 80,
    zindex = 300, -- by default it will be on top of all floating windows, set to 50 send it to bottom
    debug = plugin_debug(),
    verbose = plugin_debug(),
    log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
    padding = " ", -- character to pad on left and right of signature can be ' ', or '|'  etc
}
local M = {}
local config = require("modules.lsp.lsp.config.config")

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

function M.common_on_init(client, bufnr)
    if config.on_init_callback then
        config.on_init_callback(client, bufnr)
        return
    end
end
function M.common_capabilities()
    local capabilities = require("modules.lsp.lsp.config.capabilities")
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end
    return capabilities
end

function M.common_on_attach(client, bufnr)
    config.on_attach_callback["global"](client, bufnr)
    if config.on_attach_callback[client.name] then
        config.on_attach_callback[client.name](client, bufnr)
    end

    if lambda.config.lsp.use_lsp_signature then
        require("lsp_signature").on_attach(cfg, bufnr)
    end
    add_lsp_buffer_keybindings(client, bufnr)
    require("modules.lsp.lsp.config.autocmd").setup_autocommands(client, bufnr)
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

    require("modules.lsp.lsp.config.handlers").setup()
    require("modules.lsp.lsp.config.list")
end

function M.enhance_attach(user_config)
    local attach_config = M.get_common_opts()
    if user_config then
        attach_config = vim.tbl_deep_extend("force", attach_config, user_config)
    end
    return attach_config
end

return M
