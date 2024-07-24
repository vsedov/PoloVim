local conf = require("modules.latex.config")
local latex = require("core.pack").package
local typst = require("core.pack").package

local filetype = { "latex", "tex" }

latex({
    "lervag/vimtex",
    ft = filetype,
    config = conf.vimtex,
})

latex({
    "jghauser/papis.nvim",
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
    "barreiroleo/ltex-extra.nvim",
    cond = lambda.config.lsp.latex == "ltex",
    ft = filetype,
    config = function()
        require("ltex_extra").setup({
            load_langs = { "en-GB" }, -- table <string> : languages for witch dictionaries will be loaded
            init_check = false, -- boolean : whether to load dictionaries on startup
            path = nil, -- string : path to store dictionaries. Relative path uses current working directory
            log_level = "none", -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
        })
    end,
})
latex({
    "frabjous/knap",
    keys = {
        {
            "<leader>vk",
            function()
                require("knap").toggle_autopreviewing()
                vim.keymap.set("n", "<localleader>v", require("knap").forward_jump, { desc = "Fwd Jump" })
            end,
            desc = "Knap",
        },
    },
})
