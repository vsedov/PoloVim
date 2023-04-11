local ht = require("haskell-tools")
local buffer = vim.api.nvim_get_current_buf()
local def_opts = { noremap = true, silent = true }
ht.start_or_attach({
    hls = {
        on_attach = function(client, bufnr)
            local opts = vim.tbl_extend("keep", def_opts, { buffer = bufnr })
            -- haskell-language-server relies heavily on codeLenses,
            -- so auto-refresh (see advanced configuration) is enabled by default
            vim.keymap.set("n", "<space>ca", vim.lsp.codelens.run, opts)
            vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, opts)
            vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts)
        end,
    },
})

-- Suggested keymaps that do not depend on haskell-language-server:
local bufnr = vim.api.nvim_get_current_buf()
-- set buffer = bufnr in ftplugin/haskell.lua
local opts = { noremap = true, silent = true, buffer = bufnr }

-- Toggle a GHCi repl for the current package
vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set("n", "<leader>rf", function()
    ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, def_opts)
vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)
