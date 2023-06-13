local config = {}
function config.luadev()
    require("neodev").setup({
        enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
        runtime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.LSP and others
        plugins = false, -- installed opt or start plugins in pack path
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

function config.edgy()
    return {
        bottom = {
            -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
            { ft = "toggleterm", size = { height = 0.4 } },
            {
                ft = "lazyterm",
                title = "LazyTerm",
                size = { height = 0.4 },
                filter = function(buf)
                    return not vim.b[buf].lazyterm_cmd
                end,
            },
            "Trouble",
            { ft = "qf", title = "QuickFix" },
            { ft = "help", size = { height = 20 } },
            { ft = "spectre_panel", size = { height = 0.4 } },
            "dap-repl",
        },
        left = {
            -- Neo-tree filesystem always takes half the screen height
            {
                title = "Neo-Tree",
                ft = "neo-tree",
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == "filesystem"
                end,
                size = { height = 0.5 },
                open = "NeoTreeFocus",
            },
            {
                title = "Neo-Tree Git",
                ft = "neo-tree",
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == "git_status"
                end,
                pinned = true,
                open = "Neotree position=right git_status",
            },
            {
                title = "Neo-Tree Buffers",
                ft = "neo-tree",
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == "buffers"
                end,
                pinned = true,
                open = "Neotree position=top buffers",
            },
            {
                ft = "OverseerList",
                pinned = true,
                open = "OverseerToggle",
            },
            -- any other neo-tree windows
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
        },
        right = {
            "dapui_scopes",
            "neotest-output-panel",
            "neotest-summary",

            {
                ft = "vista_kind",
                title = "Vista",
                open = "Vista",
                size = { height = 0.5 },
            },
        },
    }
end
function config.which_key()
    lambda.highlight.plugin("whichkey", {
        theme = {
            ["*"] = { { WhichkeyFloat = { link = "NormalFloat" } } },
            horizon = { { WhichKeySeparator = { link = "Todo" } } },
        },
    })

    local wk = require("which-key")
    wk.setup({
        plugins = { spelling = { enabled = true } },
        window = { border = lambda.style.border.type_0 },
        layout = { align = "center" },
    })

    wk.register({
        ["i"] = {
            name = "inner textobject",
            rw = "inner word",
            rW = "inner WORD",
            rp = "inner paragraph",
            ["r["] = 'inner [] from "[" to the matching "]"',
            ["r]"] = "same as i[",
            ["r("] = "same as ib",
            ["r)"] = "same as ib",
            ["rb"] = "inner block from [( to )]",
            ["r>"] = "same as i<",
            ["r<"] = 'inner <> from "<" to the matching ">"',
            ["rt"] = "inner tag block",
            ["r{"] = "same as iB",
            ["r}"] = "same as iB",
            ["rB"] = "inner Block from [{ to }]",
            ['r"'] = "double quoted string without the quotes",
            ["r'"] = "single quoted string without the quotes",
            ["r`"] = "string in backticks without the backticks",
        },
        ["a"] = {
            name = "Around... textobject",
            rw = "inner word",
            rW = "inner WORD",
            rp = "inner paragraph",
            ["r["] = 'inner [] from "[" to the matching "]"',
            ["r]"] = "same as i[",
            ["r("] = "same as ib",
            ["r)"] = "same as ib",
            ["rb"] = "inner block from [( to )]",
            ["r>"] = "same as i<",
            ["r<"] = 'inner <> from "<" to the matching ">"',
            ["rt"] = "inner tag block",
            ["r{"] = "same as iB",
            ["r}"] = "same as iB",
            ["rB"] = "inner Block from [{ to }]",
            ['r"'] = "double quoted string without the quotes",
            ["r'"] = "single quoted string without the quotes",
            ["r`"] = "string in backticks without the backticks",
        },
    }, { mode = { "o", "v", "x" } })
end
return config
