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
lang({
    "JoosepAlviste/nvim-ts-context-commentstring",
    opt = true,
})

lang({
    "TornaxO7/tree-setter",
    ft = { "c", "cpp" },
    config = function()
        require("nvim-treesitter.configs").setup({
            tree_setter = {
                enable = true,
            },
        })
    end,
})

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
    keys = {
        { "v", "<leader>re" },
        { "v", "<leader>rf" },
        { "v", "<leader>rv" },
        { "v", "<leader>ri" },
        { "n", "<leader>rb" },
        { "n", "<leader>rbf" },
        { "n", "<leader>ri" },
        { "v", "<leader>rr" },
        { "v", "<leader>rv" },
        { "n", "<leader>rc" },
        { "n", "d?v" },
        { "n", "d?V" },
    },
    config = conf.refactor,
})
-- OPTIM(vsedov) (01:01:25 - 14/08/22): If this gets used more, i will load this
-- on startup, using lazy.lua
lang({
    "andrewferrier/debugprint.nvim",
    config = conf.debugprint,
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
    cmd = "DeleteDebugPrints",
})

local test = 10

lang({
    "nvim-treesitter/nvim-treesitter-refactor",
    after = "nvim-treesitter-textobjects", -- manual loading
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    opt = true,
})

lang({ "yardnsm/vim-import-cost", cmd = "ImportCost", opt = true })

lang({ "nanotee/luv-vimdocs", opt = true })

-- builtin lua functions
lang({ "milisims/nvim-luaref", opt = true })
lang({ "is0n/jaq-nvim", cmd = "Jaq", opt = true, config = conf.jaq })
lang({
    "pianocomposer321/yabs.nvim",
    ft = "python",
    cmd = { "YabsTask", "YabsDefaultTask" },
    requires = { "nvim-lua/plenary.nvim" },
    config = conf.yabs,
})

lang({ "mtdl9/vim-log-highlighting", ft = { "text", "log" } })

lang({ "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle" }, opt = true, config = conf.trouble })

lang({
    "B4mbus/todo-comments.nvim",
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
lang({
    "ofirgall/goto-breakpoints.nvim",
    after = "nvim-dap",
    config = function()
        local map = vim.keymap.set
        map("n", "]d", require("goto-breakpoints").next, {})
        map("n", "[d", require("goto-breakpoints").prev, {})
    end,
})

lang({ "max397574/nvim-treehopper", module = "tsht" })

lang({ "lewis6991/nvim-treesitter-context", event = "InsertEnter", config = conf.context })

lang({ "ray-x/guihua.lua", run = "cd lua/fzy && make", opt = true })

lang({ "mfussenegger/nvim-jdtls", ft = "java", opt = true })

lang({
    "rcarriga/neotest",
    opt = true,
    keys = {
        "<leader>ur",
        "<leader>uc",
        "<leader>us",
        "<leader>uo",
        "<leader>uS",
        "<leader>uh",
    },
    wants = "overseer.nvim",
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
    config = conf.neotest,
})
lang({
    "stevearc/overseer.nvim",
    config = conf.overseer,
    module = "overseer",
    cmd = {
        "OverseerOpen",
        "OverseerClose",
        "OverseerToggle",
        "OverseerSaveBundle",
        "OverseerLoadBundle",
        "OverseerDeleteBundle",
        "OverseerRunCmd",
        "OverseerRun",
        "OverseerBuild",
        "OverseerQuickAction",
        "OverseerTaskAction",
    },
})
lang({
    "andythigpen/nvim-coverage",
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
lang({
    lambda.use_local("py.nvim", "contributing"),
    ft = "python",
    opt = true,
    config = conf.python_dev,
})

lang({
    "rmagatti/goto-preview",
    keys = { "gi", "gt", "gR", "gC" },
    requires = "telescope.nvim",
    after = "nvim-lspconfig",
    config = conf.goto_preview,
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

-- ig finds the diagnostic under or after the cursor (including any diagnostic the cursor is sitting on)
-- ]g finds the diagnostic after the cursor (excluding any diagnostic the cursor is sitting on)
-- [g finds the diagnostic before the cursor (excluding any diagnostic the cursor is sitting on)
lang({
    "andrewferrier/textobj-diagnostic.nvim",
    ft = { "python", "lua" },
    config = function()
        require("textobj-diagnostic").setup()
    end,
})

lang({
    "sheerun/vim-polyglot",
    opt = true,
    setup = function()
        vim.g.polyglot_disabled = { "latex", "markdown" }
    end,
    config = function()
        -- JSON: do not remove double quotes in view
        vim.g.vim_json_syntax_conceal = 0
        -- Python
        vim.g.python_highlight_space_errors = 0
        vim.g.python_highlight_all = 1
        vim.g.latex_to_unicode_auto = 1
        vim.g.julia_blocks = 1
        vim.g.julia_spellcheck_docstrings = 1
        vim.g.julia_spellcheck_strings = 1
        vim.g.julia_indent_align_import = 1
    end,
})
lang({
    "Vimjas/vim-python-pep8-indent",
    ft = "pyton",
})

lang({
    "direnv/direnv.vim",
    opt = true,
    event = "BufEnter",
})

lang({ "dccsillag/magma-nvim", ft = "python", run = ":UpdateRemotePlugins" })
