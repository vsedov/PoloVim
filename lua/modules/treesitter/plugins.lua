local conf = require("modules.treesitter.config")
local ts = require("core.pack").package
local function openURL()
    local opener
    if vim.fn.has("macunix") == 1 then
        opener = "open"
    elseif vim.fn.has("linux") == 1 then
        opener = "xdg-open"
    elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
        opener = "start"
    end
    local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
    vim.fn.system(openCommand)
end

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
    event = "VeryLazy",
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
                if vim.fn.indent(".") == 0 then
                    require("various-textobjs").entireBuffer()
                else
                    require("various-textobjs").indentation("inner", "inner")
                end
            end,
            mode = { "o", "x" },
            desc = "inner indentation",
        },
        {
            "gx",

            function()
                require("various-textobjs").url()
                local foundURL = vim.fn.mode():find("v")
                if foundURL then
                    vim.cmd.normal('"zy')
                    local url = vim.fn.getreg("z")
                    openURL(url)
                else
                    -- find all URLs in buffer
                    local urlPattern = require("various-textobjs.charwise-textobjs").urlPattern
                    local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
                    local urls = {}
                    for url in bufText:gmatch(urlPattern) do
                        table.insert(urls, url)
                    end
                    if #urls == 0 then
                        return
                    end

                    -- select one, use a plugin like dressing.nvim for nicer UI for
                    -- `vim.ui.select`
                    vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
                        if choice then
                            openURL(choice)
                        end
                    end)
                end
            end,
            mode = { "n" },
        },
        {
            "dsi",
            function()
                -- select outer indentation
                require("various-textobjs").indentation("outer", "outer")

                -- plugin only switches to visual mode when a textobj has been found
                local indentationFound = vim.fn.mode():find("V")
                if not indentationFound then
                    return
                end

                -- dedent indentation
                vim.cmd.normal({ "<", bang = true })

                -- delete surrounding lines
                local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
                local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
                vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
                vim.cmd(tostring(startBorderLn) .. " delete")
            end,
            mode = "n",
            { desc = "Delete Surrounding Indentation" },
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
    config = conf.treesitter_subj,
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
