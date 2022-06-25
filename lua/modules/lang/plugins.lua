local conf = require("modules.lang.config")
local lang = require("core.pack").package
lang({
    "nathom/filetype.nvim",
    -- event = {'BufEnter'},
    setup = function()
        vim.g.did_load_filetypes = 1
    end,
    config = conf.filetype,
})

lang({ "nvim-treesitter/nvim-treesitter", opt = true, run = ":TSUpdate", config = conf.nvim_treesitter })

lang({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    config = conf.treesitter_obj,
    opt = true,
})
-- lang{"eddiebergman/nvim-treesitter-pyfold",config = conf.pyfold}
lang({
    "RRethy/nvim-treesitter-textsubjects",
    ft = { "lua", "rust", "go", "python", "javascript" },
    opt = true,
    config = conf.tsubject,
})

lang({
    "RRethy/nvim-treesitter-endwise",
    ft = { "lua", "ruby", "vim" },
    event = "InsertEnter",
    opt = true,
    config = conf.endwise,
})
-- Inline functions dont seem to work .
lang({
    "ThePrimeagen/refactoring.nvim",
    opt = true,
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = conf.refactor,
})

lang({
    "nvim-treesitter/nvim-treesitter-refactor",
    after = "nvim-treesitter-textobjects", -- manual loading
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    opt = true,
})

lang({ "JoosepAlviste/nvim-ts-context-commentstring", opt = true })

lang({ "yardnsm/vim-import-cost", cmd = "ImportCost", opt = true })

lang({ "windwp/nvim-ts-autotag", opt = true })

lang({ "nanotee/luv-vimdocs", opt = true })

-- builtin lua functions
lang({ "milisims/nvim-luaref", opt = true })
lang({ "is0n/jaq-nvim", cmd = "Jaq", opt = true, config = conf.jaq })
lang({
    "pianocomposer321/yabs.nvim",
    ft = "python",
    requires = { "nvim-lua/plenary.nvim" },
    config = conf.yabs,
})

lang({ "mtdl9/vim-log-highlighting", ft = { "text", "log" } })

lang({ "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle" }, opt = true, config = conf.trouble })

lang({
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoTelescope", "TodoTrouble" },
    requires = "trouble.nvim",
    config = conf.todo_comments,
})

-- not the same as folkes version
lang({ "bfredl/nvim-luadev", opt = true, ft = "lua", setup = conf.luadev })

lang({
    "rafcamlet/nvim-luapad",
    cmd = { "LuaRun", "Lua", "Luapad" },
    ft = { "lua" },
    config = conf.luapad,
})

lang({
    "mfussenegger/nvim-dap",
    module = "dap",
    setup = conf.dap_setup,
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
    },
})

lang({ "max397574/nvim-treehopper", module = "tsht" })

lang({ "lewis6991/nvim-treesitter-context", event = "InsertEnter", config = conf.context })

lang({ "ray-x/guihua.lua", run = "cd lua/fzy && make", opt = true })

lang({ "mfussenegger/nvim-jdtls", ft = "java", opt = true })

lang({
    "rcarriga/neotest",
    opt = true,
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
        { "rcarriga/neotest-python", opt = true },
        { "rcarriga/neotest-plenary", opt = true },
        {
            "rcarriga/neotest-vim-test",
            cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
            opt = true,
            requires = { "vim-test/vim-test", opt = true, after = "neotest" },
        },
    },
    setup = conf.neotest_setup,
    config = conf.neotest,
})
lang({
    "andythigpen/nvim-coverage",
    ft = { "python" },
    cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
    opt = true,
    config = conf.coverage,
})
lang({ "mgedmin/coverage-highlight.vim", ft = "python", opt = true, run = ":UpdateRemotePlugins" })

-- -- IPython Mappings
-- M.map("n", "p", "<cmd>lua require('py.ipython').toggleIPython()<CR>")
-- M.map("n", "c", "<cmd>lua require('py.ipython').sendObjectsToIPython()<CR>")
-- M.map("v", "c", '"zy:lua require("py.ipython").sendHighlightsToIPython()<CR>')
-- M.map("v", "s", '"zy:lua require("py.ipython").sendIPythonToBuffer()<CR>')

-- -- Pytest Mappings
-- M.map("n", "t", "<cmd>lua require('py.pytest').launchPytest()<CR>")
-- M.map("n", "r", "<cmd>lua require('py.pytest').showPytestResult()<CR>")

-- -- Poetry Mappings
-- M.map("n", "a", "<cmd>lua require('py.poetry').inputDependency()<CR>")
-- M.map("n", "d", "<cmd>lua require('py.poetry').showPackage()<CR>")
lang({ "~/GitHub/active_development/py.nvim", ft = "python", opt = true, config = conf.python_dev })

lang({
    "rmagatti/goto-preview",
    keys = { "gi", "gt", "gr", "gC" },
    requires = "telescope.nvim",
    after = "nvim-lspconfig",
    config = conf.goto_preview,
})

-- Live coding
lang({
    "metakirby5/codi.vim",
    cmd = { "CodiScratch", "CodiLiveBuf", "Codi", "Codi!", "CodiNew" },
    setup = conf.codi_setup,
})

lang({
    "michaelb/sniprun",
    run = "bash ./install.sh",
    cmd = {
        "SnipRun",
        "'<,'>SnipRun",
        "SnipLive",
        "SnipClose",
        "SnipReset",
        "SnipTerminate",
        "SnipReplMemoryClean",
        "SnipLive",
    },
    config = conf.sniprun,
})
