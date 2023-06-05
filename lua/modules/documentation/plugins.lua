local conf = require("modules.documentation.config")
local docs = require("core.pack").package

docs({ "danymat/neogen", lazy = true, dependencies = { "L3MON4D3/LuaSnip" }, config = conf.neogen })
docs({
    "prichrd/refgo.nvim",
    lazy = true,
    cmd = { "RefCopy", "RefGo" },
})

docs({
    "amrbashir/nvim-docs-view",
    lazy = true,
    cmd = { "DocsViewToggle" },
    config = conf.nvim_doc_help,
})

docs({
    "KabbAmine/zeavim.vim",
    lazy = true,
    cmd = {
        "Zeavim",
        "ZeavimV",
        "Docset",
    },
})

docs({
    "romainl/vim-devdocs",
    cmd = { "DD" },
    lazy = true,
})

docs({
    "loganswartz/updoc.nvim",
    lazy = true,
    config = true,
})

docs({
    "lalitmee/browse.nvim",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = conf.browse,
})

-- Able to write on docs faster
-- Honestly not really required when you have ai o_o
-- docs({
--     "monaqa/nvim-treesitter-clipping",
--     lazy = true,
--     dependencies = { "thinca/vim-partedit" },
--     config = function()
--         vim.keymap.set("n", "<leader>cc", "<Plug>(ts-clipping-clip)")
--     end,
-- })
