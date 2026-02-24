--  TODO: (vsedov) (08:58:48 - 08/11/22): Make all of this optional, because im not sure which is
--  causing the error here, and its quite important that i figure this one out .
local conf = require("modules.treesitter.config")
local ts = require("core.pack").package
ts({
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
      require('nvim-treesitter').setup {
        -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
        install_dir = vim.fn.stdpath('data') .. '/site',
        ensure_installed = {
          "python", "lua", "vim", "vimdoc",
          "javascript", "typescript", "json",
          "c", "cpp", "rust",
          "yaml", "toml", "html", "css", "bash",
          "go", "java", "dart",
        },
      }
    require("nvim-treesitter.config").setup({
        indent = { enable = true, disable = { "python" } },
        textobjects = {
            -- syntax-aware textobjects
            enable = enable,
            disable = { "elm" },
            lsp_interop = {
                enable = enable,
                border = "single",
                peek_definition_code = {
                    ["gl"] = "@function.outer",
                    ["gk"] = "@class.outer",
                },
            },
            move = {
                enable = enable,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["gnf"] = "@function.outer",
                    ["gnif"] = "@function.inner",
                    ["gnp"] = "@parameter.inner",
                    ["gnc"] = "@call.outer",
                    ["gnic"] = "@call.inner",
                },
                goto_next_end = {
                    ["gnF"] = "@function.outer",
                    ["gniF"] = "@function.inner",
                    ["gnP"] = "@parameter.inner",
                    ["gnC"] = "@call.outer",
                    ["gniC"] = "@call.inner",
                },
                goto_previous_start = {
                    ["gpf"] = "@function.outer",
                    ["gpif"] = "@function.inner",
                    ["gpp"] = "@parameter.inner",
                    ["gpc"] = "@call.outer",
                    ["gpic"] = "@call.inner",
                },
                goto_previous_end = {
                    ["gpF"] = "@function.outer",
                    ["gpiF"] = "@function.inner",
                    ["gpP"] = "@parameter.inner",
                    ["gpC"] = "@call.outer",
                    ["gpiC"] = "@call.inner",
                },
            },
            select = {
                enable = true,
                include_surrounding_whitespace = true,
                keymaps = {
                    ["af"] = { query = "@function.outer", desc = "ts: all function" },
                    ["if"] = { query = "@function.inner", desc = "ts: inner function" },
                    ["ac"] = { query = "@class.outer", desc = "ts: all class" },
                    ["ic"] = { query = "@class.inner", desc = "ts: inner class" },
                    ["aC"] = { query = "@conditional.outer", desc = "ts: all conditional" },
                    ["iC"] = { query = "@conditional.inner", desc = "ts: inner conditional" },
                    -- ['ax'] = '@comment.outer',
                },
            },
            swap = {
                enable = enable,
                swap_next = { ["<leader>a"] = "@parameter.inner" },
                swap_previous = { ["<leader>A"] = "@parameter.inner" },
            },
        },
    })

    -- print("loading ts")
    vim.cmd([[syntax on]])


  end
})

ts({
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.treesitter_obj,
    lazy = true,
})

ts({
    "RRethy/nvim-treesitter-textsubjects",
    ft = { "lua", "rust", "go", "python", "javascript" },
    lazy = true,
})

ts({
    "RRethy/nvim-treesitter-endwise",
    ft = { "lua", "ruby", "vim" },
    lazy = true,
})

ts({
    "nvim-treesitter/nvim-treesitter-refactor",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
    lazy = true,
})

ts({
    "m-demare/hlargs.nvim",
    ft = {
        "c",
        "cpp",
        "go",
        "java",
        "javascript",
        "jsx",
        "lua",
        "php",
        "python",
        "r",
        "ruby",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "zig",
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
})

ts({
    "andrewferrier/textobj-diagnostic.nvim",
    ft = { "python", "lua" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
})

ts({
    "andymass/vim-matchup",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = true,
    config = conf.matchup,
    init = conf.matchup_setup,
})

ts({
    "Yggdroot/hiPairs",
    lazy = not lambda.config.treesitter.hipairs,
})


ts({
    -- It uses hydra
    "Dkendal/nvim-treeclimber",
    lazy = true,
    dependencies = { "rktjmp/lush.nvim", "nvim-treesitter/nvim-treesitter" },
    -- config = conf.climber,
})

ts({
    "wellle/targets.vim",
    lazy = true,
    event = "VeryLazy",
    init = function()
        vim.g.targets_gracious = 1
    end,
    config = function()
        vim.cmd([[
autocmd User targets#mappings#user call targets#mappings#extend({
    \ 's': { 'separator': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
    \                      {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
    \                      {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}] },
    \ '@': {
    \     'separator': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
    \                   {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
    \                   {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}],
    \     'pair':      [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}],
    \     'quote':     [{'d':"'"}, {'d':'"'}, {'d':'`'}],
    \     'tag':       [{}],
    \     },
    \ })
      ]])
    end,
})

ts({
    "chrisgrieser/nvim-various-textobjs",
    lazy = true,
    ft = { "python", "lua" },
    config = function()
        require("various-textobjs").setup()
    end,
})
