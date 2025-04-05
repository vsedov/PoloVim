local conf = require("plugins.completion.config")
local blink = {
    keymap = { preset = "super-tab" },
}

require("blink.cmp").setup({
    fuzzy = {
        implementation = "lua",
        prebuilt_binaries = {
            download = false,
        },
    },
    keymap = {
        preset = "super-tab",
    },
    completion = {
        list = {
            selection = {
                preselect = function(ctx)
                    return not require("blink.cmp").snippet_active({ direction = 1 })
                end,
            },
        },
    },
    signature = { enabled = true },
})
require("blink.cmp.fuzzy").set_implementation("rust")

conf.luasnip()
require("luasnip-latex-snippets").setup()
require("luasnip").config.setup({ enable_autosnippets = true })

conf.neotab()
conf.autopair()

-- -- or "<Plug>(neotab-out)"
-- vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help)
-- vim.api.nvim_create_autocmd("CursorHoldI", {
--     desc = "Show diagnostics on CursorHold",
--     pattern = "* !silent",
--     callback = function()
--         vim.lsp.buf.signature_help()
--     end,
-- })
-- Simple autocmd to close the signature help when leaving insert mode
vim.defer_fn(function()
    require("mason").setup({
        ui = {
            border = lambda.style.border.type_0,
            height = 0.8,
        },
    })

    require("mason-lspconfig").setup({
        automatic_installation = true,
        handlers = {
            function(name)
                local config = require("plugins.lsp.lsp.mason.lsp_servers")(name)
                if config then
                    config.capabilities = require("blink.cmp").get_lsp_capabilities()
                    require("lspconfig")[name].setup(config)
                end
            end,
        },
    })
end, 100)
