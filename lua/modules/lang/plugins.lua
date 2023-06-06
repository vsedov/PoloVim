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
        {
            "rcarriga/nvim-dap-ui",
            opts = {
                windows = { indent = 2 },
                floating = { border = lambda.style.border.type_0 },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        position = "left",
                        size = 20,
                    },
                    { elements = { { id = "repl", size = 0.9 } }, position = "bottom", size = 10 },
                },
            },
        },
        { "theHamsta/nvim-dap-virtual-text", opts = { all_frames = true } },
        { "LiadOz/nvim-dap-repl-highlights", config = true },
        "ofirgall/goto-breakpoints.nvim",
        "mfussenegger/nvim-dap-python",
        "jay-babu/mason-nvim-dap.nvim",
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
