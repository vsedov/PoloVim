local config = {}

function config.treesitter_init()
    local function is_inner(x, y)
        if x[1] < y[1] then
            return false
        end
        if (x[1] == y[1]) and (x[2] < y[2]) then
            return false
        end
        if x[3] > y[3] then
            return false
        end
        if (x[3] == y[3]) and (x[4] > y[4]) then
            return false
        end
        return true
    end

    local function is_same(x, y)
        for i, v in pairs(x) do
            if v ~= y[i] then
                return false
            end
        end
        return true
    end

    local function get_node_range(node)
        local a, b, c, d = require("nvim-treesitter.ts_utils").get_node_range(node)
        return { a, b, c, d }
    end

    local function get_curpos()
        local p = vim.api.nvim_win_get_cursor(0)
        return p[1] - 1, p[2] + 1
    end

    local function get_vrange()
        local r1, c1 = get_curpos()
        vim.cmd("normal! o")
        local r2, c2 = get_curpos()
        vim.cmd("normal! o")
        if (r1 == r2) and (c1 == c2) then
            return { r1, c1, r2, c2 }
        end
        if (r1 < r2) or ((r1 == r2) and (c1 < c2)) then
            return { r1, c1 - 1, r2, c2 }
        end
        return { r2, c2 - 1, r1, c1 }
    end

    vim.keymap.set("x", "v", function()
        local ts_utils = require("nvim-treesitter.ts_utils")
        local vrange = get_vrange()
        local node = ts_utils.get_node_at_cursor()
        local nrange = get_node_range(node)

        local parent
        while true do
            if is_inner(vrange, nrange) and not is_same(vrange, nrange) then
                break
            end
            parent = node:parent()
            if parent == nil then
                break
            end
            node = parent
            nrange = get_node_range(node)
        end
        ts_utils.update_selection(0, node)
    end, { desc = "node incremental selection" })
end

function config.nvim_treesitter()
    require("modules.treesitter.treesitter").treesitter()
end

function config.endwise()
    require("modules.treesitter.treesitter").endwise()
end

function config.treesitter_obj()
    require("modules.treesitter.treesitter").treesitter_obj()
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
    require("utils.ui.utils").plugin("hlargs", {

        theme = {
            ["*"] = { { Hlargs = { italic = true, foreground = "#A5D6FF" } } },
            ["horizon"] = { { Hlargs = { italic = true, foreground = { from = "Normal" } } } },
        },
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
            disable_virtual_text = false,
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
    local tm_fts = { "javascript", "python" } -- or any other langs

    require("nvim-treesitter.configs").setup({
        yati = {

            default_fallback = function(lnum, computed, bufnr)
                if vim.tbl_contains(tm_fts, vim.bo[bufnr].filetype) then
                    return require("tmindent").get_indent(lnum, bufnr) + computed
                end
                -- or any other fallback methods
                return require("nvim-yati.fallback").vim_auto(lnum, computed, bufnr)
            end,
            suppress_conflict_warning = true,
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

function config.context()
    require("nvim_context_vt").setup({})
end

function config.select_ease()
    local select_ease = require("SelectEase")

    local lua_query = [[
            ;; query
            ((identifier) @cap)
            ("string_content" @cap)
            ((true) @cap)
            ((false) @cap)
        ]]
    local python_query = [[
            ;; query
            ((identifier) @cap)
            ((string) @cap)
        ]]
    local queries = {
        lua = lua_query,
        python = python_query,
    }
    local function create_keymaps(key_bindings, query_direction)
        local keymaps = {}
        for _, binding in ipairs(key_bindings) do
            keymaps[binding] = {
                ["\\\\k"] = function()
                    select_ease.select_node({
                        queries = queries,
                        direction = query_direction,
                        vertical_drill_jump = true,
                    })
                end,
                ["\\\\j"] = function()
                    select_ease.select_node({
                        queries = queries,
                        direction = query_direction,
                        vertical_drill_jump = true,
                    })
                end,
                ["\\\\h"] = function()
                    select_ease.select_node({
                        queries = queries,
                        direction = query_direction,
                        current_line_only = true,
                    })
                end,
                ["\\\\l"] = function()
                    select_ease.select_node({
                        queries = queries,
                        direction = query_direction,
                        current_line_only = true,
                    })
                end,
                ["\\\\p"] = function()
                    select_ease.select_node({ queries = queries, direction = query_direction })
                end,
                ["\\\\n"] = function()
                    select_ease.select_node({ queries = queries, direction = query_direction })
                end,
            }
        end
        return keymaps
    end
    local key_bindings = {
        { "n", "s", "i" },
        { "n", "s", "t" },
        { "n", "s", "v" },
    }

    local keymaps_prev = create_keymaps(key_bindings, "previous")
    for val, keymap in pairs(keymaps_prev) do
        for x, y in pairs(keymap) do
            vim.keymap.set(val, x, y, { noremap = true })
        end
    end

    local keymaps_next = create_keymaps(key_bindings, "next")
    for val, keymap in pairs(keymaps_next) do
        for x, y in pairs(keymap) do
            vim.keymap.set(val, x, y, { noremap = true })
        end
    end
end
return config
