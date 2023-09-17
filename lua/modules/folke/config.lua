local config = {}
local toggle_noice = function()
    local oldbufnr = vim.api.nvim_get_current_buf()
    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(winnr) then
            local bufnr = vim.api.nvim_win_get_buf(winnr)
            if vim.bo[bufnr].filetype == "NoiceHistory" then
                vim.api.nvim_win_close(winnr, true)
            end
        end
    end
    require("noice").cmd("history")
    if oldbufnr ~= vim.api.nvim_get_current_buf() then
        vim.bo.filetype = "NoiceHistory"
    end
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
            { ft = "qf", title = "QuickFix" },
            { ft = "help", size = { height = 20 } },
            { ft = "spectre_panel", size = { height = 0.4 } },
            "terminal",
            { ft = "dapui_watches", title = "Watches" },
            { ft = "dap-repl", title = "Debug REPL" },
            { ft = "dapui_console", title = "Debug Console" },
            {
                ft = "Trouble",
                title = " Trouble",
                open = function()
                    require("trouble").toggle({ mode = "quickfix" })
                end,
            },
            {
                ft = "OverseerPanelTask",
                title = " Task",
                open = "OverseerQuickAction open",
            },
            {
                ft = "NoiceHistory",
                title = " Log",
                open = function()
                    toggle_noice()
                end,
            },
            {
                ft = "neotest-output-panel",
                title = " Test Output",
                open = function()
                    vim.cmd.vsplit()
                    require("neotest").output_panel.toggle()
                end,
            },
            {
                ft = "DiffviewFileHistory",
                title = " Diffs",
            },
        },
        left = {
            {
                title = "Neo-Tree",
                ft = "neo-tree",
                pinned = true,
                size = { height = 0.5 },
            },
            { ft = "undotree", title = "Undo Tree" },
            { ft = "dapui_scopes", title = "Scopes" },
            { ft = "dapui_breakpoints", title = "Breakpoints" },
            { ft = "dapui_stacks", title = "Stacks" },
            {
                ft = "diff",
                title = " Diffs",
            },

            {
                ft = "DiffviewFileHistory",
                title = " Diffs",
            },
            {
                ft = "DiffviewFiles",
                title = " Diffs",
            },
            {
                ft = "OverseerList",
                title = "  Tasks",
                open = "OverseerOpen",
                size = {
                    width = 0.35,
                },
            },
            {
                ft = "neotest-summary",
                title = "  Tests",
                open = function()
                    require("neotest").summary.toggle()
                end,
            },
        },
        right = {
            -- "dapui_scopes",
            "sagaoutline",
            "neotest-output-panel",
            "neotest-summary",

            {
                ft = "vista_kind",
                title = "Vista",
                open = "Vista",
                size = { height = 0.5 },
            },
        },

        options = {
            left = { size = 40 },
            bottom = { size = 20 },
            right = { size = 30 },
            top = { size = 10 },
        },
        -- edgebar animations
        animate = {
            enabled = lambda.config.folke.edge.use_animate,
        },
        keys = {
            -- close window
            ["q"] = function(win)
                win:close()
            end,
            -- hide window
            ["<c-q>"] = function(win)
                win:hide()
            end,
            -- close sidebar
            ["Q"] = function(win)
                win.view.edgebar:close()
            end,
            -- next open window
            ["]w"] = function(win)
                win:next({ visible = true, focus = true })
            end,
            -- previous open window
            ["[w"] = function(win)
                win:prev({ visible = true, focus = true })
            end,
            -- next loaded window
            ["]W"] = function(win)
                win:next({ pinned = false, focus = true })
            end,
            -- prev loaded window
            ["[W"] = function(win)
                win:prev({ pinned = false, focus = true })
            end,
            -- increase width
            ["<c-w>>"] = function(win)
                win:resize("width", 2)
            end,
            -- decrease width
            ["<c-w><lt>"] = function(win)
                win:resize("width", -2)
            end,
            -- increase height
            ["<c-w>+"] = function(win)
                win:resize("height", 2)
            end,
            -- decrease height
            ["<c-w>-"] = function(win)
                win:resize("height", -2)
            end,
            -- reset all custom sizing
            ["<c-w>="] = function(win)
                win.view.edgebar:equalize()
            end,
        },
        icons = {
            closed = " ",
            open = " ",
        },
        -- enable this on Neovim <= 0.10.0 to properly fold edgebar windows.
        -- Not needed on a nightly build >= June 5, 2023.
        fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
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
