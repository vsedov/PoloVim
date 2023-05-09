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
lang({ "rcarriga/neotest-plenary", commit = "d49bfd9", dependencies = { "nvim-lua/plenary.nvim" } })

lang({
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    config = conf.overseer,
})

lang({
    "stevearc/resession.nvim",
    event = "VeryLazy",
    config = function()
        local resession = require("resession")
        resession.setup({
            autosave = {
                enabled = true,
                interval = 60,
                notify = true,
            },
            extensions = {
                overseer = {},
            },
        })
        vim.keymap.set("n", "<leader>Ss", resession.save)
        vim.keymap.set("n", "<leader>Sl", resession.load)
        vim.keymap.set("n", "<leader>Sd", resession.delete)

        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                resession.save("last")
            end,
        })
    end,
})

lang({
    "rcarriga/neotest-vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    dependencies = { "vim-test/vim-test" },
})

lang({
    "CRAG666/code_runner.nvim",
    lazy = true,
    cmd = {
        "RunCode",
        "RunFile",
        "RunProject",
        "RunClose",
        "CRFiletype",
        "CRProjects",
    },
    config = conf.code_runner,
})

lang({
    "andythigpen/nvim-coverage",
    cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
    lazy = true,
    config = conf.coverage,
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

lang({ "dccsillag/magma-nvim", ft = "python", build = ":UpdateRemotePlugins" })

lang({
    "michaelb/sniprun",
    lazy = true,
    build = "bash ./install.sh",
    cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose", "SnipLive" },
    config = true,
})
