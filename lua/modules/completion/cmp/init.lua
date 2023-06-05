local cmp = require("cmp")
cmp.setup(require("modules.completion.cmp.config"))
require("cmp").event:on("menu_opened", function()
    if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "c" then
        vim.api.nvim_exec_autocmds("User", { pattern = "IntPairsComp", modeline = false })
    end
end)

local search_sources = {
    view = { entries = { name = "custom", selection_order = "near_cursor" } },
    sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
    }, {
        { name = "buffer" },
    }),
}

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline_history" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" },
            },
        },
    }),
})

-- regex that ignore :q and :w

require("modules.completion.cmp.extra")
require("modules.completion.cmp.ui_overwrite")
