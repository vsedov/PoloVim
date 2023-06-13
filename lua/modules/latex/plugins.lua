local conf = require("modules.latex.config")
local latex = require("core.pack").package

local filetype = { "latex", "tex" }

latex({
    "lervag/vimtex",
    lazy = true,
    ft = filetype,
    init = conf.vimtex,
})

latex({
    "jakewvincent/texmagic.nvim",
    ft = filetype,
    config = conf.texmagic,
})

latex({
    "jghauser/papis.nvim",
    lazy = true,
    ft = filetype,
    dependencies = {
        "kkharji/sqlite.lua",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = conf.papis,
})

latex({
    "iurimateus/luasnip-latex-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    ft = filetype,
    config = function()
        require("luasnip-latex-snippets").setup({ use_treesitter = true })
    end,
})

latex({
    "barreiroleo/ltex-extra.nvim",
    lazy = true,
    ft = { "latex", "tex" },
})
