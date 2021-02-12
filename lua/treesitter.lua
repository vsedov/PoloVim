local api = vim.api
local configs = require 'nvim-treesitter.configs'
local parsers = require 'nvim-treesitter.parsers'

require 'nvim-treesitter.configs'.setup {
    ensure_installed = "all",       -- one of "all", "language", or a list of languages

    -- nvim-treesitter native modules
    highlight = {
        enable = true,   
        disable = { "c", "latex","tex" },           -- false will disable the whole extension
        -- disable = { }            -- list of language that will be disabled
        -- custom_captures = { }    -- custom highlight groups for captures
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection      = "gi",
            node_incremental    = "n",
            node_decremental    = "N",
            scope_incremental   = "b",
        },
    },

    -- external modules
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                -- capture groups defined in textobjects.scm
                ["fo"] = "@function.outer",
                ["fi"] = "@function.inner",
                ["co"] = "@class.outer",
                ["ci"] = "@class.inner",
            },
        },
        lsp_interop =               { enable = false },
        move =                      { enable = false },
        swap =                      { enable = false },
    },
    refactor = {
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "gs",

            },


        },
        highlight_current_scope =   { enable = false },
        highlight_definitions =     { enable = false },     -- provided by coc.nvim
        navigation =                { enable = false },
    },

        playground = {
        enable = true,
        disable = {},
        updatetime = 1, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false -- Whether the query persists across vim sessions
  },
  
}


-- turn on treesitter folding for supported languages
-- TODO: submit a patch that enables folding as a nvim-treesitter module
local ft_str = ""
local autocmd_fold_str = ""

for _, ft in pairs(parsers.available_parsers()) do
    if (ft == "c_sharp") then
        ft_str = ft_str..'cs'..','
    else
        ft_str = ft_str..ft..','
    end
end

autocmd_fold_str = 'autocmd Filetype '..ft_str..' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()'
api.nvim_command(autocmd_fold_str)


