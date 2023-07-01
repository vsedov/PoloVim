local Flash = lambda.reqidx("flash")

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
                highlight = {
                    label = { before = true, after = true, style = "inline" },
                },
                remote_op = { restore = true },
            })
        end,
        mode = { "n", "x", "o" },
        desc = "Treesitter Search | show labeled treesitter nodes around the search matches",
    },
}
