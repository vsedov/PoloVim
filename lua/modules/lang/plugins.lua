local lang = {}
local conf = require("modules.lang.config")
local package = require("core.pack").package
package({
    "nathom/filetype.nvim",
    -- event = {'BufEnter'},
    setup = function()
        vim.g.did_load_filetypes = 1
    end,
    config = conf.filetype,
})

package({ "nvim-treesitter/nvim-treesitter", opt = true, run = ":TSUpdate", config = conf.nvim_treesitter })

package({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    config = conf.treesitter_obj,
    opt = true,
})
-- package{"eddiebergman/nvim-treesitter-pyfold",config = conf.pyfold}
package({
    "RRethy/nvim-treesitter-textsubjects",
    ft = { "lua", "rust", "go", "python", "javascript" },
    opt = true,
    config = conf.tsubject,
})

package({
    "RRethy/nvim-treesitter-endwise",
    ft = { "lua", "ruby", "vim" },
    event = "InsertEnter",
    opt = true,
    config = conf.endwise,
})
-- Inline functions dont seem to work .
package({
    "ThePrimeagen/refactoring.nvim",
    opt = true,
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = conf.refactor,
})

package({
    "nvim-treesitter/nvim-treesitter-refactor",
    after = "nvim-treesitter-textobjects", -- manual loading
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    opt = true,
})

-- Yay gotopreview lazy loaded
package({
    "rmagatti/goto-preview",
    cmd = { "GotoPrev", "GotoImp", "GotoTel" },
    requires = "telescope.nvim",
    config = conf.goto_preview,
})

package({ "JoosepAlviste/nvim-ts-context-commentstring", opt = true })

package({ "yardnsm/vim-import-cost", cmd = "ImportCost", opt = true })

package({ "windwp/nvim-ts-autotag", opt = true })

package({
    "Tastyep/structlog.nvim",
    opt = true,
    config = function()
        require("utils.log")
    end,
})

package({ "nanotee/luv-vimdocs", opt = true })

-- builtin lua functions
package({ "milisims/nvim-luaref", opt = true })
package({ "is0n/jaq-nvim", cmd = "Jaq", opt = true, config = conf.jaq })
package({
    "pianocomposer321/yabs.nvim",
    ft = "python",
    requires = { "nvim-lua/plenary.nvim" },
    config = conf.yabs,
})

package({ "mtdl9/vim-log-highlighting", ft = { "text", "log" } })

package({ "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle" }, opt = true, config = conf.trouble })

package({
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoTelescope", "TodoTrouble" },
    requires = "trouble.nvim",
    config = conf.todo_comments,
})

-- not the same as folkes version
package({ "bfredl/nvim-luadev", opt = true, ft = "lua", setup = conf.luadev })

package({
    "rafcamlet/nvim-luapad",
    cmd = { "LuaRun", "Lua", "Luapad" },
    ft = { "lua" },
    config = conf.luapad,
})

package({
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

package({ "max397574/nvim-treehopper", module = "tsht" })

package({ "lewis6991/nvim-treesitter-context", event = "InsertEnter", config = conf.context })

package({ "ray-x/guihua.lua", run = "cd lua/fzy && make", opt = true })

package({ "mfussenegger/nvim-jdtls", ft = "java", opt = true })

package({
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
package({
    "andythigpen/nvim-coverage",
    ft = { "python" },
    cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
    opt = true,
    config = conf.coverage,
})
package({ "mgedmin/coverage-highlight.vim", ft = "python", opt = true, run = ":UpdateRemotePlugins" })

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
package({ "~/GitHub/active_development/py.nvim", ft = "python", opt = true, config = conf.python_dev })
-- return lang
