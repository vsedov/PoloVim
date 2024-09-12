local conf = require("plugins.completion.config")
conf.luasnip()
require("luasnip-latex-snippets").setup()
require("luasnip").config.setup({ enable_autosnippets = true })

conf.neotab()
conf.autopair()

-- conf.cmp()
local labels = { "q", "w", "r", "t", "z", "i", "o" }

require("care.config").setup({})

-- Keymappings
for i, label in ipairs(labels) do
    vim.keymap.set("i", "<c-" .. label .. ">", function()
        require("care").api.select_visible(i)
    end)
end

vim.keymap.set("i", "<c-n>", function()
    vim.snippet.jump(1)
end)
vim.keymap.set("i", "<c-p>", function()
    vim.snippet.jump(-1)
end)
vim.keymap.set("i", "<CR>", function()
    require("care").api.complete()
end)

vim.keymap.set("i", "<c-f>", function()
    if require("care").api.doc_is_open() then
        require("care").api.scroll_docs(4)
    elseif require("luasnip").choice_active() then
        require("luasnip").change_choice(1)
    else
        vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
    end
end)

vim.keymap.set("i", "<c-d>", function()
    if require("care").api.doc_is_open() then
        require("care").api.scroll_docs(-4)
    elseif require("luasnip").choice_active() then
        require("luasnip").change_choice(-1)
    else
        vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
    end
end)

vim.keymap.set("i", "<cr>", "<Plug>(CareConfirm)")
vim.keymap.set("i", "<c-e>", "<Plug>(CareClose)")
vim.keymap.set("i", "<S-Tab>", "<Plug>(CareSelectPrev)")
vim.keymap.set("i", "<Tab>", "<Plug>(CareSelectNext)")

-- or "<Plug>(neotab-out)"
vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help)
vim.api.nvim_create_autocmd("CursorHoldI", {
    desc = "Show diagnostics on CursorHold",
    pattern = "* !silent",
    callback = function()
        vim.lsp.buf.signature_help()
    end,
})
