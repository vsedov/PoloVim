local Hydra = require("hydra")
local loader = require("packer").loader

local gitrepo = vim.fn.isdirectory(".git/index")
local line = vim.fn.line

local function wrap(fn, ...)
    local args = { ... }
    local nargs = select("#", ...)
    return function()
        fn(unpack(args, nargs))
    end
end
if gitrepo then
    loader("keymap-layer.nvim vgit.nvim gitsigns.nvim")

    local hint = [[
  ^^^^                           Git Files                              ^^^^
  ^^^^------------------------------------------------------------------^^^^
  _d_: diftree  _s_ stagehunk    _x_ show del   _b_ gutterView  _r_ reset_hunk
  _k_ proj diff _u_ unstage hunk _p_ view hunk  _B_ blameFull   _dd_ diffthis
  _J_: next hunk <--------------------------------------> _K_: prev hunk
  _D_ buf diff   _g_ diff staged _P_ projStaged _f_ proj hunkQF  _U_ unstagebuf
  _S_ stage buf  _G_ stage diff  _/_ show base

  _<Enter>_ Neogit _q_ exit
]]

    local gitsigns = require("gitsigns")
    local vgit = require("vgit")
    Hydra({
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                position = "bottom",
                border = "single",
            },
            on_enter = function()
                vim.bo.modifiable = false
                gitsigns.toggle_signs(true)
                gitsigns.toggle_linehl(true)
            end,
            on_exit = function()
                gitsigns.toggle_signs(false)
                gitsigns.toggle_linehl(false)
                gitsigns.toggle_deleted(false)
                vim.cmd("echo") -- clear the echo area
            end,
        },
        mode = { "n", "x" },
        body = "<leader>h",
        heads = {
            {
                "J",
                function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gitsigns.next_hunk()
                    end)
                    return "<Ignore>"
                end,
                { expr = true },
            },
            {
                "K",
                function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gitsigns.prev_hunk()
                    end)
                    return "<Ignore>"
                end,
                { expr = true },
            },

            { "d", ":DiffviewOpen<CR>", { silent = true, exit = true } },
            { "k", vgit.project_diff_preview, { exit = true } },
            { "s", ":Gitsigns stage_hunk<CR>", { silent = true } },
            { "u", gitsigns.undo_stage_hunk },
            { "S", gitsigns.stage_buffer },
            { "p", gitsigns.preview_hunk },
            { "x", gitsigns.toggle_deleted, { nowait = true } },

            { "r", gitsigns.reset_hunk },
            { "dd", wrap(gitsigns.diffthis, "~") },

            -- { "b", gitsigns.blame_line },
            { "b", vgit.buffer_gutter_blame_preview, { exit = true } },
            { "D", vgit.buffer_diff_preview, { exit = true } },
            { "g", vgit.buffer_diff_staged_preview, { exit = true } },
            { "P", vgit.project_staged_hunks_preview },
            { "f", vgit.project_hunks_qf },
            { "U", vgit.buffer_unstage },
            { "G", vgit.buffer_diff_staged_preview },
            {
                "B",
                function()
                    gitsigns.blame_line({ full = true })
                end,
            },
            { "/", gitsigns.show, { exit = true } }, -- show the base of the file
            { "<Enter>", "<cmd>Neogit<CR>", { exit = true } },
            { "q", nil, { exit = true, nowait = true } },
        },
    })
end
