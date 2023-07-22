local cmp = require("cmp")
local tabnine_options = lambda.config.ai.tabnine.cmp
-- tabnine = {
--     use_tabnine = use_tabnine,
--     use_tabnine_cmp = use_tabnine_cmp,
--     use_tabnine_insert = not use_tabnine_cmp,
--     cmp = {
--         tabnine_sort = false, -- I am not sure how i feel about if i want tabnine to actively sort stuff for me.
--         tabnine_bottom_sort = true,
--         tabnine_prefetch = true,
--         tabnine_priority = 1, -- 10 if you want god mode, else reduce this down to what ever you think is right for you
--     },
-- },

-- require'cmp'.setup.cmdline(':', {sources = {{name = 'cmdline'}}})
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

if lambda.config.ai.tabnine.use_tabnine_cmp and tabnine_options.tabnine_prefetch then
    local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
    vim.api.nvim_create_autocmd("BufRead", {
        group = prefetch,
        pattern = lambda.config.main_file_types,
        callback = function()
            require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
        end,
    })
end
