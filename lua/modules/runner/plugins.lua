local runner = require("core.pack").package
local conf = require("modules.runner.config")

runner({
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    config = conf.overseer,
})

runner({ -- This plugin
    "Zeioth/compiler.nvim",
    event = "VeryLazy",
    dependencies = { "stevearc/overseer.nvim" },
    config = true,
})

runner({
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

--  ──────────────────────────────────────────────────────────────────────

runner({ "dccsillag/magma-nvim", ft = "python", build = ":UpdateRemotePlugins" })

runner({
    "michaelb/sniprun",
    lazy = true,
    build = "bash ./install.sh",
    cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose", "SnipLive" },
    config = true,
})
--  ──────────────────────────────────────────────────────────────────────

runner({
    "rcarriga/neotest",
    lazy = true,
    cmd = { "Neotest" },
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
        { "rcarriga/neotest-python" },
        { "rcarriga/neotest-plenary" },
        { "stevearc/overseer.nvim" },
    },
    config = conf.neotest,
})
runner({ "rcarriga/neotest-plenary", dependencies = { "nvim-lua/plenary.nvim" } })

runner({
    "rcarriga/neotest-vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    dependencies = { "vim-test/vim-test" },
})

runner({
    "andythigpen/nvim-coverage",
    cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
    lazy = true,
    config = true,
})
runner({
    "pianocomposer321/officer.nvim",
    cmd = {
        "Make",
        "Run",
    },
    dependencies = "stevearc/overseer.nvim",
    config = true,
})

runner({
    "krady21/compiler-explorer.nvim",
    cmd = {
        "CECompile",
        "CECompileLive",
        "CEFormat",
        "CEAddLibrary",
        "CELoadExample",
        "CEOpenWebsite",
        "CEDeleteCache",
        "CEShowTooltip",
        "CEGotoLabel",
    },
    opts = {},
})
runner({
    "LunarVim/bigfile.nvim",
    event = "VeryLazy",
    config = true,
})
runner({
    "itsfrank/overseer-quick-tasks",
    lazy = true,
    dependencies = {
        "ThePrimeagen/harpoon",
        "stevearc/overseer.nvim",
    },
})
