local conf = require("modules.lang.config")
local lang = require("core.pack").package

-- Inline functions dont seem to work .
lang({
    "ThePrimeagen/refactoring.nvim",
    module = "refactoring",
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = conf.refactor,
})

-- OPTIM(vsedov) (01:01:25 - 14/08/22): If this gets used more, i will load this
-- on startup, using lazy.lua
lang({
    "andrewferrier/debugprint.nvim",
    keys = {
        { "n", "g?p" },
        { "n", "g?P" },
        { "n", "g?v" },
        { "n", "g?V" },
        { "n", "dvl" },
        { "n", "dvL" },
        { "v", "g?V" },
        { "v", "g?v" },
        { "x", "g?o" },
        { "x", "g?O" },
    },
    module = "debugprint",
    cmd = "DeleteDebugPrints",
    config = conf.debugprint,
})

lang({ "yardnsm/vim-import-cost", cmd = "ImportCost", opt = true })

lang({ "nanotee/luv-vimdocs", opt = true })

-- builtin lua functions
lang({ "milisims/nvim-luaref", opt = true })

lang({ "mtdl9/vim-log-highlighting", ft = { "text", "log" } })

lang({ "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle" }, opt = true, config = conf.trouble })

lang({
    "ram02z/dev-comments.nvim",
    requires = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim", -- optional
    },
    opt = true,
    setup = function()
        lambda.lazy_load({
            events = "BufEnter",
            augroup_name = "comment",
            condition = true,
            plugin = "dev-comments.nvim",
        })
    end,
    config = conf.dev_comments,
})
-- not the same as folkes version
lang({ "bfredl/nvim-luadev", opt = true, ft = "lua", setup = conf.luadev })

lang({
    "rafcamlet/nvim-luapad",
    ft = "lua",
    config = conf.luapad,
})

lang({
    "Weissle/persistent-breakpoints.nvim",
    requires = "mfussenegger/nvim-dap",
    module = "persistent-breakpoints",
    config = function()
        require("persistent-breakpoints").setup({})
    end,
})
lang({
    "mfussenegger/nvim-dap",
    module = "dap",
    config = conf.dap_config,
    requires = {
        {
            "rcarriga/nvim-dap-ui",
            after = "nvim-dap",
            config = conf.dapui,
        },
        {
            "mfussenegger/nvim-dap-python",
            after = "nvim-dap",
            ft = "python",
        },
        "folke/which-key.nvim",
    },
})
lang({
    "ofirgall/goto-breakpoints.nvim",
    after = "nvim-dap",
    config = function()
        local map = vim.keymap.set
        map("n", "]d", require("goto-breakpoints").next, {})
        map("n", "[d", require("goto-breakpoints").prev, {})
    end,
})

lang({ "mfussenegger/nvim-jdtls", ft = "java", opt = true })

lang({
    "rcarriga/neotest",
    opt = true,
    cmd = {
        "TestNear",
        "TestCurrent",
        "TestSummary",
        "TestOutput",
        "TestStrat",
        "TestStop",
        "TestAttach",
    },
    requires = {
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
    requires = { "vim-test/vim-test", opt = true, after = "neotest" },
})
lang({
    "stevearc/overseer.nvim",
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
    opt = true,
    config = conf.code_runner,
})

lang({
    "andythigpen/nvim-coverage",
    cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
    opt = true,
    config = conf.coverage,
})
lang({ "mgedmin/coverage-highlight.vim", ft = "python", opt = true, run = ":UpdateRemotePlugins" })

-- -- IPython Mappings
lang({
    lambda.use_local("py.nvim", "contributing"),
    ft = "python",
    opt = true,
    config = conf.python_dev,
})

lang({
    "bennypowers/nvim-regexplainer",
    opt = true,
    requires = {
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

-- lang({
--     "Vimjas/vim-python-pep8-indent",
--     ft = "python",
-- })

lang({ "dccsillag/magma-nvim", ft = "python", run = ":UpdateRemotePlugins" })

lang({
    "0x100101/lab.nvim",
    opt = true,
    run = "cd js && npm ci",
    requires = { "nvim-lua/plenary.nvim" },
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
    run = "bash ./install.sh",
    module = { "sniprun" },
    cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose", "SnipLive" },
    config = function() end,
})
