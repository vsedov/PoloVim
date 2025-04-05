local conf = require("plugins.completion.config")
local blink = {
    keymap = { preset = "super-tab" },
}
require("blink.cmp").setup({
    fuzzy = {
        implementation = "lua",
        prebuilt_binaries = {
            download = true,
        },
    },
    keymap = {
        preset = "super-tab",
    },
    completion = {
        menu = {
            draw = {
                -- We don't need label_description now because label and label_description are already
                -- combined together in label by colorful-menu.nvim.
                columns = { { "kind_icon" }, { "label", gap = 1 } },
                components = {
                    label = {
                        text = function(ctx)
                            return require("colorful-menu").blink_components_text(ctx)
                        end,
                        highlight = function(ctx)
                            return require("colorful-menu").blink_components_highlight(ctx)
                        end,
                    },
                },
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
