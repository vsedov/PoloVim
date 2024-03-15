local lib = require("modules.movement.flash.nav.lib")
local Flash = lambda.reqidx("flash")

return {
    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │ lsp                                                                │
    --  ╰────────────────────────────────────────────────────────────────────╯
    --  'gt' - go to definition
    -- 'gT' - go to type definition
    -- 'gr' - references
    -- 'gd' - go to declaration
    {
        "g;",
        -- https://github.com/folke/flash.nvim/discussions/79
        function()
            local prev_timeout = vim.opt.timeout

            vim.opt.timeout = false

            Flash.jump({
                action = function(match, state)
                    state:hide()

                    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

                    vim.api.nvim_set_current_win(match.win)
                    vim.api.nvim_win_set_cursor(match.win, match.pos)

                    local key = vim.api.nvim_replace_termcodes("<Ignore>" .. "g", true, true, true)

                    vim.api.nvim_feedkeys(key, "i", false)

                    vim.schedule(function()
                        vim.api.nvim_win_set_cursor(match.win, { row, col })
                        vim.opt.timeout = prev_timeout
                        require("flash.jump").restore_remote(state)
                    end)
                end,
                search = {
                    max_length = 2,
                },
                label = {
                    before = { 0, 2 },
                    after = false,
                },
            })
        end,
        desc = "Go to definition on jump",
    },
    {
        "<c-;>",
        desc = "Hover",
        function()
            Flash.jump({ mode = "hover" })
        end,
    },
    --  ──────────────────────────────────────────────────────────────────────
    {
        "D",
        mode = { "n" },
        function()
            vim.cmd.Lspsaga("show_cursor_diagnostics")
        end,
        desc = "Show diagnostics at target, without changing cursor position",
    },
    {
        ";d",
        mode = { "n" },
        function()
            lib.flash_diagnostics({
                action = function()
                    require("wtf").ai()
                end,
            })
        end,
        desc = "Debug diagnostic with AI",
    },
    {
        ";D",
        mode = { "n" },
        function()
            lib.flash_diagnostics({
                action = function()
                    require("wtf").search()
                end,
            })
        end,
        desc = "Search diagnostic with Google",
    },
    --  ──────────────────────────────────────────────────────────────────────
    {
        "gr",
        mode = { "n" },
        lib.flash_references,
        desc = "Flash Lsp References",
    },
    {
        "dD",
        function()
            lib.flash_diagnostics({
                action = require("actions-preview").code_actions,
            })
        end,
        desc = "Diagnostics + Code Action",
    },
}
