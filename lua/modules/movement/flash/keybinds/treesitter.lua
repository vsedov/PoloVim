local Flash = lambda.reqidx("flash")
local lib = require("modules.movement.flash.nav.lib")

local O = {
    goto_prefix = ";;",
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
    select_remote = "r",
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
        mode = { "o", "x" },
        desc = "Remote Node",
        function()
            require("flash").jump({ mode = "remote_ts" })
        end,
    },
    {
        O.goto_next .. O.select_remote_dynamic,
        mode = { "o", "x" },
        function()
            require("flash").jump({ mode = "remote_ts", treesitter = { starting_from_pos = true } })
        end,
        desc = "Select node",
    },
    {
        O.goto_prev .. O.select_remote_dynamic,
        mode = { "o", "x" },
        function()
            require("flash").jump({ mode = "remote_ts", treesitter = { ending_at_pos = true } })
        end,
        desc = "Select node",
    },
    {
        O.goto_next .. O.select_remote_dynamic,
        mode = "n",
        function()
            require("flash").jump({ mode = "remote_ts", treesitter = { end_of_node = true }, jump = { pos = "end" } })
        end,
        desc = "Jump to end of node",
    },
    {
        O.goto_prev .. O.select_remote_dynamic,
        mode = "n",
        function()
            require("flash").jump({
                mode = "remote_ts",
                treesitter = { start_of_node = true },
                jump = { pos = "start" },
            })
        end,
        desc = "Jump to start of node",
    },
    {
        O.goto_prefix .. "w", -- TODO: stop verbs from being labels
        -- TODO: allow searching continuations
        function()
            require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cword>") })
        end,
        desc = "Flash <cword>",
    },
    {
        O.goto_prefix .. "W",
        function()
            require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cWORD>") })
        end,
        desc = "Flash <cWORD>",
    },
    {
        O.goto_prefix .. "n",
        function()
            require("flash").jump({ continue = true })
        end,
        desc = "Continue Flash",
    },
    {
        O.goto_prefix .. "hr",
        desc = "References",
        lib.flash_references,
    },
    {
        O.goto_prefix .. "hh",
        desc = "Hover",
        function()
            require("flash").jump({ mode = "hover" })
        end,
    },
    {
        "rix", -- TODO: better keymap?
        -- FIXME: its broken??
        mode = { "x", "n" },
        desc = "Exchange <motion1> with <node>",
        function()
            lib.swap_with({ mode = "remote_ts" })
        end,
    },
    -- TODO: y<motion><something><leap><motion>
    -- {
    --   "rx",
    --   mode = { "n", "x" },
    --   desc = "Exchange <motion1> with <motion2>",
    --   -- TODO: use leap?
    --   function()lib.swap_with() end,
    -- },
    -- {
    --   "rxx",
    --   mode = { "n", "x" },
    --   desc = "Exchange V<motion1> with V<motion2>",
    --   -- TODO: use leap?
    --   function()
    --lib.swap_with { exchange = {
    --       visual_mode = "V",
    --     } }
    --   end,
    -- },
    -- {
    --   "R",
    --   mode = { "n" },
    --   desc = "Remote Replace",
    --   function()
    --     vim.api.nvim_feedkeys("r", "m", false)
    --     vim.schedule(function() require("flash").jump {} end)
    --   end,
    -- },
    -- TODO: Copy there, Paste here
    { -- FIXME: this
        "ry",
        mode = { "x", "n" },
        desc = "Replace with <remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        "rd",
        mode = { "x", "n" },
        desc = "Replace with d<remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        "rc",
        mode = { "x", "n" },
        desc = "Replace with c<remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        "rY",
        mode = { "n" },
        desc = "Replace with <node>",
        function()
            lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        "rD",
        mode = { "x", "n" },
        desc = "Replace with d<node>",
        function()
            lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        "rC",
        mode = { "x", "n" },
        desc = "Replace with c<node>",
        function()
            lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
        end,
    },
}
