local conf = require("modules.lang.config")
local lang = require("core.pack").package

lang({ "nvim-treesitter/nvim-treesitter", opt = true, run = ":TSUpdate", config = conf.nvim_treesitter })

lang({
    "p00f/nvim-ts-rainbow",
    after = "nvim-treesitter",
    config = conf.rainbow,
    opt = true,
})
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

lang({ "mtdl9/vim-log-highlighting", ft = { "text", "log" } })

lang({ "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle" }, opt = true, config = conf.trouble })

lang({
    "ram02z/dev-comments.nvim",
    requires = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim", -- optional
    },
    event = { "BufEnter" },
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

lang({
    "max397574/nvim-treehopper",
    keys = {
        { "o", "u" },
        { "v", "u" },
    },
    config = function()
        lambda.augroup("TreehopperMaps", {
            {
                event = "FileType",
                command = function(args)
                    -- FIXME: this issue should be handled inside the plugin rather than manually
                    local langs = require("nvim-treesitter.parsers").available_parsers()
                    if vim.tbl_contains(langs, vim.bo[args.buf].filetype) then
                        vim.keymap.set("o", "u", ":<c-u>lua require('tsht').nodes()<cr>", { buffer = args.buf })
                        vim.keymap.set("v", "u", ":lua require('tsht').nodes()<cr>", { buffer = args.buf })
                    end
                end,
            },
        })
    end,
})

lang({ "nvim-treesitter/nvim-treesitter-context", event = "WinScrolled", config = conf.context })

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
-- TODO(vsedov) (10:00:41 - 23/08/22): Lean how to actually use this cause
-- I kinda do not really know wtf this thing really does is this another jaq or something ?
lang({
    "stevearc/overseer.nvim",
    config = conf.overseer,
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
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
})

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

        vim.keymap.set("n", "<localleader>rs", ":Lab code stop<cr>", {})
        vim.keymap.set("n", "<localleader>rr", ":Lab code run<cr>", {})
        vim.keymap.set("n", "<localleader>rp", ":Lab code panel<cr>", {})
    end,
})

lang({
    "ranelpadon/python-copy-reference.vim",
    opt = true,
    ft = "python",
    cmd = {
        "PythonCopyReferenceDotted",
        "PythonCopyReferencePytest",
    },
})

lang({
    "jghauser/papis.nvim",
    after = { "telescope.nvim", "nvim-cmp" },
    ft = { "latex", "tex", "norg" },
    requires = {
        "kkharji/sqlite.lua",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    rocks = { "lyaml" },
    config = function()
        require("papis").setup({
            papis_python = {
                dir = "/home/viv/Documents/papers/",
                info_name = "info.yaml", -- (when setting papis options `-` is replaced with `_`
                notes_name = [[notes.norg]],
            },
            enable_keymaps = false,
        })
    end,
})
