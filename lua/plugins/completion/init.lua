local conf = require("plugins.completion.config")
local blink = {
    keymap = { preset = "super-tab" },
}
require("blink.cmp").setup({

    keymap = {
        preset = "super-tab",
    },
    -- selection: expected one of: preselect, manual, auto_insert, got table: 0x7f83818b4e48

    appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
    },

    sources = {
        default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
        },
    },
    -- completion = {
    --     accept = {
    --         auto_brackets = {
    --             enabled = true,
    --         },
    --     },
    --     documentation = {
    --         auto_show = true,
    --         auto_show_delay_ms = 500,
    --     },
    -- },
    -- signature = {
    --     enabled = true,
    -- },
})

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
