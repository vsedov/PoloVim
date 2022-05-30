local lang = {}
local conf = require("modules.lang.config")

lang["nathom/filetype.nvim"] = {
    -- event = {'BufEnter'},
    setup = function()
        vim.g.did_load_filetypes = 1
    end,
    config = conf.filetype,
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
-- Inline functions dont seem to work .
lang["ThePrimeagen/refactoring.nvim"] = {
    opt = true,
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = conf.refactor,
}

lang["nvim-treesitter/nvim-treesitter-refactor"] = {
    after = "nvim-treesitter-textobjects", -- manual loading
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    opt = true,
}

-- Yay gotopreview lazy loaded
lang["rmagatti/goto-preview"] = {
    cmd = { "GotoPrev", "GotoImp", "GotoTel" },
    requires = "telescope.nvim",
    config = conf.goto_preview,
}

lang["JoosepAlviste/nvim-ts-context-commentstring"] = { opt = true }

lang["yardnsm/vim-import-cost"] = { cmd = "ImportCost", opt = true }

lang["windwp/nvim-ts-autotag"] = {
    opt = true,
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
lang["is0n/jaq-nvim"] = {
    cmd = "Jaq",
    opt = true,
    config = conf.jaq,
}
lang["pianocomposer321/yabs.nvim"] = {
    ft = "python",
    requires = { "nvim-lua/plenary.nvim" },
    config = conf.yabs,
}

lang["mtdl9/vim-log-highlighting"] = { ft = { "text", "log" } }

lang["folke/trouble.nvim"] = {
    cmd = { "Trouble", "TroubleToggle" },
    opt = true,
    config = conf.trouble,
}

lang["folke/todo-comments.nvim"] = {
    cmd = { "TodoTelescope", "TodoTelescope", "TodoTrouble" },
    requires = "trouble.nvim",
    config = conf.todo_comments,
}

-- not the same as folkes version
lang["bfredl/nvim-luadev"] = { opt = true, ft = "lua", setup = conf.luadev }

lang["rafcamlet/nvim-luapad"] = {
    cmd = { "LuaRun", "Lua", "Luapad" },
    ft = { "lua" },
    config = conf.luapad,
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

lang["max397574/nvim-treehopper"] = {
    module = "tsht",
}

lang["lewis6991/nvim-treesitter-context"] = {
    event = "InsertEnter",
    config = conf.context,
}

lang["ray-x/guihua.lua"] = {
    run = "cd lua/fzy && make",
    opt = true,
}

lang["mfussenegger/nvim-jdtls"] = {
    ft = "java",
    opt = true,
}

lang["jose-elias-alvarez/null-ls.nvim"] = {
    opt = true,
    config = require("modules.lang.null-ls").config,
    requires = "nvim-lspconfig",
}

lang["dense-analysis/ale"] = {
    config = function() end,
}

lang["jose-elias-alvarez/null-ls.nvim"] = {
    opt = true,
    config = require("modules.lang.null-ls").config,
    requires = "nvim-lspconfig",
}

return lang
