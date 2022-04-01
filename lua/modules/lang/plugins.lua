local lang = {}
local conf = require("modules.lang.config")
-- local path = plugin_folder() no local plugins

lang["nathom/filetype.nvim"] = {
    -- event = {'BufEnter'},
    setup = function()
        vim.g.did_load_filetypes = 1
    end,
    config = function()
        require("filetype").setup({
            overrides = {
                literal = {
                    ["kitty.conf"] = "kitty",
                    [".gitignore"] = "conf",
                },
                complex = {
                    [".clang*"] = "yaml",
                    [".*%.env.*"] = "sh",
                    [".*ignore"] = "conf",
                },
                extensions = {
                    tf = "terraform",
                    tfvars = "terraform",
                    hcl = "hcl",
                    tfstate = "json",
                    eslintrc = "json",
                    prettierrc = "json",
                    mdx = "markdown",
                },
            },
        })
    end,
}

lang["nvim-treesitter/nvim-treesitter"] = {
    opt = true,
    run = ":TSUpdate",
    config = conf.nvim_treesitter,
}

lang["nvim-treesitter/nvim-treesitter-textobjects"] = {
    after = "nvim-treesitter",
    config = conf.treesitter_obj,
    opt = true,
}
-- lang["eddiebergman/nvim-treesitter-pyfold"] = {config = conf.pyfold}
lang["RRethy/nvim-treesitter-textsubjects"] = {
    ft = { "lua", "rust", "go", "python", "javascript" },
    opt = true,
    config = conf.tsubject,
}

lang["RRethy/nvim-treesitter-endwise"] = {
    ft = { "lua", "ruby", "vim" },
    event = "InsertEnter",
    opt = true,
    config = conf.endwise,
}

lang["danymat/neogen"] = {
    opt = true,
    requires = { "nvim-treesitter/nvim-treesitter", "rcarriga/nvim-notify" },
    config = function()
        require("neogen").setup({
            snippet_engine = "luasnip",
            languages = {
                lua = {
                    template = { annotation_convention = "emmylua" },
                },
                python = {
                    template = { annotation_convention = "numpydoc" },
                },
                c = {
                    template = { annotation_convention = "doxygen" },
                },
            },
        })
    end,
}

-- Inline functions dont seem to work .
lang["ThePrimeagen/refactoring.nvim"] = {
    opt = true,
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = conf.refactor,
}

-- Yay gotopreview lazy loaded
lang["rmagatti/goto-preview"] = {
    cmd = { "GotoPrev", "GotoImp", "GotoTel" },
    requires = "telescope.nvim",
    config = conf.goto_preview,
}

lang["nvim-treesitter/nvim-treesitter-refactor"] = {
    after = "nvim-treesitter-textobjects", -- manual loading
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    opt = true,
}

lang["yardnsm/vim-import-cost"] = { cmd = "ImportCost", opt = true }

-- lang['scalameta/nvim-metals'] = {requires = {"nvim-lua/plenary.nvim"}}
lang["lifepillar/pgsql.vim"] = { ft = { "sql", "pgsql" } }

lang["nanotee/sqls.nvim"] = { ft = { "sql", "pgsql" }, setup = conf.sqls, opt = true }

lang["ray-x/go.nvim"] = { ft = { "go", "gomod" }, config = conf.go }

lang["ray-x/guihua.lua"] = {
    run = "cd lua/fzy && make",
    opt = true,
}

-- lang["gcmt/wildfire.vim"] = {
--   setup = function()
--     vim.cmd([[nmap <leader>s <Plug>(wildfire-quick-select)]])
--   end,
--   fn = {'<Plug>(wildfire-fuel)', '<Plug>(wildfire-water)', '<Plug>(wildfire-quick-select)'}
-- }

lang["romgrk/nvim-treesitter-context"] = {
    event = "InsertEnter",
    config = conf.context,
}

lang["max397574/nvim-treehopper"] = {
    module = "tsht",
    config = conf.treehopper,
}

lang["nvim-treesitter/playground"] = {
    -- after = "nvim-treesitter",
    opt = true,
    cmd = "TSPlaygroundToggle",
    config = conf.playground,
}

-- great plugin but not been maintained
-- lang["ElPiloto/sidekick.nvim"] = {opt = true, fn = {'SideKickNoReload'}, setup = conf.sidekick}
-- lang["stevearc/aerial.nvim"] = {
--     opt = true,
--     cmd = { "AerialToggle" },
--     config = conf.aerial,
-- }

lang["simrat39/symbols-outline.nvim"] = {
    opt = true,
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    setup = conf.outline,
}

lang["mfussenegger/nvim-jdtls"] = {
    ft = "java",
    opt = true,
}

lang["lervag/vimtex"] = {
    ft = "tex",
    opt = true,
    setup = function()
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_latexmk = {
            build_dir = "build",
            callback = 1,
            continuous = 1,
            executable = "latexmk",
            hooks = {},
            options = {
                "-verbose",
                "-file-line-error",
                "-synctex=1",
                "-interaction=nonstopmode",
            },
        }
    end,
}

lang["andythigpen/nvim-coverage"] = {
    ft = { "python" },
    cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
    opt = true,
    config = function()
        require("coverage").setup()
    end,
}

lang["mfussenegger/nvim-dap"] = {
    opt = true,
    requires = {
        { "theHamsta/nvim-dap-virtual-text", cmd = "Luadev", opt = true },
        { "mfussenegger/nvim-dap-python", ft = "python" },
        { "rcarriga/nvim-dap-ui", opt = true },
    },

    run = ":UpdateRemotePlugins",

    config = conf.dap,
} -- cmd = "Luadev",

-- better python indent

lang["nvim-telescope/telescope-dap.nvim"] = {
    opt = true,
    requires = { "telescope.nvim", "nvim-dap" },
    config = conf.dap,
}

lang["m-demare/hlargs.nvim"] = {
    ft = { "python", "c", "cpp", "java", "lua", "rust", "go" },
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("hlargs").setup({
            performance = {
                max_iterations = 1000,
                max_concurrent_partial_parses = 90,
            },
        })
    end,
}

lang["JoosepAlviste/nvim-ts-context-commentstring"] = { opt = true }

lang["jbyuki/one-small-step-for-vimkind"] = { opt = true, ft = { "lua" } }

lang["bfredl/nvim-luadev"] = { opt = true, ft = "lua", setup = conf.luadev }

lang["rafcamlet/nvim-luapad"] = {
    cmd = { "LuaRun", "Lua", "Luapad" },
    ft = { "lua" },
    config = function()
        require("luapad").setup({
            count_limit = 150000,
            error_indicator = true,
            eval_on_move = true,
            error_highlight = "WarningMsg",
            on_init = function()
                print("Hello from Luapad!")
            end,
            context = {
                the_answer = 42,
                shout = function(str)
                    return (string.upper(str) .. "!")
                end,
            },
        })
    end,
}

lang["mtdl9/vim-log-highlighting"] = { ft = { "text", "log" } }

-- lang["RRethy/vim-illuminate"] = {opt=true, ft = {"go"}}

--
lang["michaelb/sniprun"] = {
    cmd = { "'<,'>SnipRun", "SnipRun" },
    opt = true,
    run = "bash install.sh",
    requires = "rcarriga/nvim-notify",
    config = conf.sniprun,
}

lang["dccsillag/magma-nvim"] = {
    cmd = {
        "PyRepl",
        "MagmaEvaluateOperator",
        "MagmaEvaluateLine",
        "<C-u>MagmaEvaluateVisual",
        "MagmaReevaluateCell",
        "MagmaDelete",
        "MagmaShowOutput",
    },

    ft = "python",
    opt = true,
    runs = "UpdateRemotePlugins",
    requires = "rcarriga/nvim-notify",
    run = ":UpdateRemotePlugins",
    config = conf.magma,
}

lang["Vimjas/vim-python-pep8-indent"] = {
    ft = "python",
}

lang["vim-test/vim-test"] = {
    opt = true,
}

-- lua testign
lang["lewis6991/nvim-test"] = {
    ft = "lua",
    opt = true,
}

lang["rcarriga/vim-ultest"] = {
    requires = { "vim-test/vim-test", opt = true },
    run = ":UpdateRemotePlugins",
    opt = true,
}

-- This might not be needed
lang["mgedmin/coverage-highlight.vim"] = {
    ft = "python",
    opt = true,
    run = ":UpdateRemotePlugins",
}

------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- JqxList and JqxQuery json browsing, format
lang["gennaro-tedesco/nvim-jqx"] = {
    ft = "json",
    cmd = { "JqxList", "JqxQuery" },
    opt = true,
}

lang["windwp/nvim-ts-autotag"] = {
    opt = true,
    -- after = "nvim-treesitter",
    -- config = function() require"nvim-treesitter.configs".setup {autotag = {enable = true}} end
}

lang["Tastyep/structlog.nvim"] = {
    opt = true,
    config = function()
        require("utils.log")
    end,
}

lang["nanotee/luv-vimdocs"] = {
    opt = true,
}
-- builtin lua functions
lang["milisims/nvim-luaref"] = {
    opt = true,
}

lang["p00f/nvim-ts-rainbow"] = {
    opt = true,
    -- after = "nvim-treesitter",
    -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    cmd = "Rainbow",
    config = function()
        require("nvim-treesitter.configs").setup({ rainbow = { enable = true, extended_mode = true } })
    end,
}

lang["onsails/diaglist.nvim"] = {
    event = { "BufEnter", "QuickFixCmdPre", "CmdlineEnter" },
    requires = {
        "neovim/nvim-lspconfig",
    },
    module = "diaglist",
    setup = function()
        local map, opts = vim.api.nvim_set_keymap, {}
        map("n", "<Leader>xX", '<cmd>lua require "diaglist".open_all_diagnostics()<cr>', opts)
        map("n", "<Leader>xx", '<cmd>lua require "diaglist".open_buffer_diagnostics()<cr>', opts)
    end,
    opt = true, -- opt = true,
    config = function()
        require("diaglist").init({
            debug = false,
            debounce_ms = 150,
        })
    end,
    after = { "nvim-bqf", "nvim-lspconfig" },
}

lang["folke/trouble.nvim"] = {
    cmd = { "Trouble", "TroubleToggle" },
    opt = true,
    config = function()
        require("trouble").setup({})
    end,
}

lang["folke/todo-comments.nvim"] = {
    cmd = { "TodoTelescope", "TodoTelescope", "TodoTrouble" },
    requires = "trouble.nvim",
    config = conf.todo_comments,
}

lang["vim-scripts/CRefVim"] = {
    keys = { "<leader>c" },
    ft = "c",
}

lang["is0n/jaq-nvim"] = {
    cmd = "Jaq",
    after = "filetype.nvim",
    opt = true,
    config = conf.jaq,
}
lang["pianocomposer321/yabs.nvim"] = {
    opt = true,
    requires = { "nvim-lua/plenary.nvim" },
    config = conf.yabs,
}

lang["jose-elias-alvarez/null-ls.nvim"] = {
    opt = true,
    config = require("modules.lang.null-ls").config,
}

return lang
