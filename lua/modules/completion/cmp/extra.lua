local cmp = require("cmp")
local tabnine_options = lambda.config.cmp.tabnine

if not lambda.config.use_lexima then
    require("packer").loader("nvim-autopairs")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
end
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

local neorg = require("neorg")

local function load_completion()
    neorg.modules.load_module("core.norg.completion", nil, {
        engine = "nvim-cmp",
    })
end

if neorg.is_loaded() then
    load_completion()
else
    neorg.callbacks.on_event("core.started", load_completion)
end

if tabnine_options.use_tabnine and tabnine_options.tabnine_prefetch then
    local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
    vim.api.nvim_create_autocmd("BufRead", {
        group = prefetch,
        pattern = lambda.config.main_file_types,
        callback = function()
            require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
        end,
    })
end
