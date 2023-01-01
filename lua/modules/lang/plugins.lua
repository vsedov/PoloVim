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

lang({ "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle" }, lazy = true, config = conf.trouble })

-- -- lang({
-- --     "ram02z/dev-comments.nvim",
-- --     dependencies = {
-- --         "nvim-treesitter/nvim-treesitter",
-- --         "nvim-lua/plenary.nvim",
-- --         "nvim-telescope/telescope.nvim", -- optional
-- --     },
-- --     lazy = true,
-- --     after = "telescope.nvim",
-- --     config = conf.dev_comments,
-- -- })
-- -- -- -- not the same as folkes version
-- lang({ "bfredl/nvim-luadev", lazy = true, ft = "lua", init = conf.luadev })

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
    },
})

lang({
    "rcarriga/neotest",
    lazy = true,
    cmd = {
        "TestNear",
        "TestCurrent",
        "TestSummary",
        "TestOutput",
        "TestStrat",
        "TestStop",
        "TestAttach",
    },
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
        { "rcarriga/neotest-python" },
        { "rcarriga/neotest-plenary" },
        { "stevearc/overseer.nvim" },
    },
    config = conf.neotest,
})
lang({
    "rcarriga/neotest-vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    dependencies = { "vim-test/vim-test", lazy = true },
})

lang({
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    config = conf.overseer,
})

lang({
    "CRAG666/code_runner.nvim",
    cmd = {
        "RunCode",
        "RunFile",
        "RunProject",
        "RunClose",
        "CRFiletype",
        "CRProjects",
    },
    lazy = true,
    config = conf.code_runner,
})

lang({
    "andythigpen/nvim-coverage",
    cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
    lazy = true,
    config = conf.coverage,
})
-- -- -- IPython Mappings

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

lang({ "dccsillag/magma-nvim", ft = "python", build = ":UpdateRemotePlugins" })

lang({
    "0x100101/lab.nvim",
    lazy = true,
    build = "cd js && npm ci",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
        "Lab code",
        "Lab",
    },
    keys = {
        "<localleader>rs",
        "<localleader>rr",
        "<localleader>rp",
    },
    config = function()
        require("lab").setup({
            code_runner = {
                enabled = true,
            },
            quick_data = {
                enabled = true,
            },
        })
    end,
})
lang({
    "michaelb/sniprun",
    build = "bash ./install.sh",
    module = { "sniprun" },
    cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose", "SnipLive" },
    config = function() end,
})
