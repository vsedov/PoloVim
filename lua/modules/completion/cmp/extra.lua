local cmp = require("cmp")

if vim.o.ft == "clap_input" or vim.o.ft == "guihua" or vim.o.ft == "guihua_rust" then
    cmp.setup.buffer({ completion = { enable = false } })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "TelescopePrompt", "clap_input" },
    callback = function()
        cmp.setup.buffer({ enabled = false })
    end,
    once = false,
})

vim.api.nvim_set_hl(0, "CmpItemKindCody", { fg = "Red" })

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
