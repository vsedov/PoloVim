local conf = require("modules.treesitter.config")
local ts = require("core.pack").package

-- Core
ts({
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = conf.treesitter_init,
    config = conf.nvim_treesitter,
})

-- Core
ts({
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.treesitter_obj,
})

ts({
    "chrisgrieser/nvim-various-textobjs",
    lazy = true,
    event = "VeryLazy",
    keys = {
        {
            "?",
            function()
                require("various-textobjs").diagnostic()
            end,
            mode = { "o", "x" },
            desc = "diagnostic textobj",
        },
        {
            "aS",
            function()
                require("various-textobjs").subword(false)
            end,
            mode = { "o", "x" },
            desc = "outer subword",
        },
        {
            "iS",
            function()
                require("various-textobjs").subword(true)
            end,
            mode = { "o", "x" },
            desc = "inner subword",
        },
        {
            "ii",
            function()
                require("various-textobjs").indentation(true, true)
            end,
            mode = { "o", "x" },
            desc = "inner indentation",
        },
    },
    opts = {
        useDefaultKeymaps = true,
        disabledKeymaps = {
            "gc",
        },
    },
})

-- Core
ts({
    "RRethy/nvim-treesitter-textsubjects",
    lazy = true,
    ft = { "lua", "rust", "go", "python", "javascript" },
    config = conf.tsubject,
})

-- Core
ts({
    "RRethy/nvim-treesitter-endwise",
    lazy = true,
    ft = { "lua", "ruby", "vim" },
    config = conf.endwise,
})

-- Core
ts({
    "nvim-treesitter/nvim-treesitter-refactor",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
    config = conf.treesitter_ref, -- let the last loaded config treesitter
})

ts({
    "m-demare/hlargs.nvim",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hlargs,
})

ts({
    "andrewferrier/textobj-diagnostic.nvim",
    lazy = true,
    ft = { "python", "lua" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
})

ts({
    "Yggdroot/hiPairs",
    lazy = true,
    cond = lambda.config.treesitter.hipairs,
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hi_pairs,
})

ts({
    "NMAC427/guess-indent.nvim",
    lazy = true,
    cond = lambda.config.treesitter.indent.use_guess_indent,
    event = { "BufAdd", "BufReadPost", "BufNewFile" },
    cmd = "GuessIndent",
    config = conf.guess_indent,
})

ts({
    "ckolkey/ts-node-action",
    lazy = true,
    dependencies = { "nvim-treesitter" },
    keys = {
        {
            "<leader>k",
            function()
                require("ts-node-action").node_action()
            end,
        },
    },
    config = true,
})
ts({
    "romgrk/equal.operator",
    keys = {
        {
            "il",
            mode = { "o", "x" },
            desc = "select inside RHS",
        },
        {
            "ih",
            mode = { "o", "x" },
            desc = "select inside LHS",
        },
        {
            "al",
            mode = { "o", "x" },
            desc = "select all RHS",
        },
        {
            "ah",
            mode = { "o", "x" },
            desc = "select all LHS",
        },
    },
})
ts({
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = true, -- will be loaded via Comment.nvim
    config = function()
        require("nvim-treesitter.configs").setup({
            context_commentstring = { enable = true, enable_autocmd = false },
        })
    end,
})

ts({
    "andymass/vim-matchup",
    cond = lambda.config.treesitter.use_matchup,
    event = "BufRead",
    keys = {
        {
            "<leader><leader>w",
            function()
                vim.cmd([[MatchupWhereAmI!]])
            end,
        },
    },
    config = function()
        vim.g.loaded_matchit = 1
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        -- vim.g.matchup_matchparen_offscreen = { method = "status_manual" }

        -- defer to better performance
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_deferred_show_delay = 50
        vim.g.matchup_matchparen_deferred_hide_delay = 500
        vim.cmd([[nmap <silent> <F7> <plug>(matchup-hi-surround)]])
        vim.cmd([[
function! s:matchup_convenience_maps()
  xnoremap <sid>(std-I) I
  xnoremap <sid>(std-A) A
  xmap <expr> I mode()=='<c-v>'?'<sid>(std-I)':(v:count?'':'1').'i'
  xmap <expr> A mode()=='<c-v>'?'<sid>(std-A)':(v:count?'':'1').'a'
  for l:v in ['', 'v', 'V', '<c-v>']
    execute 'omap <expr>' l:v.'I%' "(v:count?'':'1').'".l:v."i%'"
    execute 'omap <expr>' l:v.'A%' "(v:count?'':'1').'".l:v."a%'"
  endfor
endfunction
call s:matchup_convenience_maps()
            ]])
    end,
})

ts({
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
        local rainbow_delimiters = require("rainbow-delimiters")

        vim.g.rainbow_delimiters = {

            strategy = {
                [""] = rainbow_delimiters.strategy["global"],
            },
            query = {
                [""] = "rainbow-delimiters",
            },
        }
    end,
})
