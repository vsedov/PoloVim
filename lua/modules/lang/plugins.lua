local conf = require("modules.lang.config")
local lang = require("core.pack").package

-- -- Inline functions dont seem to work .
lang({
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = conf.refactor,
})

-- -- -- -- OPTIM(vsedov) (01:01:25 - 14/08/22): If this gets used more, i will load this
-- -- -- on startup, using lazy.lua
lang({
    "andrewferrier/debugprint.nvim",
    lazy = true,
    keys = {
        { "g?p", mode = "n" },
        { "g?P", mode = "n" },
        { "g?v", mode = "n" },
        { "g?V", mode = "n" },
        { "g?l", mode = "n" },
        { "g?L", mode = "n" },
        { "g?V", mode = "v" },
        { "g?v", mode = "v" },
        { "g?o", mode = "x" },
        { "g?O", mode = "x" },
    },
    cmd = "DeleteDebugPrints",
    config = conf.debugprint,
})

lang({ "yardnsm/vim-import-cost", cmd = "ImportCost", opt = true })

lang({ "nanotee/luv-vimdocs", opt = true })

-- -- -- builtin lua functions
lang({ "milisims/nvim-luaref", opt = true })

lang({
    "rafcamlet/nvim-luapad",
    ft = "lua",
    config = conf.luapad,
})

lang({
    "Weissle/persistent-breakpoints.nvim",
    lazy = true,
    config = true,
})
lang({
    "mfussenegger/nvim-dap",
    lazy = true,
    config = conf.dap_config,
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "ofirgall/goto-breakpoints.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
        "LiadOz/nvim-dap-repl-highlights",
    },
})

lang({
    "bennypowers/nvim-regexplainer",
    lazy = true,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "MunifTanjim/nui.nvim",
    },
    cmd = {
        "RegexplainerShow",
        "RegexplainerShowSplit",
        "RegexplainerShowPopup",
        "RegexplainerHide",
        "RegexplainerToggle",
    },
    config = conf.regexplainer,
})
