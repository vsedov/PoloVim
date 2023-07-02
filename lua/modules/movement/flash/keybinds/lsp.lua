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
        "J",
        desc = "Hover",
        function()
            Flash.jump({ mode = "hover" })
        end,
    },
    {
        "D",
        mode = { "n" },
        function()
            Flash.jump({
                pattern = ".", -- initialize pattern with any char
                matcher = function(win)
                    ---@param diag Diagnostic
                    return vim.tbl_map(function(diag)
                        return {
                            pos = { diag.lnum + 1, diag.col },
                            end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                        }
                    end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
                end,
                action = function(match, state)
                    vim.api.nvim_win_call(match.win, function()
                        vim.api.nvim_win_set_cursor(match.win, match.pos)
                        vim.diagnostic.open_float()
                        vim.api.nvim_win_set_cursor(match.win, state.pos)
                    end)
                end,
            })
            -- lib.flash_diagnostics(opts)
        end,
        desc = "Show diagnostics at target, without changing cursor position",
    },
    {
        "<leader>s",
        mode = { "n" },
        lib.flash_references,
        desc = "Flash Lsp References",
    },
    {
        "<leader>;",
        function()
            lib.flash_diagnostics({
                action = require("actions-preview").code_actions,
            })
        end,
        desc = "Diagnostics + Code Action",
    },
}
