local config = {}
function config.nvim_treesitter()
    require("modules.treesitter.treesitter").treesitter()
end

function config.endwise()
    require("modules.treesitter.treesitter").endwise()
end

function config.treesitter_obj()
    require("modules.treesitter.treesitter").treesitter_obj()
end

function config.rainbow()
    require("modules.treesitter.treesitter").rainbow()
end

function config.treesitter_ref()
    require("modules.treesitter.treesitter").treesitter_ref()
end

function config.tsubject()
    require("nvim-treesitter.configs").setup({
        textsubjects = {
            enable = true,
            keymaps = { ["\\l"] = "textsubjects-smart", ["\\k"] = "textsubjects-container-outer" },
        },
    })
end

function config.playground()
    require("nvim-treesitter.configs").setup({
        playground = {
            enable = true,
            disable = {},
            updatetime = 50, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = true, -- Whether the query persists across vim sessions
        },
    })
end

function config.hlargs()
    require("utils.ui.highlights").plugin("hlargs", {
        { Hlargs = { fg = "#ef9062", italic = true, bold = false } },
    })
    require("hlargs").setup({
        color = "#ef9062",
        highlight = {},
        excluded_filetypes = {},
        paint_arg_declarations = true,
        paint_arg_usages = true,
        hl_priority = 10000,
        excluded_argnames = {
            declarations = {},
            usages = {
                python = { "self", "cls" },
                lua = { "self" },
            },
        },
        performance = {
            parse_delay = 1,
            slow_parse_delay = 50,
            max_iterations = 400,
            max_concurrent_partial_parses = 30,
            debounce = {
                partial_parse = 3,
                partial_insert_mode = 100,
                total_parse = 700,
                slow_parse = 5000,
            },
        },
    })
    lambda.command("HlargsEnable", function()
        require("hlargs").enable()
    end, {})
    lambda.command("HlargsDisable", function()
        require("hlargs").disable()
    end, {})
    lambda.command("HlargsToggle", function()
        require("hlargs").toggle()
    end, {})
end

function config.matchup_setup()
    vim.g.matchup_matchparen_nomode = "i"
    vim.g.matchup_matchparen_pumvisible = 0
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_deferred_show_delay = 150
    vim.g.matchup_matchparen_deferred_hide_delay = 300
    -- vim.g.matchup_matchparen_offscreen = {'method': 'popup'}
    vim.g.matchup_motion_override_Npercent = 0
    vim.g.matchup_surround_enabled = 1
    vim.g.matchup_motion_enabled = 1
    vim.g.matchup_text_obj_enabled = 1
    vim.g.matchup_transmute_enabled = 1
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_override_vimtex = 1

    vim.g.matchup_matchparen_offscreen = {
        method = "popup",
        fullwidth = 1,
    }
end
function config.matchup()
    vim.keymap.set("n", "\\w", "<cmd>MatchupWhereAmI??<cr>", { noremap = true })

    require("nvim-treesitter.configs").setup({
        matchup = {
            enable = true,
        },
    })
end

function config.hi_pairs()
    function setkey(k)
        local function out(kk, v)
            vim[k][kk] = v
        end

        return out
    end
    setglobal = setkey("g")
    setglobal("hiPairs_enable_matchParen", 0)
    setglobal("hiPairs_hl_matchPair", {
        term = "underline,bold",
        cterm = "underline,bold",
        ctermfg = "0",
        ctermbg = "180",
        gui = "underline,bold,italic",
        guifg = "#fb94ff",
        guibg = "NONE",
    })
end

function config.indent()
    local tm_fts = { "lua", "javascript", "python" } -- or any other langs

    require("nvim-treesitter.configs").setup({
        yati = {

            default_fallback = function(lnum, computed, bufnr)
                if vim.tbl_contains(tm_fts, vim.bo[bufnr].filetype) then
                    return require("tmindent").get_indent(lnum, bufnr) + computed
                end
                -- or any other fallback methods
                return require("nvim-yati.fallback").vim_auto(lnum, computed, bufnr)
            end,
            enable = true,
            default_lazy = true,
        },
    })
end

function config.paint()
    require("paint").setup({
        -- @type PaintHighlight[]
        highlights = {
            {
                filter = { filetype = "lua" },
                pattern = "%s(@%w+)",
                -- pattern = "%s*%-%-%-%s*(@%w+)",
                hl = "@parameter",
            },
            {
                filter = { filetype = "c" },
                -- pattern = "%s*%/%/%/%s*(@%w+)",
                pattern = "%s(@%w+)",
                hl = "@parameter",
            },
            {
                filter = { filetype = "python" },
                -- pattern = "%s*%/%/%/%s*(@%w+)",
                pattern = "%s(@%w+)",
                hl = "@parameter",
            },

            {
                filter = { filetype = "markdown" },
                pattern = "%*.-%*", -- *foo*
                hl = "Title",
            },
            {
                filter = { filetype = "markdown" },
                pattern = "%*%*.-%*%*", -- **foo**
                hl = "Error",
            },
            {
                filter = { filetype = "markdown" },
                pattern = "%s_.-_", --_foo_
                hl = "MoreMsg",
            },
            {
                filter = { filetype = "markdown" },
                pattern = "%s%`.-%`", -- `foo`
                hl = "Keyword",
            },
            {
                filter = { filetype = "markdown" },
                pattern = "%`%`%`.*", -- ```foo<CR>...<CR>```
                hl = "MoreMsg",
            },
        },
    })
end

function config.climber() end
function config.context()
    require("nvim_context_vt").setup({})
end
return config
