local Flash = lambda.reqidx("flash")
local lib = require("modules.movement.flash.nav.lib")

local O = {
    goto_prefix = "<cr>",
    goto_next = "]",
    goto_previous = "[",
    goto_next_outer = "]]",
    goto_previous_outer = "[[",
    goto_next_end = "<leader>]", -- ")",
    goto_previous_end = "<leader>[", -- "(",
    goto_next_outer_end = "<leader>]]", -- "))",
    goto_previous_outer_end = "<leader>[[", -- "((",
    select = "&",
    select_dynamic = "m",
    select_remote = ";r",
    select_remote_dynamic = "ir",
    select_outer = "<M-S-7>", -- M-&
    select_next = "in",
    select_previous = "iN",
    select_next_outer = "an",
    select_previous_outer = "aN",
}

O.goto_prev = O.goto_previous
O.goto_prev_outer = O.goto_previous_outer
O.goto_prev_end = O.goto_previous_end -- "(",
O.goto_prev_outer_end = O.goto_previous_outer_end -- "((",
O.select_prev = O.select_previous
O.select_prev_outer = O.select_previous_outer
return {
    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Remote Jumps  and treesitter bindings                      │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "<c-w>",
        mode = { "o", "x" },
        function()
            Flash.remote()
        end,
        desc = "Remote Jump",
    },
    {
        "M", -- [M, r, <cr>]
        mode = { "n", "x", "o" },
        function()
            local win = vim.api.nvim_get_current_win()
            local view = vim.fn.winsaveview()
            Flash.jump({
                action = function(match, state)
                    state:hide()
                    vim.api.nvim_set_current_win(match.win)
                    vim.api.nvim_win_set_cursor(match.win, match.pos)
                    Flash.treesitter()
                    vim.schedule(function()
                        vim.api.nvim_set_current_win(win)
                        vim.fn.winrestview(view)
                    end)
                end,
            })
        end,
        desc = [[
            Jump to a position, make a Treesitter selection and jump back This should be bound to a keymap like M.
            Then you could o yM to remotely yank a Treesitter selection.
        ]],
    },

    {
        "R",
        function()
            Flash.treesitter_search({
                label = { before = true, after = true, style = "inline" },
                remote_op = { restore = true },
            })
        end,
        mode = { "n", "x", "o" },
        desc = "Treesitter Search | show labeled treesitter nodes around the search matches",
    },
    {
        O.select_remote_dynamic,
        mode = { "o" },
        desc = "Remote Node",
        function()
            require("flash").jump({ mode = ";remote_ts" })
        end,
    },
    {
        O.select_remote_dynamic .. O.select_remote_dynamic,
        mode = { "x" },
        desc = "Remote Node",
        function()
            require("flash").jump({ mode = ";remote_ts" })
        end,
    },
    {
        O.goto_next .. O.select_dynamic,
        mode = { "o", "x" },
        function()
            require("flash").jump({ mode = ";remote_ts", treesitter = { starting_from_pos = true } })
        end,
        desc = "Select node",
    },
    {
        O.goto_prev .. O.select_dynamic,
        mode = { "o", "x" },
        function()
            require("flash").jump({ mode = ";remote_ts", treesitter = { ending_at_pos = true } })
        end,
        desc = "Select node",
    },
    {
        O.goto_prev .. O.select_dynamic,
        mode = { "o", "x" },
        function()
            require("flash").jump({ mode = ";remote_ts", treesitter = { ending_at_pos = true } })
        end,
        desc = "Select node",
    },
    {
        "<c-g>" .. "w",
        -- TODO: allow searching continuations
        function()
            require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cword>") })
        end,
    },
    {
        "<c-g>" .. "W",
        function()
            require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cWORD>") })
        end,
    },
    {
        ";rX",
        mode = { "x", "n" },
        desc = "Exchange <motion1> with <node>",
        function()
            lib.swap_with({ mode = ";remote_ts" })
        end,
    },
    {
        ";rx",
        mode = { "x", "n" },
        desc = "Exchange <motion1> with <motion2>",
        function()
            lib.swap_with({})
        end,
    },
    -- TODO: Copy there, Paste here
    {
        ";rR", -- TODO: better keymap?
        mode = { "n" },
        desc = "Remote Replace",
        function()
            vim.api.nvim_feedkeys(";r", "m", false)
            vim.schedule(function()
                require("flash").jump({ mode = ";remote_ts" })
            end)
        end,
    },
    { -- TODO: this
        ";ry",
        mode = { "x", "n" },
        desc = "Replace with <remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- TODO: this
        ";rd",
        mode = { "x", "n" },
        desc = "Replace with d<remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- TODO: this
        ";rc",
        mode = { "x", "n" },
        desc = "Replace with c<remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- TODO: this
        ";rY",
        mode = { "n" },
        desc = "Replace with <node>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- TODO: this
        ";rD",
        mode = { "x", "n" },
        desc = "Replace with d<node>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- TODO: this
        ";rC",
        mode = { "x", "n" },
        desc = "Replace with c<node>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
}
